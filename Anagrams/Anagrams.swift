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

    func generateAnagrams(text: String, max: Int?, block: @escaping (Double) -> Void) throws -> Set<Set<String>> {
        if max != nil && max! < 0 {
            throw AnagramsError.invalidMaximumNumberOfWords
        }
        let lettersInText = LetterInventory(data: text)
        var relevantWords = Set<String>()
        for (word, inventory) in self.inventories {
            if (lettersInText.subtract(other: inventory) != nil) {
                relevantWords.insert(word)
            }
        }
        return generateAnagrams(remainingLetters: lettersInText, relevantWords: relevantWords,
                                anagrams: Set<String>(), max: max, depth: 0, block: block)
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: Set<String>, max: Int?, depth: Int, block: @escaping (Double) -> Void) -> Set<Set<String>> {
        if (remainingLetters.isEmpty()) {
            return Set([anagrams])
        } else {
            var results = Set<Set<String>>()
            var progress = 0;
            for word in relevantWords {
//                var operation = BlockOperation(block: { 
                    if let sub = remainingLetters.subtract(other: self.inventories[word]!) {
                        if (max == nil || anagrams.count < max!) {
                            let result = self.generateAnagrams(remainingLetters: sub,
                                                               relevantWords: relevantWords,
                                                               anagrams: anagrams.union([word]),
                                                               max: max,
                                                               depth: depth + 1,
                                                               block: block)
                            results.formUnion(result)
                        }
                    }
                    if (depth == 0) {
//                        OperationQueue.main.addOperation(block)
                        block(Double(progress) / Double(relevantWords.count))
                        progress += 1;
                    }
//                })
            }
            return results
        }
    }
}
