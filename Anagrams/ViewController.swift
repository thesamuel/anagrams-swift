//
//  ViewController.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/10/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let anagramSolver: Anagrams?
    var anagramResults: [Set<String>]?

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0
    }

    // Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.anagramSolver = ViewController.createAnagramSolver()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.anagramSolver = ViewController.createAnagramSolver()
        super.init(coder: aDecoder)
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

    // Table View Protocol
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        if let result = anagramResults {
            cell.textLabel?.text = result[indexPath.row].description
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = anagramResults {
            return results.count
        }
        return 0
    }

    // Actions
    @IBAction func donePressed(_ sender: Any) {
        textField.endEditing(false)
    }

    @IBAction func generateAnagrams(_ sender: Any) {
        if let text = self.textField.text {
            DispatchQueue.global(qos: .userInitiated).async {
                self.anagramResults = self.generateAnagrams(text: text)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func updateProgress(percent: Double) {
        DispatchQueue.main.async {
            self.progressView.progress = Float(percent)
        }
    }

    func generateAnagrams(text: String) -> Array<Set<String>>? {
        DispatchQueue.main.async {
            self.anagramResults = nil
            self.tableView.reloadData()
            self.progressView.progress = 0
        }

        do {
            if let results = try anagramSolver?.generateAnagrams(text: text, max: nil, block: updateProgress) {
                DispatchQueue.main.async {
                    self.progressView.progress = 1 // TODO: handle error with color
                }
                return Array.init(results)
            }
        } catch {
            print(error)
        }
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
