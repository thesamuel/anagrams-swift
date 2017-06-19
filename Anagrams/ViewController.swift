//
//  ViewController.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/10/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!

    @IBAction func donePressed(_ sender: Any) {
        textField.endEditing(false)
    }

      override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func generateAnagrams(_ sender: Any) {
        let text = self.textField.text!
        DispatchQueue.global(qos: .userInitiated).async {
            let anagrams = self.makeAnagrams(text: text)
            DispatchQueue.main.async {
                self.textView.text = anagrams?.description
            }
        }
    }

    func makeAnagrams(text: String) -> Array<Array<String>>? {
        if let path = Bundle.main.path(forResource: "dict3", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let dictionary = data.components(separatedBy: .newlines)
                let anagramSolver = Anagrams(dictionary: dictionary)
                do {
                    return try anagramSolver.generateAnagrams(text: text, max: 0)
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

