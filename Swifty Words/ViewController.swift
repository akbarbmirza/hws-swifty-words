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
    
    // handler for when the player taps the submit button
    @IBAction func submitTapped(_ sender: UIButton) {
        
        // if we find our current answer in the solutions
        if let solutionPosition = solutions.index(of: currentAnswer.text!) {
            
            // clear all the activated buttons
            activatedButtons.removeAll()
            
            // split up our clues
            var splitClues = answersLabel.text!.components(separatedBy: "\n")
            // replace the clue for the index of our solution
            splitClues[solutionPosition] = currentAnswer.text!
            // rejoin the split clues
            answersLabel.text = splitClues.joined(separator: "\n")
            
            // clear the current answer
            currentAnswer.text = ""
            // increment the score
            score += 1
            
            // if we have answered all seven words correctly...
            if score % 7 == 0 {
                // create an alert to congratulate the user
                let ac = UIAlertController(title: "Well done!",
                                           message: "Are you ready for the next level?",
                                           preferredStyle: .alert)
                // create an action to handle when the user wants to continue
                ac.addAction(UIAlertAction(title: "Let's Go!",
                                           style: .default,
                                           handler: levelUp))
                // show our alert
                present(ac, animated: true)
            }
            
        }
        
    }
    
    // when the clear button is tapped, we show all the buttons that we hid
    // previously
    @IBAction func clearTapped(_ sender: UIButton) {
        
        // clear our current answer
        currentAnswer.text = ""
        
        // for every button that we previously activated
        for btn in activatedButtons {
            // show the button
            btn.isHidden = false
        }
        
        // clear our activatedButtons array
        activatedButtons.removeAll()
        
    }
    
    // =========================================================================
    // Other Methods
    // =========================================================================
    
    // handler for when the player taps on a letter button
    @objc func letterTapped(btn: UIButton) {
        
        // append our button text to the current answer
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        // append our button to the activatedButtons array
        activatedButtons.append(btn)
        // hide the button we pressed
        btn.isHidden = true
        
    }
    
    // clears out existing solutions array before loading the next level
    func levelUp(action: UIAlertAction) {
        
        // increment our level property
        level += 1
        // clear our solutions list
        solutions.removeAll(keepingCapacity: true)
        
        // load the level
        loadLevel()
        
        // unhide all of our letter buttons
        for btn in letterButtons {
            btn.isHidden = false
        }
        
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

