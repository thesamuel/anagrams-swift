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
        let inv = LetterInventory(data: "sam")
//        do {
//            try inv.set(letter: "a", value: 0)
//        } catch {
//            print(error)
//        }
        let inv2 = LetterInventory(data: "yasmin")
        print(inv.add(other: inv2))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

