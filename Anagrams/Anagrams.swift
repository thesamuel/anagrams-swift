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

    func generateAnagrams(text: String, max: Int?, block: @escaping (Set<String>, Double) -> Void) throws {
        
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

        generateAnagrams(remainingLetters: lettersInText, relevantWords: relevantWords,
                         anagrams: Set<String>(), max: max, progress: block)
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: Set<String>, max: Int?,
                          progress: @escaping (Set<String>, Double) -> Void) {
        let queue = OperationQueue();
        var processedWords = 0;
        func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                              anagrams: Set<String>, max: Int?, depth: Int) {
            if (remainingLetters.isEmpty()) {
                OperationQueue.main.addOperation({
                    processedWords += 1 // TODO: this doesn't work with sets (no duplicates)
                    let processedWordsPercent = Double(processedWords) / Double(relevantWords.count)
                    progress(anagrams, processedWordsPercent)
                })
            } else {
                for word in relevantWords {
                    if let sub = remainingLetters.subtract(other: self.inventories[word]!) {
                        if (max == nil || anagrams.count < max!) {
                            if (depth == 0) {
                                queue.addOperation({
                                    generateAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                                     anagrams: anagrams.union([word]), max: max, depth: depth + 1)
                                })
                            } else {
                                generateAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                                 anagrams: anagrams.union([word]), max: max, depth: depth + 1)
                            }
                        }
                    }
                }
            }
        }
        generateAnagrams(remainingLetters: remainingLetters, relevantWords: relevantWords,
                         anagrams: anagrams, max: max, depth: 0)
    }
}
