//
//  Trophies.swift
//  Voyager
//
//  Created by Garret Koontz on 5/22/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import Foundation

struct Trophy {
    let name: String
    let icon_70: String
    init(name:String, icon_70: String) {
        self.name = name
        self.icon_70 = icon_70
    }
    
    static func objectFromDictionary(dict: [String: AnyObject]) -> Trophy? {
        let name = dict["name"] as? String ?? ""
        let icon_70 = dict["icon_70"] as? String ?? ""
        return Trophy(name: name, icon_70: icon_70)
    }
}
