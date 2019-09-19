//
//  TrophiesTableViewController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/22/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TrophiesTableViewController: UITableViewController {
    
    var trophies: [Trophy] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trophies"
        getTrophies()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trophies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trophyCell", for: indexPath)
        let trophy = trophies[indexPath.row]
        cell.textLabel?.text = trophy.name
        let url = URL(string: trophy.icon_70)
        let data = try? Data(contentsOf: url!)
        cell.imageView?.image = UIImage(data: data!)

        return cell
    }
    
    func getTrophies() {
        RequestController.shared.getNewAccessToken()
        guard let requestURL = URL(string: "https://oauth.reddit.com/api/v1/me/trophies"),
            let token = KeychainWrapper.standard.string(forKey: "accessToken") else { return }
        
        let headers: HTTPHeaders = ["User-Agent" : "ios:com.GK.voyager:v1.0 (by /u/ZypherXX)",
                       "Content-Type" : "application/x-www-form-urlencoded",
                       "Authorization" : "bearer \(token)"]
        
        AF.request(requestURL, method: .get, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)
                    for result in json["data"]["trophies"].arrayValue {
                        let name = result["data"]["name"].stringValue
                        let icon_70 = result["data"]["icon_70"].stringValue
                        
                        let trophyObject = Trophy(name: name, icon_70: icon_70)
                        DispatchQueue.main.async {
                            self.trophies.append(trophyObject)
                            self.tableView.reloadData()
                        }
                    }
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                }
            }
        }
        
    }
}
