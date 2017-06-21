//
//  ViewController.swift
//  Swifty Words
//
//  Created by Akbar Mirza on 6/18/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import GameplayKit

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
    
    // stores all the buttons
    var letterButtons = [UIButton]()
    // stores all the buttons being used to spell an answer
    var activatedButtons = [UIButton]()
    // stores all possible solutions
    var solutions = [String]()
    
    // store's player's score
    var score = 0
    // store's current level
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // iterate through our buttons that have the tag 1001
        for subview in view.subviews where subview.tag == 1001 {
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self,
                          action: #selector(letterTapped),
                          for: .touchUpInside)
        }
        
        // load our level file
        loadLevel()
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
    
    // =========================================================================
    // Other Methods
    // =========================================================================
    
    @objc func letterTapped(btn: UIButton) {
        
    }
    
    // loads and parses our level text files and then randomly assigns letter
    // groups to buttons
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        guard let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") else {
            print("Failed To Load: level\(level).txt")
            return
        }
        
        guard let levelContents = try? String(contentsOfFile: levelFilePath) else {
            print("Failed To Load: Contents of level\(level).txt")
            return
        }
        
        // load the lines from our file
        var lines = levelContents.components(separatedBy: "\n")
        // shuffle the lines that we have in an array
        lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
        
        // for each line
        for (index, line) in lines.enumerated() {
            // split up the line into two parts: the answer and the clue
            let parts = line.components(separatedBy: ": ")
            let answer = parts[0]
            let clue = parts[1]
            
            // load our clueString
            clueString += "\(index + 1). \(clue)\n"
            
            // figure out the solution by removing the |'s in our answer
            let solutionWord = answer.replacingOccurrences(of: "|", with: "")
            // tell user how many letters in the word
            solutionString += "\(solutionWord.characters.count) letters\n"
            // add the count to our solutions
            solutions.append(solutionWord)
            
            // load the bits that users will use to form words
            let bits = answer.components(separatedBy: "|")
            // add it to our letterBits list
            letterBits += bits
        }
        
        // now configure the buttons and labels
        // remove whitespaces from our cluesLabel and answersLabel
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        if letterBits.count == letterButtons.count {
            // for index in letterBits
            for i in 0 ..< letterBits.count {
                // set the title for that button
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
}

