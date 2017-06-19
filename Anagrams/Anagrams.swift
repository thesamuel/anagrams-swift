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

    func generateAnagrams(text: String, max: Int) throws -> Array<Array<String>> {
        if max < 0 {
            throw AnagramsError.invalidMaximumNumberOfWords
        }
        let lettersInText = LetterInventory(data: text)
        var relevantWords = Set<String>()
        for (word, inventory) in inventories {
            if (lettersInText.subtract(other: inventory) != nil) {
                relevantWords.insert(word)
            }
        }
        var anagrams = Array<String>()
        return generateAnagrams(remainingLetters: lettersInText,
                                relevantWords: relevantWords, anagrams: &anagrams, max: max)
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: inout Array<String>, max: Int) -> Array<Array<String>> {
        if (remainingLetters.isEmpty()) {
            return [anagrams]
        } else {
            var results = Array<Array<String>>()
            for word in relevantWords {
                if let sub = remainingLetters.subtract(other: inventories[word]!) {
                    if (anagrams.count < max || max == 0) {
                        anagrams.append(word)
                        let result = generateAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                                      anagrams: &anagrams, max: max)
                        results.append(contentsOf: result)
                        anagrams.removeLast()
                    }
                }
            }
            return results
        }
    }
}
