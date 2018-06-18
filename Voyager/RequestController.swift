//
//  RequestController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/16/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import Foundation
import Alamofire

class RequestController {
    
    static let shared = RequestController()
    
    func performRequest(_ method: HTTPMethod, requestURL: URLConvertible, parameters: [String: Any], headers: [String: String], completion: @escaping (_ json: Any?) -> Void) {
        
        Alamofire.request(requestURL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    print("\(data)")
                    completion(nil)
                }
                break
                
            case.failure(_):
                print(response.result.error!)
                completion(nil)
                break
            }
        }
    }
    
    func getNewAccessToken() {
        guard let url = URL(string: "https://www.reddit.com/api/v1/access_token"),
            let token = KeychainWrapper.standard.string(forKey: "refreshToken") else { return }
        
        let params: Parameters = ["grant_type":"refresh_token",
                                  "refresh_token":"\(token)"]
        
        let username = "qbv2lKywvh8s4Q"
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
        let base64EncodedString = loginData.base64EncodedString()
        
        let headers = ["Content-Type" : "application/x-www-form-urlencoded",
                       "Authorization" : "Basic \(base64EncodedString)"]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                guard let accessToken = json["access_token"] as? String else { return }
                KeychainWrapper.standard.set(accessToken, forKey: "accessToken")
                print(accessToken)
            }
        }
        
    }
    
//    func retrieveAccessToken() {
//        guard let url = URL(string: "https://www.reddit.com/api/v1/access_token"),
//            let uuidString = KeychainWrapper.standard.string(forKey: "deviceID") else { return }
//        let params: Parameters = [
//            "grant_type" : "https://oauth.reddit.com",
//            "device_id" : "\(uuidString)",
//            "code" : ""]
//        
//        
//        let username = "qbv2lKywvh8s4Q"
//        let password = ""
//        let loginString = String(format: "%@:%@", username, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
//        let base64EncodedString = loginData.base64EncodedString()
//        
//        let headers = ["Content-Type" : "application/x-www-form-urlencoded",
//                       "Authorization" : "Basic \(base64EncodedString)"]
//        
//        
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
//            if let JSON = response.result.value as? [String:Any] {
//                guard let accessToken = JSON["access_token"] as? String else { return }
//                KeychainWrapper.standard.set(accessToken, forKey: "oauthToken")
//                print("Here is your access token: \(accessToken)")
//            }
//        }
//    }
    
//    func checkForAccessToken() {
//
//        guard let url = URL(string: "https://www.reddit.com/api/v1/access_token"),
//            let uuidString = KeychainWrapper.standard.string(forKey: "deviceID") else { return }
//        let params: Parameters = [
//            "grant_type" : "https://oauth.reddit.com",
//            "device_id" : "\(uuidString)"]
//
//
//        let username = "qbv2lKywvh8s4Q"
//        let password = ""
//        let loginString = String(format: "%@:%@", username, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
//        let base64EncodedString = loginData.base64EncodedString()
//
//        let headers = ["Content-Type" : "application/x-www-form-urlencoded",
//                       "Authorization" : "Basic \(base64EncodedString)"]
//
//
//        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
//            if response.response?.statusCode == 401 {
//                self.retrieveAccessToken()
//
//            }
//        }
//    }
}
