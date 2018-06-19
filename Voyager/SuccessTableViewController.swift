//
//  SuccessTableViewController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/16/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SuccessTableViewController: UITableViewController, SubredditControllerDelegate {
    
    let subredditController = SubredditController()
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.startAnimating()
        subredditController.delegate = self
    }
    
    @IBAction func resetCreds(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "deviceID")
    }
    
    
    @IBAction func getSubs(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subredditController.subreddits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subredditCell", for: indexPath)
        let subreddit = subredditController.subreddits[indexPath.row]
        
        let name = subreddit.name
        let subscriberCount = subreddit.subscribers
        cell.textLabel?.text = "\(name)"
        cell.detailTextLabel?.text = "\(subscriberCount) subscribers"
        
        return cell
    }
    
    func subredditsUpdated(subreddits: [Subreddit]) {
        DispatchQueue.main.async {
            self.activityView.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDescription" {
//            if let indexPath = tableView.indexPathForSelectedRow, let vc = segue.destination as? DescriptionViewController {
//                let subreddit = SubredditController.shared.subreddits[indexPath.row]
//                vc.subreddit = subreddit
//            }
//        }
//    }
}

