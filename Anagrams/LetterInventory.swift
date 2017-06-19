//
//  LetterInventory.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/13/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class LetterInventory: NSObject {

    var inventory: [Int]

    public override var description: String { return self.toString() }
    public var size: Int
    public let WIDTH = 26

    enum LetterInventoryError: Error {
        case invalidCharacter
    }

    override init() {
        self.inventory = Array(repeating: 0, count: WIDTH)
        self.size = 0
    }

    init(data: String) {
        self.inventory = Array(repeating: 0, count: WIDTH)
        self.size = 0
        for c in data.characters {
            if let index = LetterInventory.indexOfLetter(letter: c) {
                self.size += 1
                inventory[index] += 1
            }
        }
    }

    func get(letter: Character) throws -> Int {
        if let index = LetterInventory.indexOfLetter(letter: letter) {
            return inventory[index]
        }
        throw LetterInventoryError.invalidCharacter
    }

    func set(letter: Character, value: Int) throws {
        if let index = LetterInventory.indexOfLetter(letter: letter) {
            self.size -= inventory[index]
            self.size += value
            self.inventory[index] = value
        } else {
            throw LetterInventoryError.invalidCharacter
        }
    }

    func isEmpty() -> Bool {
        return size == 0
    }

    func toString() -> String {
        var letters = ""
        for i in 0 ..< WIDTH {
            let letter = LetterInventory.letterForIndex(index: i)
            for _ in 0 ..< self.inventory[i] {
                letters += String(letter)
            }
        }
        return letters
    }

    func add(other: LetterInventory) -> LetterInventory {
        let inv = LetterInventory()
        for i in 0 ..< WIDTH {
            let counts = self.inventory[i] + other.inventory[i]
            inv.inventory[i] = counts
            inv.size += counts
        }
        return inv
    }

    func subtract(other: LetterInventory) -> LetterInventory? {
        let inv = LetterInventory()
        for i in 0 ..< WIDTH {
            let counts = self.inventory[i] - other.inventory[i]
            if counts >= 0 {
                inv.inventory[i] = counts
                inv.size += counts
            } else {
                return nil
            }
        }
        return inv
    }

    class func letterForIndex(index: Int) -> Character {
        let aScalar = "a".unicodeScalars.first
        let letterScalar = Int(aScalar!.value) + index
        return Character(UnicodeScalar(letterScalar)!)
    }

    class func indexOfLetter(letter: Character) -> Int? {
        let zScalar = "z".unicodeScalars.first
        let aScalar = "a".unicodeScalars.first
        let letterScalar = String(letter).lowercased().unicodeScalars.first
        let index = Int(letterScalar!.value) - Int(aScalar!.value)
        if index < 0 || Int(letterScalar!.value) - Int(zScalar!.value) > 0 {
            return nil
        }
        return index
    }
}
