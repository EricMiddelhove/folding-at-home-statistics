//
//  NetworkHandler.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 05.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//
import Foundation

class NetworkHandler{
        
    let jsonDecoder = JSONDecoder()
    
    /** Downloading UserData from Data Task: Blocks Main thread
     *
     */
    func getUserData(user: String){
        
        activeDownloads += 1
        
        var username: String = ""
        for c in user {
            if c != " "{
                username += [c]
            }
        }
        
        print(":" + username + ":")
        
        
        let url = URL(string: "https://api.foldingathome.org/user/" + username)!
        var req = URLRequest(url: url)
        let sem = DispatchSemaphore(value: 0)
        var userData: UserData?
               
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        

        URLSession.shared.dataTask(with: req){d,r,e in
            
            guard let data = d else{
                print("no data")
                sem.signal()

                return
                
            }
            
            guard let res = r else{
                print("no res")
                sem.signal()

                return
            }
            
            if let error = e {
                print(error)
                sem.signal()

                return
            }
            
            do{
                print(String(data: data, encoding: .utf8));
                try userData = self.jsonDecoder.decode(UserData.self, from: data)
            }catch{
                print("decoding error")
                sem.signal()
                return
            }
            
            userDataMap[username] = userData
            
            activeDownloads -= 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recievedUserData"), object: nil)
        }.resume()
        
    }
}

class UserData: Codable{
    var name: String?
    var score: Int?
    var last: String?
    var rank: Int?
    var teams: [TeamData]?
}

class TeamData: Codable{
    var name: String?
    var credit: Int?
    var last: String?
    var team: Int?
}



