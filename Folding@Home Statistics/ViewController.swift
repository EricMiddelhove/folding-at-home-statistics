//
//  ViewController.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 04.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//

import UIKit
import CoreData

func getAttributedStringWith(spacing: Double, string: String) -> NSAttributedString{
    let atString = NSAttributedString(string: string)
    let mutString = NSMutableAttributedString(attributedString: atString)
    mutString.setAttributes([NSAttributedString.Key.kern :spacing], range: NSMakeRange(0, string.count));
    
    return NSAttributedString(attributedString: mutString);
}


class ViewController: UIViewController {

    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var statisticsLabel: UILabel!
    @IBOutlet weak var oneLabel: UILabel!
    @IBOutlet weak var inAMilLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        /** Setting up Formats of Labels
         *
         */
        homeLabel.attributedText = getAttributedStringWith(spacing: 6.0, string: homeLabel.text!);
        statisticsLabel.attributedText = getAttributedStringWith(spacing: 3.0, string: statisticsLabel.text!)
        oneLabel.attributedText = getAttributedStringWith(spacing: 3.75, string: oneLabel.text!)
        oneLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        inAMilLabel.attributedText = getAttributedStringWith(spacing: 3.75, string: inAMilLabel.text!)
        inAMilLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
    }
    
    /** Adjusting LoginField position taking Keyboard in account
     *
     *
     */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            print(loginBottomConstraint.constant)
            print(keyboardHeight)
            
            let distance = usernameField.frame.maxY - view.frame.maxY
            print(distance)
            
            if keyboardHeight > distance {
                loginBottomConstraint.constant = keyboardHeight
                loginBottomConstraint.priority = UILayoutPriority(rawValue: 1000)
            }
        }
    }
    
    /** Changing to Leaderboard view
     *
     *
     */
    @IBAction func hitReturn(_ sender: UITextField) {
        if usernameField.text != ""{
            username = usernameField.text!
            
            performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    /** Preparing for segue (sending username data) 
     *
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! LeaderboardController
        dest.username = username!
    }
}
