//
//  StatisticsViewController.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 05.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController{
    
    @IBOutlet weak var statisticsLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var lastFinishedLabel: UILabel!
    @IBOutlet weak var teamDonorLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var teamTotalLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var creditData: UILabel!
    @IBOutlet weak var rankData: UILabel!
    @IBOutlet weak var lastFinishedData: UILabel!
    @IBOutlet weak var teamCreditData: UILabel!
    @IBOutlet weak var teamTotalData: UILabel!
    
    var userData: UserData! //Initialisesd by segue

    override func viewDidLoad() {
        
        //Setting up format
        usernameLabel.text = userData.name ?? "No Name"
        creditData.text = String(userData.credit ?? 0)
        rankData.text = userData.rank == 0 || userData.rank == nil ? "Unranked" : String(userData.rank!) 
        
        lastFinishedData.text = userData.last
        teamNameLabel.text = userData.teams?[(userData.teams!.count - 1)].name ?? "No Team"
        
        teamCreditData.text = String(userData.teams?[userData.teams!.count - 1].credit ?? 0)
        teamTotalData.text = String(userData.teams?[userData.teams!.count - 1].team ?? 0)
        
        statisticsLabel.attributedText = getAttributedStringWith(spacing: 3, string: statisticsLabel.text!)
        creditLabel.attributedText = getAttributedStringWith(spacing: 1.5, string: creditLabel.text!)
        rankLabel.attributedText = getAttributedStringWith(spacing: 1.5, string: rankLabel.text!)
        lastFinishedLabel.attributedText = getAttributedStringWith(spacing: 1.5, string: lastFinishedLabel.text!)
        teamDonorLabel.attributedText = getAttributedStringWith(spacing: 1.5, string: teamDonorLabel.text!)
        teamTotalLabel.attributedText = getAttributedStringWith(spacing: 1.5, string: teamTotalLabel.text!)
        
    }
    
}
