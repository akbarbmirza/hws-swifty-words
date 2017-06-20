//
//  ViewController.swift
//  Swifty Words
//
//  Created by Akbar Mirza on 6/18/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // =========================================================================
    // Outlets
    // =========================================================================
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    // =========================================================================
    // Properties
    // =========================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =========================================================================
    // Actions
    // =========================================================================
    
    @IBAction func submitTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        
    }
    
    
    
}

