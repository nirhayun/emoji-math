//
//  Stages.swift
//  Emoji Math
//
//  Created by Nir Hayun on 30/11/2017.
//  Copyright © 2017 Nir Hayun. All rights reserved.
//

import UIKit

struct Stage {
    let numberOfVariables: Int
    let limit: Int
    let timer: Int
    let addScore: Int
    let operations: [String]
    let difficulty: Difficulty
    let allowNegativeResults: Bool
    let withFloat: Bool
    let nextLevelScore: Int
    let levelTheme: String
    let icons: [String]
    let buttonColor: UIColor
    let backgroundColor: UIColor
    let textColor: UIColor
}

class Stages {
    let stages: [Stage]

    init() {
        stages = [
            // Plus and minus operations, two variables
            Stage(
                numberOfVariables: 2, limit: 5, timer: 30, addScore: 1,
                operations: EquationGenerator.plusOperations,
                difficulty: .EASY, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 5, levelTheme: "Hats",
                icons: ["hat.1", "hat.2", "hat.3", "hat.4", "hat.5", "hat.6", "hat.7", "hat.8"],
                buttonColor: UIColor(red: 209 / 255.0, green: 166 / 255.0, blue: 131 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 26 / 255.0, green: 44 / 255.0, blue: 87 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 2, limit: 7, timer: 40, addScore: 2,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .EASY, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 15, levelTheme: "Animals",
                icons: ["animal.1", "animal.2", "animal.3", "animal.4", "animal.5", "animal.6", "animal.7", "animal.8"],
                buttonColor: UIColor(red: 64 / 255.0, green: 46 / 255.0, blue: 32 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 106 / 255.0, green: 170 / 255.0, blue: 214 / 255.0, alpha: 1),
                textColor: .black
            ),
            Stage(
                numberOfVariables: 2, limit: 10, timer: 30, addScore: 2,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .EASY, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 25, levelTheme: "Beers",
                icons: ["beer.1", "beer.2", "beer.3", "beer.4", "beer.5", "beer.6"],
                buttonColor: UIColor(red: 189 / 255.0, green: 198 / 255.0, blue: 193 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 82 / 255.0, green: 96 / 255.0, blue: 96 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 2, limit: 12, timer: 40, addScore: 3,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 45, levelTheme: "Fruits",
                icons: ["fruit.1", "fruit.2", "fruit.3", "fruit.4", "fruit.5", "fruit.6", "fruit.7", "fruit.8"],
                buttonColor: UIColor(red: 205 / 255.0, green: 170 / 255.0, blue: 105 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 42 / 255.0, green: 28 / 255.0, blue: 45 / 255.0, alpha: 1),
                textColor: .white
            ),

            // Plus and minus operations, three variables
            Stage(
                numberOfVariables: 3, limit: 15, timer: 40, addScore: 3,
                operations: EquationGenerator.plusOperations,
                difficulty: .EASY, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 75, levelTheme: "Vegetables",
                icons: ["vegetable.1", "vegetable.2", "vegetable.3", "vegetable.4", "vegetable.5", "vegetable.6", "vegetable.7", "vegetable.8"],
                buttonColor: UIColor(red: 244 / 255.0, green: 182 / 255.0, blue: 53 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 221 / 255.0, green: 239 / 255.0, blue: 224 / 255.0, alpha: 1),
                textColor: .black
            ),
            Stage(
                numberOfVariables: 3, limit: 15, timer: 45, addScore: 4,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .EASY, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 115, levelTheme: "Buildings",
                icons: ["building.1", "building.2", "building.3", "building.4", "building.5", "building.6", "building.7", "building.8"],
                buttonColor: UIColor(red: 188 / 255.0, green: 140 / 255.0, blue: 83 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 25 / 255.0, green: 36 / 255.0, blue: 49 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 20, timer: 45, addScore: 5,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 160, levelTheme: "Electronics",
                icons: ["electronics.1", "electronics.2", "electronics.3", "electronics.4", "electronics.5", "electronics.6", "electronics.7", "electronics.8"],
                buttonColor: UIColor(red: 180 / 255.0, green: 89 / 255.0, blue: 141 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 149 / 255.0, green: 179 / 255.0, blue: 172 / 255.0, alpha: 1),
                textColor: .white
            ),

            // Plus and minus operations, four variables
            Stage(
                numberOfVariables: 4, limit: 10, timer: 50, addScore: 5,
                operations: EquationGenerator.plusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 200, levelTheme: "Health",
                icons: ["health.1", "health.2", "health.3", "health.4", "health.5", "health.6", "health.7", "health.8"],
                buttonColor: UIColor(red: 255 / 255.0, green: 195 / 255.0, blue: 102 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 112 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 15, timer: 45, addScore: 6,
                operations: EquationGenerator.plusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 250, levelTheme: "Films",
                icons: ["film.1", "film.2", "film.3", "film.4", "film.5", "film.6", "film.7", "film.8"],
                buttonColor: UIColor(red: 206 / 255.0, green: 186 / 255.0, blue: 113 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 31 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 10, timer: 40, addScore: 6,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 300, levelTheme: "Sewing",
                icons: ["sewing.1", "sewing.2", "sewing.3", "sewing.4", "sewing.5", "sewing.6", "sewing.7", "sewing.8"],
                buttonColor: UIColor(red: 147 / 255.0, green: 130 / 255.0, blue: 121 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 77 / 255.0, green: 100 / 255.0, blue: 126 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 25, timer: 150, addScore: 7,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 360, levelTheme: "Candies",
                icons: ["candy.1", "candy.2", "candy.3", "candy.4", "candy.5", "candy.6", "candy.7", "candy.8"],
                buttonColor: UIColor(red: 197 / 255.0, green: 153 / 255.0, blue: 109 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 128 / 255.0, green: 94 / 255.0, blue: 76 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 30, timer: 130, addScore: 7,
                operations: EquationGenerator.plusMinusOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 430, levelTheme: "Alcohol",
                icons: ["alcohol.1", "alcohol.2", "alcohol.3", "alcohol.4", "alcohol.5", "alcohol.6", "alcohol.7", "alcohol.8"],
                buttonColor: UIColor(red: 77 / 255.0, green: 197 / 255.0, blue: 239 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 44 / 255.0, green: 48 / 255.0, blue: 60 / 255.0, alpha: 1),
                textColor: .white
            ),

            // Plus multiply operations
            Stage(
                numberOfVariables: 2, limit: 10, timer: 40, addScore: 8,
                operations: EquationGenerator.plusMultiplyOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 500, levelTheme: "Space",
                icons: ["space.1", "space.2", "space.3", "space.4", "space.5", "space.6", "space.7", "space.8"],
                buttonColor: UIColor(red: 247 / 255.0, green: 188 / 255.0, blue: 149 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 84 / 255.0, green: 42 / 255.0, blue: 58 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 10, timer: 30, addScore: 8,
                operations: EquationGenerator.plusMultiplyOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 580, levelTheme: "Clothing",
                icons: ["cloth.1", "cloth.2", "cloth.3", "cloth.4", "cloth.5", "cloth.6", "cloth.7", "cloth.8"],
                buttonColor: UIColor(red: 147 / 255.0, green: 230 / 255.0, blue: 120 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 22 / 255.0, green: 118 / 255.0, blue: 185 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 15, timer: 120, addScore: 9,
                operations: EquationGenerator.plusMultiplyOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 700, levelTheme: "Pastries",
                icons: ["pastry.1", "pastry.2", "pastry.3", "pastry.4", "pastry.5", "pastry.6", "pastry.7", "pastry.8"],
                buttonColor: UIColor(red: 250 / 255.0, green: 187 / 255.0, blue: 147 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 44 / 255.0, green: 48 / 255.0, blue: 60 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 10, timer: 50, addScore: 9,
                operations: EquationGenerator.plusMultiplyOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 800, levelTheme: "Tools",
                icons: ["tool.1", "tool.2", "tool.3", "tool.4", "tool.5", "tool.6", "tool.7", "tool.8"],
                buttonColor: UIColor(red: 222 / 255.0, green: 165 / 255.0, blue: 39 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 7 / 255.0, green: 8 / 255.0, blue: 9 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 15, timer: 360, addScore: 10,
                operations: EquationGenerator.plusMultiplyOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 900, levelTheme: "Sport",
                icons: ["sport.1", "sport.2", "sport.3", "sport.4", "sport.5", "sport.6", "sport.7", "sport.8"],
                buttonColor: UIColor(red: 166 / 255.0, green: 109 / 255.0, blue: 63 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 59 / 255.0, green: 20 / 255.0, blue: 19 / 255.0, alpha: 1),
                textColor: .white
            ),

            // Plus multiply minus operations
            Stage(
                numberOfVariables: 2, limit: 10, timer: 30, addScore: 10,
                operations: EquationGenerator.plusMultiplyMinusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 1000, levelTheme: "Stationery",
                icons: ["stationery.1", "stationery.2", "stationery.3", "stationery.4", "stationery.5", "stationery.6", "stationery.7", "stationery.8"],
                buttonColor: UIColor(red: 252 / 255.0, green: 207 / 255.0, blue: 114 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 43 / 255.0, green: 42 / 255.0, blue: 40 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 15, timer: 40, addScore: 11,
                operations: EquationGenerator.plusMultiplyMinusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 1100, levelTheme: "Holidays",
                icons: ["holiday.1", "holiday.2", "holiday.3", "holiday.4", "holiday.5", "holiday.6", "holiday.7", "holiday.8"],
                buttonColor: UIColor(red: 40 / 255.0, green: 178 / 255.0, blue: 75 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 35 / 255.0, green: 66 / 255.0, blue: 45 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 10, timer: 40, addScore: 11,
                operations: EquationGenerator.plusMultiplyMinusOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 1300, levelTheme: "Coffee",
                icons: ["coffee.1", "coffee.2", "coffee.3", "coffee.4", "coffee.5", "coffee.6", "coffee.7", "coffee.8"],
                buttonColor: UIColor(red: 239 / 255.0, green: 114 / 255.0, blue: 151 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 14 / 255.0, green: 133 / 255.0, blue: 128 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 15, timer: 360, addScore: 12,
                operations: EquationGenerator.plusMultiplyMinusOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 1600, levelTheme: "Weather",
                icons: ["weather.1", "weather.2", "weather.3", "weather.4", "weather.5", "weather.6", "weather.7", "weather.8"],
                buttonColor: UIColor(red: 209 / 255.0, green: 164 / 255.0, blue: 119 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 114 / 255.0, green: 28 / 255.0, blue: 71 / 255.0, alpha: 1),
                textColor: .white
            ),

            // All operations
            Stage(
                numberOfVariables: 2, limit: 12, timer: 20, addScore: 12,
                operations: EquationGenerator.allOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 2000, levelTheme: "Trees",
                icons: ["tree.1", "tree.2", "tree.3", "tree.4", "tree.5", "tree.6", "tree.7", "tree.8"],
                buttonColor: UIColor(red: 239 / 255.0, green: 104 / 255.0, blue: 43 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 68 / 255.0, green: 68 / 255.0, blue: 68 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 13, timer: 30, addScore: 13,
                operations: EquationGenerator.allOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 2400, levelTheme: "Signs",
                icons: ["sign.1", "sign.2", "sign.3", "sign.4", "sign.5", "sign.6", "sign.7", "sign.8"],
                buttonColor: UIColor(red: 130 / 255.0, green: 33 / 255.0, blue: 40 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 32 / 255.0, green: 27 / 255.0, blue: 80 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 15, timer: 120, addScore: 14,
                operations: EquationGenerator.allOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 2800, levelTheme: "Flight",
                icons: ["flight.1", "flight.2", "flight.3", "flight.4", "flight.5", "flight.6", "flight.7", "flight.8"],
                buttonColor: UIColor(red: 251 / 255.0, green: 178 / 255.0, blue: 48 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 0 / 255.0, green: 84 / 255.0, blue: 61 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 3, limit: 20, timer: 120, addScore: 15,
                operations: EquationGenerator.allOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 3200, levelTheme: "Cosmetics",
                icons: ["cosmetics.1", "cosmetics.2", "cosmetics.3", "cosmetics.4", "cosmetics.5", "cosmetics.6", "cosmetics.7", "cosmetics.8"],
                buttonColor: UIColor(red: 213 / 255.0, green: 164 / 255.0, blue: 88 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 15 / 255.0, green: 32 / 255.0, blue: 67 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 10, timer: 40, addScore: 16,
                operations: EquationGenerator.allOperations,
                difficulty: .NORMAL, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 3600, levelTheme: "Cooking",
                icons: ["cook.1", "cook.2", "cook.3", "cook.4", "cook.5", "cook.6", "cook.7", "cook.8"],
                buttonColor: UIColor(red: 240 / 255.0, green: 146 / 255.0, blue: 34 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 86 / 255.0, green: 18 / 255.0, blue: 16 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 12, timer: 390, addScore: 17,
                operations: EquationGenerator.allOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 4000, levelTheme: "Emoji",
                icons: ["emoji.1", "emoji.2", "emoji.3", "emoji.4", "emoji.5", "emoji.6", "emoji.7", "emoji.8", "emoji.9"],
                buttonColor: UIColor(red: 145 / 255.0, green: 171 / 255.0, blue: 60 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 89 / 255.0, green: 10 / 255.0, blue: 49 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 13, timer: 360, addScore: 18,
                operations: EquationGenerator.allOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 5000, levelTheme: "Calendar",
                icons: ["cal.1", "cal.2", "cal.3", "cal.4", "cal.5", "cal.6", "cal.7", "cal.8", "cal.9"],
                buttonColor: UIColor(red: 215 / 255.0, green: 132 / 255.0, blue: 140 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 104 / 255.0, green: 172 / 255.0, blue: 131 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 14, timer: 330, addScore: 19,
                operations: EquationGenerator.allOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 6000, levelTheme: "Timezone",
                icons: ["time.1", "time.2", "time.3", "time.4", "time.5", "time.6", "time.7", "time.8", "time.9"],
                buttonColor: UIColor(red: 223 / 255.0, green: 205 / 255.0, blue: 147 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 12 / 255.0, green: 108 / 255.0, blue: 166 / 255.0, alpha: 1),
                textColor: .white
            ),
            Stage(
                numberOfVariables: 4, limit: 20, timer: 300, addScore: 20,
                operations: EquationGenerator.allOperations,
                difficulty: .HARD, allowNegativeResults: false, withFloat: false,
                nextLevelScore: 7000, levelTheme: "Numbers",
                icons: ["number.1", "number.2", "number.3", "number.4", "number.5", "number.6", "number.7", "number.8", "number.9"],
                buttonColor: UIColor(red: 73 / 255.0, green: 135 / 255.0, blue: 62 / 255.0, alpha: 1),
                backgroundColor: UIColor(red: 24 / 255.0, green: 27 / 255.0, blue: 28 / 255.0, alpha: 1),
                textColor: .white
            ),
        ]
    }

    func getLevelByScore(score: Int) -> Int {
        for (index, stage) in stages.enumerated() {
            if stage.nextLevelScore > score {
                return index
            }
        }
        return getFinalLevel()
    }

    func getFinalLevel() -> Int {
        stages.count - 1
    }
}
