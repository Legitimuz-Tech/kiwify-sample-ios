import SwiftUI
import LegitimuzSDK

private enum Sheet: Identifiable {
    case verification(token: String)
    case result(status: String, sessionId: String)

    var id: String {
        switch self {
        case .verification(let t): return "v-\(t)"
        case .result(_, let sid): return "r-\(sid)"
        }
    }
}

struct BankingFlowView: View {
    @State private var cpf = ""
    @State private var isLoading = false
    @State private var activeSheet: Sheet?
    @State private var errorMessage: String?

    private var isCpfValid: Bool { CPFValidator.isValid(cpf) }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    header
                    cpfField
                    startButton
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture { hideKeyboard() }
        }
        .sheet(item: $activeSheet) { sheet in
            sheetContent(for: sheet)
        }
        .alert("Erro", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        ), presenting: errorMessage) { _ in
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: { msg in
            Text(msg)
        }
    }

    // MARK: Subviews

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 56, weight: .medium))
                .foregroundColor(Color(UIColor(red: 0.114, green: 0.482, blue: 0.322, alpha: 1.0)))

            Text("Verificação Bancária")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color(UIColor.label))

            Text("Informe seu CPF para iniciar o processo de KYC bancário.")
                .font(.system(size: 15))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 8)
    }

    private var cpfField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CPF")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(UIColor.secondaryLabel))
                .tracking(0.5)

            HStack {
                TextField("000.000.000-00", text: Binding(
                    get: { cpf },
                    set: { cpf = CPFValidator.format($0) }
                ))
                .keyboardType(.numberPad)
                .font(.system(size: 17))
                .foregroundColor(cpf.isEmpty ? Color(UIColor.label) : (isCpfValid ? .green : .red))

                if !cpf.isEmpty {
                    Image(systemName: isCpfValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCpfValid ? .green : .red)
                        .font(.system(size: 17))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        cpf.isEmpty ? Color.clear : (isCpfValid ? Color.green.opacity(0.4) : Color.red.opacity(0.4)),
                        lineWidth: 1
                    )
            )
        }
    }

    private var startButton: some View {
        Button(action: startVerification) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.85)
                }
                Text(isLoading ? "Criando sessão..." : "Iniciar")
                    .font(.system(size: 17, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isCpfValid && !isLoading
                    ? Color(UIColor(red: 0.114, green: 0.482, blue: 0.322, alpha: 1.0))
                    : Color(UIColor(red: 0.114, green: 0.482, blue: 0.322, alpha: 0.4))
            )
            .foregroundColor(.white)
            .cornerRadius(14)
        }
        .disabled(!isCpfValid || isLoading)
    }

    // MARK: Sheet

    @ViewBuilder
    private func sheetContent(for sheet: Sheet) -> some View {
        switch sheet {
        case .verification(let token):
            SDKVerificationView(sessionToken: token) { result in
                switch result {
                case .success(let r):
                    activeSheet = .result(status: r.status.rawValue, sessionId: r.sessionId)
                case .failure(let e):
                    activeSheet = .result(status: "error", sessionId: "\(e)")
                }
            }
        case .result(let status, let sessionId):
            ResultView(status: status, sessionId: sessionId) {
                activeSheet = nil
            }
        }
    }

    // MARK: Actions

    private func startVerification() {
        guard isCpfValid else { return }
        isLoading = true
        Task {
            do {
                let token = try await SessionService.createBankingSession(cpf: cpf)
                activeSheet = .verification(token: token)
            } catch let e as SessionError {
                errorMessage = e.message
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
