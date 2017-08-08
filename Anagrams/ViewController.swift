//
//  ViewController.swift
//  Anagrams
//
//  Created by Sam Gehman on 6/10/17.
//  Copyright © 2017 Sam Gehman. All rights reserved.
//

import UIKit
import RateLimit

class ViewController: UIViewController {

    @IBOutlet weak var speedControl: UISegmentedControl!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let anagramSolver: Anagrams?
    var anagrams = [Set<String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0
    }

    // Lifecycle
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

    // Actions
    @IBAction func generate(_ sender: Any) {
        textField.endEditing(false)
        if let text = self.textField.text {
            anagrams.removeAll()
            self.tableView.reloadData()
            self.progressView.progress = 0
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try self.anagramSolver?.generateAnagrams(text: text, max: nil, block: self.updateProgress)
                } catch {
                    print(error)
                }
            }
        }
    }

    let reloadTableView = TimedLimiter(limit: 0.3)
    func updateProgress(anagram: Set<String>, percent: Double) {
        anagrams.append(anagram)
        reloadTableView.execute {
            progressView.progress = Float(percent)
            tableView.reloadData()
        }
//        tableView.insertRows(at: [IndexPath(row: anagrams.count - 1, section: 0)], with: .automatic)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = anagrams[indexPath.row].description
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anagrams.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
