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

    func generateAnagrams(text: String, max: Int?, block: @escaping (Double) -> Void, fast: Bool) throws -> Set<Set<String>> {
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

        if fast {
            return generateAnagrams2(remainingLetters: lettersInText, relevantWords: relevantWords,
                                     anagrams: Set<String>(), max: max, block: block)
        } else {
            return generateAnagrams(remainingLetters: lettersInText, relevantWords: relevantWords,
                                    anagrams: Set<String>(), max: max, depth: 0, block: block)
        }
    }


    func generateAnagrams2(remainingLetters: LetterInventory, relevantWords: Set<String>,
                           anagrams: Set<String>, max: Int?, block: @escaping (Double) -> Void) -> Set<Set<String>> {
        var results = Set<Set<String>>()
        var progress = 0;
        let queue = OperationQueue();
        for word in relevantWords {
            if let sub = remainingLetters.subtract(other: self.inventories[word]!) {
                if (max == nil || anagrams.count < max!) {
                    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                                          anagrams: Set<String>, max: Int?) {
                        if (remainingLetters.isEmpty()) {
                            results.formUnion(Set([anagrams]))
                        } else {
                            for word in relevantWords {
                                if let sub = remainingLetters.subtract(other: self.inventories[word]!) {
                                    if (max == nil || anagrams.count < max!) {
                                        generateAnagrams(remainingLetters: sub,
                                                         relevantWords: relevantWords,
                                                         anagrams: anagrams.union([word]),
                                                         max: max)
                                    }
                                }
                            }
                        }
                    }
                    queue.addOperation({
                        generateAnagrams(remainingLetters: sub,
                                         relevantWords: relevantWords,
                                         anagrams: anagrams.union([word]),
                                         max: max)
                        OperationQueue.main.addOperation({
                            block(Double(progress) / Double(relevantWords.count))
                        })
                        progress += 1
                    })
                }
            }
        }
        queue.waitUntilAllOperationsAreFinished()
        return results
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: Set<String>, max: Int?, depth: Int, block: @escaping (Double) -> Void) -> Set<Set<String>> {
        if (remainingLetters.isEmpty()) {
            return Set([anagrams])
        } else {
            var results = Set<Set<String>>()
            var progress = 0;
            for word in relevantWords {
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
                    OperationQueue.main.addOperation({
                        block(Double(progress) / Double(relevantWords.count))
                    })
                    progress += 1;
                }
            }
            return results
        }
    }
}
