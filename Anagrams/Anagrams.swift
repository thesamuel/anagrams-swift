//
//  Anagrams.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/13/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class Anagrams: NSObject {

    var inventories = [String: LetterInventory]()

    enum AnagramsError: Error {
        case invalidMaximumNumberOfWords
    }

    init(dictionary: [String]) {
        for word in dictionary {
            let inventory = LetterInventory(data: word)
            inventories[word] = inventory
        }
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
        return generateAnagrams(remainingLetters: lettersInText, relevantWords: relevantWords,
                                anagrams: Set<String>(), max: max)
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: Set<String>, max: Int?) -> Set<Set<String>> {
        if (remainingLetters.isEmpty()) {
            return Set([anagrams])
        } else {
            var results = Set<Set<String>>()
            for word in relevantWords {
                if let sub = remainingLetters.subtract(other: inventories[word]!) {
                    if (max == nil || anagrams.count < max!) {
                        let result = generateAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                                      anagrams: anagrams.union([word]), max: max)
                        results.formUnion(result)
                    }
                }
            }
            return results
        }
    }
}
