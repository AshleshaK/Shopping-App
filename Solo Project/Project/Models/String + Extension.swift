//
//  String + Extension.swift
//  Project
//
//  Created by Mac on 13/11/21.
//

import Foundation

extension String {
    
//MARK: Validate Email Function
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return applyPredicateOnRegex(regexstr: emailRegEx)
    }
    
//MARK: Validate Password Function
    
    func validatePassword(mini: Int = 8, max: Int = 100) -> Bool {
        var passRegEx = ""
        if mini >= max {
            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),}$"
        }
        else {
            passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{\(mini),\(max)}$"
        }
        return applyPredicateOnRegex(regexstr: passRegEx)
    }
    
//MARK: Validate Username Function
    
    func validateUsername(mini: Int = 1, max: Int = 100) -> Bool {
        var usernameRegEx = ""
        if mini >= max {
            usernameRegEx = "^[[A-Z]|[a-z]][[A-Z]|[a-z]|\\d|[_]]{\(mini),}$"
        }
        else {
            usernameRegEx = "^[[A-Z]|[a-z]][[A-Z]|[a-z]|\\d|[_]]{\(mini),\(max)}$"
        }
        return applyPredicateOnRegex(regexstr: usernameRegEx)
    }
    
//MARK: Apply Predicate Function
    
    func applyPredicateOnRegex(regexstr: String) -> Bool {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validateOtherString = NSPredicate(format: "SELF MATCHES %@", regexstr)
        let isvalidateOtherString = validateOtherString.evaluate(with: trimmedString)
        return isvalidateOtherString
    }
}
