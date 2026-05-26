import Foundation

struct SessionError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

enum SessionService {
    static func createBankingSession(cpf: String) async throws -> String {
        var request = URLRequest(url: AppConfig.apiHost.appendingPathComponent("external/kyc/session"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AppConfig.origin, forHTTPHeaderField: "Origin")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "token": AppConfig.apiToken,
            "cpf": cpf.filter(\.isNumber),
            "flow": "kyc-banking"
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw SessionError(message: "[\(statusCode)] Resposta inválida do servidor")
        }

        if let sid = json["session_id"] as? String
            ?? json["sessionId"] as? String
            ?? json["id"] as? String
            ?? json["uuid"] as? String {
            return sid
        }

        let msg = json["message"] as? String ?? "Session ID não encontrado na resposta"
        throw SessionError(message: "[\(statusCode)] \(msg)")
    }
}
