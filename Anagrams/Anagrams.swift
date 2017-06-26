//
//  Anagrams.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/13/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class Anagrams: NSObject {

    let inventories: [String: LetterInventory]

    enum AnagramsError: Error {
        case invalidMaximumNumberOfWords
    }

    init(dictionary: [String]) {
        var inventories = [String: LetterInventory]()
        for word in dictionary {
            let inventory = LetterInventory(data: word)
            inventories[word] = inventory
        }
        self.inventories = inventories
    }

    func generateAnagrams(text: String, max: Int?) throws -> Set<Set<String>> {
        if max != nil && max! < 0 {
            throw AnagramsError.invalidMaximumNumberOfWords
        }
        let lettersInText = LetterInventory(data: text)
        var relevantWords = Set<String>()
        for (word, inventory) in inventories {
            if (lettersInText.subtract(other: inventory) != nil) {
                relevantWords.insert(word)
            }
        }
        var anagrams = Set<String>()
        return generateAnagrams(remainingLetters: lettersInText, relevantWords: relevantWords,
                                anagrams: &anagrams, max: max)
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: inout Set<String>, max: Int?) -> Set<Set<String>> {
        if (remainingLetters.isEmpty()) {
            return Set([anagrams])
        } else {
            var results = Set<Set<String>>()
            for word in relevantWords {
                if let sub = remainingLetters.subtract(other: inventories[word]!) {
                    if (max == nil || anagrams.count < max!) {
                        anagrams.formUnion([word])
                        let result = generateAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                                      anagrams: &anagrams, max: max)
                        anagrams.remove(word)
                        results.formUnion(result)
                    }
                }
            }
            return results
        }
    }
}
