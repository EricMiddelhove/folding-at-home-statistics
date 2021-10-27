//
//  AddAFriendController.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 05.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//

import Foundation
import UIKit


class AddAFriendController: UIViewController{
    
    @IBOutlet weak var textfield: UITextField!
    override func viewDidLoad() {
        
    }
    
    /** Going back to the LeaderboardViewController
     *
     */
    @IBAction func confirmpressed(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindToLeaderboard", sender: self)
        
    }
    
    /** Downloading userData and sending it to Leaderboard controller also saving new username to core data
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! LeaderboardController
        
        if textfield.text != "" {
            usernames += [textfield.text!]
        }
        
        
        dest.networker.getUserData(user: textfield.text!)
        dest.actvityIndicator.isHidden = false

        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.saveUsername(username: textfield.text!)
        
    }
    
    
}
