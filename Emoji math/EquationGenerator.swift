//
//  EquationGenerator.swift
//  Emoji Math
//
//  Created by Nir Hayun on 29/07/2017.
//  Copyright © 2017 Nir Hayun. All rights reserved.
//

import Foundation

enum Difficulty {
    case EASY
    case NORMAL
    case HARD
}

struct EquationGenerator {

    static let numberOfElements = 3

    static let plusOperations: [String] = ["+"]
    static let plusMinusOperations: [String] = ["+", "-"]
    static let plusMultiplyOperations: [String] = ["+", "*"]
    static let plusMultiplyMinusOperations: [String] = ["+", "*", "-"]
    static let allOperations: [String] = ["+", "*", "/", "-"]

    static func generateEquations(numberOfVariables: Int, limit: Int, operations: [String], difficulty: Difficulty, allowNegativeResults: Bool, withFloat: Bool) -> [[String]] {
        let equationsVariables: [Int] = generateNumbers(numberOfVariables: numberOfVariables, limit: limit, operations: operations)
        var equations: [[String]] = []
        var allEquations = Set<String>()

        for equationNum in 0...(numberOfVariables - 1) {
            var equation: [String] = generateEquation(equationsVariables: equationsVariables, numberOfVariables: numberOfVariables, equationNum: equationNum, limit: limit, operations: operations, difficulty: difficulty, allowNegativeResults: allowNegativeResults, withFloat: withFloat)

            var equationAsString = equation.joined(separator: "-")
            while allEquations.contains(equationAsString) {
                equation = generateEquation(equationsVariables: equationsVariables, numberOfVariables: numberOfVariables, equationNum: equationNum, limit: limit, operations: operations, difficulty: difficulty, allowNegativeResults: allowNegativeResults, withFloat: withFloat)

                equationAsString = equation.joined(separator: "-")
            }

            allEquations.insert(equationAsString)

            equations.append(equation)
        }

        var questionEquation: [String] = generateEquation(equationsVariables: equationsVariables, numberOfVariables: numberOfVariables, equationNum: numberOfVariables, limit: limit, operations: operations, difficulty: Difficulty.HARD, allowNegativeResults: allowNegativeResults, withFloat: withFloat)

        var equationAsString = questionEquation.joined(separator: "-")

        while allEquations.contains(equationAsString) {
            questionEquation = generateEquation(equationsVariables: equationsVariables, numberOfVariables: numberOfVariables, equationNum: numberOfVariables, limit: limit, operations: operations, difficulty: Difficulty.HARD, allowNegativeResults: allowNegativeResults, withFloat: withFloat)

            equationAsString = questionEquation.joined(separator: "-")
        }

        allEquations.insert(equationAsString)

        equations.append(questionEquation)

        return equations
    }

    static func atLeastOneVariableInEachEquation(equations: [[String]]) -> Bool {
        var equationsVariables: [Int: Int] = [:]

        for i in 0..<equations.count {
            for j in 0..<equations[i].count {
                let num = Int(equations[i][j])
                if equationsVariables[num!] != nil {
                    equationsVariables[num!] = 1
                }
            }
        }

        if equationsVariables.keys.count == 4 {
            return true
        }

        return false
    }

