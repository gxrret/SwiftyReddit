//
//  Subreddit.swift
//  Voyager
//
//  Created by Garret Koontz on 5/15/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import Foundation

struct Subreddit {
    let subreddit: String
    let name: String
    let description: String
    let subscribers: Int
    init(subreddit: String, name: String, description: String, subscribers: Int) {
        self.subreddit = subreddit
        self.name = name
        self.description = description
        self.subscribers = subscribers
    }
    
    static func objectFromDictionary(dict: [String: AnyObject]) -> Subreddit? {
        let subreddit = dict["subreddit"] as? String ?? ""
        let name = dict["display_name"] as? String ?? ""
        let description = dict["description"] as? String ?? ""
        let subscribers = dict["subscribers"] as? Int ?? 0
        return Subreddit(subreddit: subreddit, name: name, description: description, subscribers: subscribers)
    }
}
