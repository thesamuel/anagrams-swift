//
//  ViewController.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/10/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = Bundle.main.path(forResource: "dict3", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let dictionary = data.components(separatedBy: .newlines)
                let anagramSolver = Anagrams(dictionary: dictionary)
                do {
                    try anagramSolver.printAnagrams(text: "samuel", max: 0)
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
        }
        print("done!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

