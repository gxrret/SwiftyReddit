//
//  SubredditController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/16/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SubredditController {
    
    var subreddits: [Subreddit] = []{
        didSet {
            delegate?.subredditsUpdated(subreddits: subreddits)
        }
    }
    
    weak var delegate: SubredditControllerDelegate?
    
    init() {
        getSubreddits { (subreddits) in
            self.subreddits = subreddits
        }
    }
    
    static let shared = SubredditController()
    
    func getSubreddits(completion: @escaping ([Subreddit]) -> Void) {
        
        RequestController.shared.getNewAccessToken()
        
        guard let requestURL = URL(string: "https://oauth.reddit.com/subreddits/mine/subscriber?limit=100"),
            let token = KeychainWrapper.standard.string(forKey: "accessToken") else { return }
        
        print("my retrieved token is \(token)")
        let headers = ["User-Agent" : "ios:com.GK.voyager:v1.0 (by /u/ZypherXX)",
                       "Content-Type" : "application/x-www-form-urlencoded",
                       "Authorization" : "bearer \(token)"]
        
        print(headers)
        
        Alamofire.request(requestURL, method: .get, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
//                    print(json)
                    for result in json["data"]["children"].arrayValue {
                        let subreddit = result["data"]["subreddit"].stringValue
                        let description = result["data"]["description"].stringValue
                        let name = result["data"]["display_name"].stringValue
                        let subscribers = result["data"]["subscribers"].intValue
                        let subObject = Subreddit(subreddit: subreddit, name: name, description: description, subscribers: subscribers)
                        
                        DispatchQueue.main.async {
                            self.subreddits.append(subObject)
//                            print(self.subreddits)
                            
                        }
                    }
                    completion([])
                }
            case .failure:
                if let error = response.result.error {
                    print(error)
                    completion([])
                }
            }
        }
    }
}

protocol SubredditControllerDelegate: class {
    func subredditsUpdated(subreddits:[Subreddit])
}
