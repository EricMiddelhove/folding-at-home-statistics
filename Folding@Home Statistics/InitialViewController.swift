//
//  InitialViewController.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 07.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InitialViewController: UIViewController{
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let request : NSFetchRequest<Task> = Task.fetchRequest()
        
        do{
            
           let result = try delegate.persistentContainer.viewContext.fetch(request)
            
            if result.count >= 1 {
                 performSegue(withIdentifier: "jump", sender: self)
            }else {
                 performSegue(withIdentifier: "logIn", sender: self)
            }
        }catch{
            
        }
        
       
        
    }
}