    private static func generateEquation(equationsVariables: [Int], numberOfVariables: Int, equationNum: Int, limit: Int, operations: [String], difficulty: Difficulty, allowNegativeResults: Bool, withFloat: Bool) -> [String] {
        var numbers: [Int] = []
        var indexCounter = 0
        var myOperations = operations
        if numberOfVariables == 4 && equationNum == 0 {
            if let divideIndex = myOperations.firstIndex(of: "/") {
                myOperations.remove(at: divideIndex)
            }
        }
        var returnedOperations: [String] = []
        for varNum in 0...(numberOfElements - 1) {
            var index = equationNum
            if difficulty == Difficulty.NORMAL {
                index = indexCounter
                if equationNum == 0 {
                    if let minusIndex = myOperations.firstIndex(of: "-") {
                        myOperations.remove(at: minusIndex)
                    }
                }
                if indexCounter >= equationNum {
                    indexCounter = 0
                } else {
                    indexCounter += 1
                    if numberOfVariables == 4 && equationNum == 3 && varNum == 0 {
                        indexCounter += 1
                    }
                }
            } else if difficulty == Difficulty.HARD {
                index = indexCounter
                if numberOfVariables == 4 && equationNum == 0 && varNum == 2 {
                    index = 3
                }
                if numberOfVariables == 4 && equationNum == 2 && varNum == 1 {
                    index = 3
                }
                if equationNum == 4 && varNum == 0 {
                    index = Int.random(in: 0..<3)
                    indexCounter = index + 1
                }
                if indexCounter >= (equationsVariables.count - 1) {
                    indexCounter = 0
                } else {
                    indexCounter += 1
                }
            }
            let number = equationsVariables[index]
            if varNum == (numberOfElements - 1) {
                numbers.append(number)
            } else {
                let opIndex = Int.random(in: 0..<myOperations.count)
                let op = myOperations[opIndex]
                if op == "/" {
                    myOperations.remove(at: opIndex)
                }
                returnedOperations.append(op)
                numbers.append(number)
                if equationNum == 1 && (difficulty == Difficulty.NORMAL || numberOfVariables == 2) {
                    switch op {
                    case "+":
                        if let i = myOperations.firstIndex(of: "-") {
                            myOperations.remove(at: i)
                        }
                    case "-":
                        if let i = myOperations.firstIndex(of: "+") {
                            myOperations.remove(at: i)
                        }
                    case "*":
                        if let i = myOperations.firstIndex(of: "/") {
                            myOperations.remove(at: i)
                        }
                    default:
                        if let i = myOperations.firstIndex(of: "*") {
                            myOperations.remove(at: i)
                        }
                    }
                }
            }
        }
        if !withFloat {
            (numbers, returnedOperations) = organizeEquation(numbers: numbers, equationsVariables: equationsVariables, operations: returnedOperations)
        }

        return convertEquation(numbers: numbers, operations: returnedOperations, allowNegativeResults: allowNegativeResults)
    }

    private static func numbersAndOperationsToString(numbers: [Int], operations: [String]) -> [String] {
        var returnString: [String] = []

        for i in 0...(numbers.count - 2) {
            returnString.append("\(Double(numbers[i]))")
            returnString.append(operations[i])
        }
        returnString.append("\(Double(numbers[numbers.count - 1]))")
        return returnString
    }

    private static func convertEquation(numbers: [Int], operations: [String], allowNegativeResults: Bool) -> [String] {
        var returnString = numbersAndOperationsToString(numbers: numbers, operations: operations)

        var exp = NSExpression(format: returnString.joined())
        var result = exp.expressionValue(with: nil, context: nil) as! Double

        if !allowNegativeResults {
            if result < 0 {
                var index = searchIndex(operations: operations, searchString: "-")
                var myOperations = operations
                while index != -1 {
                    myOperations.remove(at: index)
                    myOperations.insert("+", at: index)
                    index = searchIndex(operations: myOperations, searchString: "-")
                }

                returnString = numbersAndOperationsToString(numbers: numbers, operations: myOperations)

                exp = NSExpression(format: returnString.joined())
                result = exp.expressionValue(with: nil, context: nil) as! Double
            }
        }

        if floor(result) == result {
            returnString.append("=")
            returnString.append(String(Int(result)))
        } else {
            let printRes = String(format: "%.2f", arguments: [result])
            returnString.append("=")
            returnString.append(printRes)
        }

        returnString.remove(at: returnString.count - 2)

        return returnString
    }

    private static func searchIndex(operations: [String], searchString: String) -> Int {
        for i in 0...(operations.count - 1) {
            if operations[i] == searchString {
                return i
            }
        }
        return -1
    }

    private static func setDivideOperationFirst(operations: [String]) -> [String] {
        let divideIndex = searchIndex(operations: operations, searchString: "/")
        var myOperations = operations
        let element = myOperations.remove(at: divideIndex)
        myOperations.insert(element, at: 0)
        return myOperations
    }

