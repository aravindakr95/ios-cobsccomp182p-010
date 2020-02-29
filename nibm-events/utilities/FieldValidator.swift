//
//  FieldValidator.swift
//  nibm-events
//
//  Created by Aravinda Rathnayake on 2/24/20.
//  Copyright © 2020 Aravinda Rathnayake. All rights reserved.
//

import Foundation

final class FieldValidator {
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@student\\.nibm\\.lk${2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    static func isValidPassword(password: String = "") -> Bool {
        // Minimum 8 characters at least 1 Uppercase, 1 Lowercase, 1 Number and 1 Special Character
        let passwordRegex = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: password)
    }

    static func isEqual(fieldOne: String, fieldTwo: String) -> Bool {
        return fieldOne == fieldTwo
    }

    static func isNotEmpty(count: Int, required: Int) -> Bool {
        return count >= required
    }

    static func isMatchFields(fieldOne: NETextField, fieldTwo: NETextField? = nil) -> Bool {
        if (fieldTwo?.text != nil) {
            return fieldOne.text == fieldTwo?.text
        }

        return true
    }

    static func validate(type: String, textField: NETextField, optionalField: NETextField? = nil) -> (Bool, String) {
        var isValid = false
        var validateData: (Bool, String) = (false, "")

        guard let text = textField.text else {
            return validateData
        }

        switch type {
        case "Email", "Reset Password":
            isValid = isNotEmpty(count: text.count, required: 5) && isValidEmail(email: text)
            validateData = (isValid, type)
        case "Contact Number":
            isValid = isNotEmpty(count: text.count, required: 10)
            validateData = (isValid, type)
        case "Password":
            isValid = isMatchFields(fieldOne: textField, fieldTwo: optionalField)
                && isValidPassword(password: text)
            validateData = (isValid, type)
        default:
            isValid = isNotEmpty(count: text.count, required: 1)
            validateData = (isValid, type)
        }

        return validateData
    }
}
