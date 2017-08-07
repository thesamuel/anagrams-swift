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
                anagrams: Set<String>(), max: max, progress: block)
    }

    func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                          anagrams: Set<String>, max: Int?,
                          progress: @escaping (Double) -> Void) -> Set<Set<String>> {
        var results = Set<Set<String>>()
        let queue = OperationQueue();
        var processedWords = 0;
        func generateAnagrams(remainingLetters: LetterInventory, relevantWords: Set<String>,
                              anagrams: Set<String>, max: Int?, depth: Int) {
            if (remainingLetters.isEmpty()) {
                OperationQueue.main.addOperation({
                    results.formUnion(Set([anagrams]))
                })
            } else {
                for word in relevantWords {
                    if let sub = remainingLetters.subtract(other: self.inventories[word]!) {
                        if (max == nil || anagrams.count < max!) {
                            let processWord = BlockOperation {
                                generateAnagrams(remainingLetters: sub, relevantWords: relevantWords,
                                                 anagrams: anagrams.union([word]), max: max, depth: depth + 1)
                            }
                            queue.addOperation(processWord)
                            if depth == 0 {
                                let updateProgress = BlockOperation {
                                    OperationQueue.main.addOperation({
                                        processedWords += 1
                                        progress(Double(processedWords) / Double(relevantWords.count))
                                    })
                                }
                                updateProgress.addDependency(processWord)
                                queue.addOperation(updateProgress)
                            }
                        }
                    }
                }
            }
        }
        generateAnagrams(remainingLetters: remainingLetters, relevantWords: relevantWords,
                         anagrams: anagrams, max: max, depth: 0)
        queue.waitUntilAllOperationsAreFinished()
        return results
    }
}