    private static func setMaxFirstAndSetDividerSecond(numbers: [Int], equationsVariables: [Int]) -> [Int] {
        var myNumbers = numbers
        myNumbers = myNumbers.sorted().reversed()
        var allNumbers = equationsVariables
        allNumbers = allNumbers.sorted().reversed()
        myNumbers[0] = allNumbers[0]
        let firstNum = myNumbers[0]
        var currentNum: Int

        for i in 1...(myNumbers.count - 1) {
            currentNum = myNumbers[i]
            if firstNum % currentNum == 0 {
                myNumbers.remove(at: i)
                myNumbers.insert(currentNum, at: 1)
            }
        }

        if firstNum % myNumbers[1] != 0 {
            for i in 1...(equationsVariables.count - 1) {
                currentNum = equationsVariables[i]
                if (firstNum % currentNum == 0) && (firstNum > currentNum) {
                    myNumbers.remove(at: 1)
                    myNumbers.insert(currentNum, at: 1)
                }
            }
        }

        return myNumbers
    }

    private static func organizeEquation(numbers: [Int], equationsVariables: [Int], operations: [String]) -> (numbers: [Int], operations: [String]) {
        var myNumbers = numbers
        var myOperations: [String] = operations
        if operations.contains("/") {
            myOperations = setDivideOperationFirst(operations: operations)
            myNumbers = setMaxFirstAndSetDividerSecond(numbers: numbers, equationsVariables: equationsVariables)
        }

        return (myNumbers, myOperations)
    }

    private static func generateNumbers(numberOfVariables: Int, limit: Int, operations: [String]) -> [Int] {
        var elementsArray: [Int] = []
        var ingredients = Set<Int>()

        for _ in 1...numberOfVariables {
            var newNum = Int.random(in: 1...limit)
            while ingredients.contains(newNum) {
                newNum = Int.random(in: 1...limit)
            }
            ingredients.insert(newNum)
            elementsArray.append(newNum)
        }

        if operations.contains("/") {
            var currentNum = 0
            var dividesWithNoRemainder = false
            let max = elementsArray.max()!
            for i in 0...(elementsArray.count - 1) {
                currentNum = elementsArray[i]
                if currentNum != max {
                    if max % currentNum == 0 {
                        elementsArray.remove(at: i)
                        elementsArray.insert(currentNum, at: i)
                        dividesWithNoRemainder = true
                    }
                }
            }
            if !dividesWithNoRemainder {
                var divideSearchIterations = 0
                while !dividesWithNoRemainder && divideSearchIterations < 1000 {
                    divideSearchIterations += 1
                    var newNum = Int.random(in: 1...limit)
                    while ingredients.contains(newNum) {
                        newNum = Int.random(in: 1...limit)
                    }
                    if max % newNum == 0 {
                        var removalIndex = 0
                        if elementsArray[removalIndex] == max {
                            removalIndex = 1
                        }
                        elementsArray.remove(at: removalIndex)
                        elementsArray.insert(newNum, at: removalIndex)
                        dividesWithNoRemainder = true
                    }
                }
            }
        }

        return elementsArray
    }

    static func generateAlternativeAnswers(rightAnswer: Int, negativeAnswers: Bool) -> [Int] {
        var numbers = Set<Int>()
        let negativeOrNot: [Int] = [1, -1]
        var negativeIndex: Int = 0
        var range = rightAnswer * 2

        if range < 0 {
            range *= -1
        }

        if range < 5 {
            range = 10
        }

        var iterations = 0
        while numbers.count < 4 && iterations < 1000 {
            iterations += 1
            var alternativeNum = Int.random(in: 1...range)
            if negativeAnswers {
                negativeIndex = Int.random(in: 0..<1)
                alternativeNum = alternativeNum * negativeOrNot[negativeIndex]
            }
            if alternativeNum != rightAnswer {
                numbers.insert(alternativeNum)
            }
        }

        var pad = 1
        while numbers.count < 4 {
            numbers.insert(rightAnswer + pad)
            pad += 1
        }

        return Array(numbers)
    }
}
