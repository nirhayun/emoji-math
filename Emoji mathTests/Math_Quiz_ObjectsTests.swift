//
//  EmojiMathTests.swift
//  Emoji mathTests
//

import XCTest
@testable import Emoji_math

final class EquationGeneratorTests: XCTestCase {

    func testGenerateAlternativeAnswersReturnsFourDistinctValues() {
        let answers = EquationGenerator.generateAlternativeAnswers(rightAnswer: 10, negativeAnswers: false)
        XCTAssertEqual(answers.count, 4)
        XCTAssertFalse(answers.contains(10), "Alternative answers should not contain the right answer")
        let uniqueAnswers = Set(answers)
        XCTAssertEqual(uniqueAnswers.count, 4, "All alternative answers should be distinct")
    }

    func testGenerateAlternativeAnswersWithSmallRightAnswer() {
        let answers = EquationGenerator.generateAlternativeAnswers(rightAnswer: 1, negativeAnswers: false)
        XCTAssertEqual(answers.count, 4)
        XCTAssertFalse(answers.contains(1))
    }

    func testGenerateAlternativeAnswersWithNegativeRight() {
        let answers = EquationGenerator.generateAlternativeAnswers(rightAnswer: -5, negativeAnswers: true)
        XCTAssertEqual(answers.count, 4)
        XCTAssertFalse(answers.contains(-5))
    }

    func testGenerateEquationsReturnsCorrectCount() {
        let equations = EquationGenerator.generateEquations(
            numberOfVariables: 2,
            limit: 5,
            operations: ["+"],
            difficulty: .EASY,
            allowNegativeResults: false,
            withFloat: false
        )
        XCTAssertEqual(equations.count, 3, "Should return numberOfVariables + 1 equations")
    }

    func testGenerateEquationsWithThreeVariables() {
        let equations = EquationGenerator.generateEquations(
            numberOfVariables: 3,
            limit: 10,
            operations: ["+", "-"],
            difficulty: .NORMAL,
            allowNegativeResults: false,
            withFloat: false
        )
        XCTAssertEqual(equations.count, 4)
    }

    func testEquationResultIsValid() {
        for _ in 0..<20 {
            let equations = EquationGenerator.generateEquations(
                numberOfVariables: 2,
                limit: 10,
                operations: ["+"],
                difficulty: .EASY,
                allowNegativeResults: false,
                withFloat: false
            )
            for equation in equations {
                let result = equation.last!
                XCTAssertNotNil(Int(result), "Result '\(result)' should be a valid integer")
            }
        }
    }
}

final class SaveDataTests: XCTestCase {

    var saveData: SaveData!

    override func setUp() {
        super.setUp()
        saveData = SaveData()
        saveData.resetAll()
    }

    func testDefaultScore() {
        XCTAssertEqual(saveData.getScore(), 0)
    }

    func testSetAndGetScore() {
        saveData.setUserScore(score: 42)
        XCTAssertEqual(saveData.getScore(), 42)
    }

    func testHintCapsAt99() {
        saveData.setHintHint(hint: 150)
        XCTAssertEqual(saveData.getHintHint(), 99)
    }

    func testDefaultSound() {
        XCTAssertTrue(saveData.isSoundOn())
    }

    func testToggleSound() {
        saveData.setSoundStatus(sound: false)
        XCTAssertFalse(saveData.isSoundOn())
    }

    func testResetAll() {
        saveData.setUserScore(score: 500)
        saveData.setHintHint(hint: 50)
        saveData.resetAll()
        XCTAssertEqual(saveData.getScore(), 0)
        XCTAssertEqual(saveData.getHintHint(), 3)
    }
}

final class StagesTests: XCTestCase {

    let stages = Stages()

    func testGetLevelByScoreReturnsZeroForNewPlayer() {
        XCTAssertEqual(stages.getLevelByScore(score: 0), 0)
    }

    func testGetLevelByScoreReturnsCorrectLevel() {
        XCTAssertEqual(stages.getLevelByScore(score: 6), 1)
        XCTAssertEqual(stages.getLevelByScore(score: 16), 2)
    }

    func testGetLevelByScoreReturnsFinalForHighScore() {
        let finalLevel = stages.getFinalLevel()
        XCTAssertEqual(stages.getLevelByScore(score: 999999), finalLevel)
    }

    func testStagesAreNotEmpty() {
        XCTAssertGreaterThan(stages.stages.count, 0)
    }

    func testAllStagesHaveIcons() {
        for stage in stages.stages {
            XCTAssertGreaterThan(stage.icons.count, 0)
        }
    }
}
