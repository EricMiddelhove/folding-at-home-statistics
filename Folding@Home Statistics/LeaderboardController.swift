//
//  LeaderboardController.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 05.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//

import Foundation
import UIKit
import CoreData

var userDataMap: [String:UserData] = [:]
var usernames: [String] = []
var activeDownloads = 0

class LeaderboardController: UIViewController {
    var networker = NetworkHandler()
    
    var username: String? //Initialisiert durch segue
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var statisticsLabel: UILabel!
    @IBOutlet weak var leaderboardLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addFriendsButton: UIButton!
    @IBOutlet weak var actvityIndicator: UIActivityIndicatorView!
    
    

    
    var userData: UserData?
    var friendData: [UserData]?
    
    var dataToDetailed: UserData?
    
    var del = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LeaderboardController.gotNewData(_:)), name: NSNotification.Name(rawValue: "recievedUserData"), object: nil)
      
        actvityIndicator.startAnimating()
        //Setting up Label format
        statisticsLabel.attributedText = getAttributedStringWith(spacing: 3.0, string: statisticsLabel.text!)
        homeLabel.attributedText = getAttributedStringWith(spacing: 6.0, string: homeLabel.text!)
        leaderboardLabel.attributedText = getAttributedStringWith(spacing: 2.5, string: leaderboardLabel.text!)
        
        //Setting up table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 41
        tableView.separatorColor = .none
        
        /** Handling previous logins
         *   Initialising username taking stored data into account
         *
         *     if there are usernames stored, taking the first one as user every other as friends
         */
        let request : NSFetchRequest<Task> = Task.fetchRequest()
                   
        do{
            
            let result = try del.persistentContainer.viewContext.fetch(request)
            
            if result.count >= 1 { // are there any usernames stored
                if let oldUser = result[0].username {
                    username = oldUser
                }
                
                //Adding all of them to usernames array and downloading the data
                for i in 0 ... result.count - 1 {
                    usernames += [result[i].username ?? ""]
                    
                    networker.getUserData(user: result[i].username ?? "")
                }
                
            }else{
                //If there was no username stored: Saving transmitted username on index 0 of store
                del = UIApplication.shared.delegate as! AppDelegate
                del.saveUsername(username: username!)
                
                networker.getUserData(user: username!)
//                userDataMap[username!] = userData ?? UserData()
                usernames += [username!]
            }
            
           
            
        }catch{
            //Ignore
        }
        
        if(activeDownloads == 0){
            actvityIndicator.isHidden = true
        }
    }
    
    /** changing to AddAFriendViewController
     *
     */
    @IBAction func addFriedsButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toAddAFriend", sender: self)

    }
    
    
    @objc func gotNewData(_ notification: NSNotification){
        DispatchQueue.main.sync {
            sortUsers()

            tableView.reloadData()
            
            if(activeDownloads == 0){
                actvityIndicator.isHidden = true
            }
        }
       
    }

    
    /** Bubblesorting the usernames array (yes it's slow but idc)
     *
     */
    func sortUsers(){
        
        if userDataMap.count <= 1 {return}
        
        for _ in 0...userDataMap.count{
            
            for j in 0 ... userDataMap.count - 2{
                
                if userDataMap[usernames[j]]?.score ?? 0 < userDataMap[usernames[j + 1]]?.score ?? 0 {
                    
                    let tmp = usernames[j]
                    usernames[j] = usernames[j + 1]
                    usernames[j + 1] = tmp
                    
                }
            }
        }
    }
    
    /** If going to the detailed view sending the UserData to it
     *
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedInfo" {
            let dest = segue.destination as! StatisticsViewController
            
            dest.userData = dataToDetailed ?? UserData()
            
        }
    }
    
    @IBAction func unwindToLeaderboard(_ segue: UIStoryboardSegue){
        
    }
    
}

extension LeaderboardController: UITableViewDelegate{
    
    /** Switching to StatisticsViewController after choosing a username
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        dataToDetailed = userDataMap[usernames[indexPath.row]]
        
        if dataToDetailed?.score != nil {
            performSegue(withIdentifier: "toDetailedInfo", sender: self)
        }
    }
    
}

extension LeaderboardController: UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .gray
        
        //Initialising position label (Color orange ... counting from 1 ...)
        let position = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 22) )
        position.text = String(indexPath.row + 1) + "."
        position.textColor = UIColor(cgColor: CGColor(srgbRed: 0.99608, green: 0.34118, blue: 0.00392, alpha: 0.65))
        
        position.attributedText = getAttributedStringWith(spacing: 2.0, string: position.text!)
        
        //Adding username label (if  not a frien color orange else white)
        let uname = UILabel(frame: CGRect(x: 40, y: 0, width: 206, height: 22))
        uname.text = usernames[indexPath.row]
        uname.attributedText = getAttributedStringWith(spacing: 3.0, string: uname.text!)
        uname.textColor = uname.text == username ? UIColor(cgColor: CGColor(srgbRed: 0.99608, green: 0.34118, blue: 0.00392, alpha: 0.65)) : .white
        
        
        let c = userDataMap[usernames[indexPath.row]]?.score
        
        // printing credit data
        // MARK: Problem with multithreading will occur
        let credit = UILabel(frame: CGRect(x: 246, y: 0, width: 105, height: 22))
        
        if let i = c {
            credit.text = String(i)
        }else{
            credit.text = ""
        }
        credit.textColor = uname.text == username ? UIColor(cgColor: CGColor(srgbRed: 0.99608, green: 0.34118, blue: 0.00392, alpha: 0.65)) : .white

        
        cell.addSubview(position)
        cell.addSubview(uname)
        cell.addSubview(credit)
        
        cell.backgroundColor = .some(UIColor(cgColor: CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0))) //Basically seethrough
        
        return cell
    }
    
}
