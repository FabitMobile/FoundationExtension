import Foundation

public extension String {
    var length: Int {
        count
    }
}

// MARK: localization

public extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }

    func localized(_ arguments: CVarArg...) -> String {
        String(format: localized(), arguments: arguments)
    }
}

// MARK: regexp

public extension String {
    func replacingByRegExp(of: String, with: String) -> String {
        replacingOccurrences(of: of,
                             with: with,
                             options: String.CompareOptions.regularExpression,
                             range: startIndex ..< endIndex)
    }
}

public extension String {
    func containsMatch(pattern: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, options: .init(rawValue: 0))
        let range = NSRange(location: 0, length: length)
        guard let result = regex?.firstMatch(in: self, options: .init(rawValue: 0), range: range) else { return false }
        return result.range.length > 0
    }

    var isEmail: Bool {
        containsMatch(pattern: "[A-ZА-Я0-9a-zа-я._%+-]+@[A-ZА-Я0-9a-zа-я.-]+\\.[A-ZА-Я0-9a-zа-я]{2,64}")
    }

    var isNumber: Bool {
        containsMatch(pattern: "\\d*")
    }

    var isLetter: Bool {
        containsMatch(pattern: "[A-ZА-Яa-zа-я]")
    }

    var isValidPassword: Bool {
        containsMatch(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$")
    }
}
