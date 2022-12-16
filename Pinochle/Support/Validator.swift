//
//  Validator.swift
//  PinochleScorerUI
//
//  Created by Tom Trompeter on 10/9/22.
//

import UIKit

func validateIsNumbersString (testStringParam: String) -> Bool {
    //print("Starting validateIsNumbersString for: \(testStringParam)")
    var isValid = false
    if !testStringParam.isEmpty {
        let validValues = NSCharacterSet(charactersIn: "-01234567890").inverted
        let comparisonString = testStringParam.components(separatedBy: validValues)
        let filteredNumbers = comparisonString.joined(separator: "")
        isValid = testStringParam == filteredNumbers
        //print("validValues: \(validValues)")
        //print("comparisonString: \(comparisonString)")
        //print("filteredNumbers: \(filteredNumbers)")
        //print("isValid \(isValid)")
    }
    return isValid
}

func validateNumberTextFieldValues(numbersArrayParam: [String]) -> Bool {
    for aNumberString in numbersArrayParam {
        // Validate that TextField is not empty
        if aNumberString.isEmpty {
           return false
        }
        // Validate that TextField value is a number character 0,1,2,3,4,5,6,7,8,9 and - sign.
        if !validateIsNumbersString(testStringParam: aNumberString) {
            return false
        }
        // Validate that TextField value is a number in acceptable range.
        if !(0..<999 ~= Int(aNumberString)!) {
            return false
        }
    }
    return true
}

func validateNameSelectionsInSetup(playerNamesSetParam: Set<String>, firstDealerNameParam: String) -> Bool {
    var passValidation = false
    passValidation = !playerNamesSetParam.contains("Select")
    passValidation = !playerNamesSetParam.contains("")
    passValidation = firstDealerNameParam != "Select"
    passValidation = !firstDealerNameParam.isEmpty
    return passValidation
}

func validatePlayerNamesCountInSetup(matchPlayerNamesSetParam: Set<String>, numOfPlayersParam: Int) -> Bool {
    var passValidation = false
    // Validate that matchPlayerNames are set correctly - that there are 4 unique players
    // Since a Set only contains unique values, if there are the correct number of players for the match (3, 4, 5 or 6) they must be unique
    passValidation = matchPlayerNamesSetParam.count == numOfPlayersParam
    return passValidation
}

func validateFirstDealerNameSelectionInSetup(matchPlayerNamesSetParam: Set<String>, firstDealerNameParam: String) -> Bool {
    var passValidation = false
    // Validate that the firstDealer selected in the pickerView is one of the 4 players selected
    passValidation = matchPlayerNamesSetParam.contains(firstDealerNameParam)
    return passValidation
}

func validateName(proposedName: String) -> Bool {
    // criteria in regex.  See http://regexlib.com
    let nameTest = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]+(([\' ][a-zA-Z ])?[a-zA-Z]*)*$")
    // ^[a-zA-Z]+(([\'\,\.\- ][a-zA-Z ])?[a-zA-Z]*)*$
    // ^([a-zA-Z.\s']{1,50})$
    //"SELF MATCHES %@", "^[a-zA-Z]+(([\'\,\.\- ][a-zA-Z ])?[a-zA-Z]*)*$"
    
                                //"SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
    return nameTest.evaluate(with: proposedName)
}
