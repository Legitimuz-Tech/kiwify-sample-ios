import SwiftUI
import LegitimuzSDK

struct SDKVerificationView: UIViewControllerRepresentable {
    let sessionToken: String
    let onCompletion: (Result<KycResult, KycError>) -> Void

    func makeUIViewController(context: Context) -> SDKBridgeViewController {
        let vc = SDKBridgeViewController(sessionToken: sessionToken, onCompletion: onCompletion)
        vc.start()
        return vc
    }

    func updateUIViewController(_ uiViewController: SDKBridgeViewController, context: Context) {}
}

final class SDKBridgeViewController: UIViewController {
    private let sessionToken: String
    private let onCompletion: (Result<KycResult, KycError>) -> Void

    init(sessionToken: String, onCompletion: @escaping (Result<KycResult, KycError>) -> Void) {
        self.sessionToken = sessionToken
        self.onCompletion = onCompletion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            Legitimuz.shared.startVerification(
                sessionToken: self.sessionToken,
                from: self,
                flow: FlowConfiguration(),
                theme: nil,
                closeButton: nil
            ) { [weak self] result in
                self?.onCompletion(result)
            }
        }
    }
}
