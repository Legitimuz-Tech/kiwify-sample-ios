import SwiftUI
import UIKit

struct ResultView: View {
    let status: String
    let sessionId: String
    let onDismiss: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: statusIcon)
                    .font(.system(size: 72, weight: .medium))
                    .foregroundColor(statusColor)

                Text(statusTitle)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(statusColor)

                Text(statusSubtitle)
                    .font(.system(size: 15))
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Text(sessionId.count > 24 ? String(sessionId.prefix(24)) + "..." : sessionId)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
                    .padding(.top, 4)

                Spacer()

                Button(action: onDismiss) {
                    Text("Nova Verificação")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(UIColor(red: 0.114, green: 0.482, blue: 0.322, alpha: 1.0)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Resultado")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") { onDismiss() }
                }
            }
        }
    }

    private var statusIcon: String {
        switch status.lowercased() {
        case "approved": return "checkmark.circle.fill"
        case "rejected": return "xmark.circle.fill"
        default:         return "exclamationmark.triangle.fill"
        }
    }

    private var statusColor: Color {
        switch status.lowercased() {
        case "approved": return Color(UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0))
        case "rejected": return Color(UIColor.systemRed)
        default:         return Color(UIColor.systemOrange)
        }
    }

    private var statusTitle: String {
        switch status.lowercased() {
        case "approved": return "Aprovado"
        case "rejected": return "Reprovado"
        default:         return "Erro"
        }
    }

    private var statusSubtitle: String {
        switch status.lowercased() {
        case "approved": return "Verificação bancária concluída com sucesso."
        case "rejected": return "Não foi possível confirmar sua identidade."
        default:         return "Ocorreu um problema durante a verificação."
        }
    }
}
