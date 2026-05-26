import Foundation

enum CPFValidator {
    static func format(_ raw: String) -> String {
        let digits = String(raw.filter(\.isNumber).prefix(11))
        var result = ""
        for (i, ch) in digits.enumerated() {
            if i == 3 || i == 6 { result += "." }
            if i == 9 { result += "-" }
            result.append(ch)
        }
        return result
    }

    static func isValid(_ cpf: String) -> Bool {
        let digits = cpf.filter(\.isNumber)
        guard digits.count == 11 else { return false }
        guard Set(digits).count > 1 else { return false }
        let nums = digits.compactMap(\.wholeNumberValue)

        func checkDigit(count: Int, base: Int) -> Int {
            let sum = (0..<count).reduce(0) { $0 + nums[$1] * (base - $1) }
            let r = sum % 11
            return r < 2 ? 0 : 11 - r
        }

        return checkDigit(count: 9, base: 10) == nums[9] &&
               checkDigit(count: 10, base: 11) == nums[10]
    }
}
