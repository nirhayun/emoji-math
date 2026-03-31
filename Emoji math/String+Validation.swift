// String+Validation.swift / Emoji Math

import Foundation

public extension String {
    func isNumber() -> Bool {
        !isEmpty
            && rangeOfCharacter(from: .decimalDigits) != nil
            && rangeOfCharacter(from: .letters) == nil
    }
}
