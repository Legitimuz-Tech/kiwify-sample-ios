import SwiftUI
import LegitimuzSDK

@main
struct KiwifyBankingDemoApp: App {
    init() {
        Legitimuz.configure(LegitimuzConfiguration(
            host: AppConfig.apiHost,
            token: AppConfig.apiToken,
            origin: AppConfig.origin,
            language: "pt-BR"
        ))
    }

    var body: some Scene {
        WindowGroup {
            BankingFlowView()
        }
    }
}
