//
//  AccountTableViewController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/22/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountTableViewController: UITableViewController {
    
    @IBOutlet weak var linkKarmaLabel: UILabel!
    
    @IBOutlet weak var commentKarmaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccountCreds()
    }
    
    func getAccountCreds() {
        
        RequestController.shared.getNewAccessToken()
        
        guard let requestURL = URL(string: "https://oauth.reddit.com"),
            let token = KeychainWrapper.standard.string(forKey: "accessToken") else { return }
        
        let newURL = requestURL.appendingPathComponent("/api/v1/me")
        print(newURL)
        print("my retrieved token is \(token)")
        
        let headers: HTTPHeaders = ["User-Agent" : "ios:com.GK.voyager:v1.0 (by /u/ZypherXX)",
                       "Content-Type" : "application/x-www-form-urlencoded",
                       "Authorization" : "bearer \(token)"]

        
        print(headers)
        
        AF.request(newURL, method: .get, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard let json = response.result.value as? [String:Any] else {
                if let error = response.result.error {
                    print(error)
                }
                return
            }
            print(json)
            guard let commentKarma = json["comment_karma"] as? Int, let linkKarma = json["link_karma"] as? Int  else {
                print("Couldn't get data from JSON")
                return
            }
            self.linkKarmaLabel.text = "\(linkKarma)"
            self.commentKarmaLabel.text = "\(commentKarma)"
            
        }
    }
}
