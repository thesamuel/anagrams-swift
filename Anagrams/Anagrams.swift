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

    func printAnagrams(text: String, max: Int) throws { // TODO: rename this!
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
        printAnagrams(remainingLetters: lettersInText,
              relevantWords: relevantWords, anagrams: &anagrams, max: max)
    }

    func printAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                       anagrams: inout Array<String>, max: Int) {
        if (remainingLetters.isEmpty()) {
            print(anagrams);
        } else {
            for word in relevantWords {
                if let sub = remainingLetters.subtract(other: inventories[word]!) {
                    if (anagrams.count < max || max == 0) {
                        anagrams.append(word)
                        printAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                      anagrams: &anagrams, max: max)
                        anagrams.removeLast()
                    }
                }
            }
        }
    }
}
