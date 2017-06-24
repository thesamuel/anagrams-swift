//
//  ViewController.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/10/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let anagramSolver: Anagrams?
    var anagramResults: [Set<String>]?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.anagramSolver = ViewController.createAnagramSolver()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.anagramSolver = ViewController.createAnagramSolver()
        super.init(coder: aDecoder)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        if let results = anagramResults {
            cell.textLabel?.text = results[indexPath.row].description
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = anagramResults {
            return results.count
        }
        return 0
    }

    class func createAnagramSolver() -> Anagrams? {
        var anagramSolver: Anagrams?
        if let path = Bundle.main.path(forResource: "dict3", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let dictionary = data.components(separatedBy: .newlines)
                anagramSolver = Anagrams(dictionary: dictionary)
            } catch {
                print(error)
            }
        }
        return anagramSolver
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func donePressed(_ sender: Any) {
        textField.endEditing(false)
    }

    @IBAction func generateAnagrams(_ sender: Any) {
        let text = self.textField.text!
        DispatchQueue.global(qos: .userInitiated).async {
            self.anagramResults = self.makeAnagrams(text: text)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func makeAnagrams(text: String) -> Array<Set<String>>? {
        if let path = Bundle.main.path(forResource: "dict3", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let dictionary = data.components(separatedBy: .newlines)
                let anagramSolver = Anagrams(dictionary: dictionary)
                do {
                    let results = try anagramSolver.generateAnagrams(text: text, max: nil)
                    return Array.init(results)
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

