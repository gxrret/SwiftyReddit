//
//  Response.swift
//  Voyager
//
//  Created by Garret Koontz on 5/10/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import Foundation

class Response: Codable {

    let access_token : String
    let token_type: String
    let expires_in: String
    let scope: String
    let refresh_token: String
    
    init(access_token: String, token_type: String, expires_in: String, scope: String, refresh_token: String) {
        self.access_token = access_token
        self.token_type = token_type
        self.expires_in = expires_in
        self.scope = scope
        self.refresh_token = refresh_token
    }
    
}

