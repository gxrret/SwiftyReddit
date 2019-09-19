//
//  LogInViewController.swift
//  Voyager
//
//  Created by Garret Koontz on 5/8/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import UIKit
import SafariServices
import OAuth2
import Alamofire

class LogInViewController: UIViewController, SFSafariViewControllerDelegate {
    
    static let kSafariViewControllerCloseNotification = "kSafariViewControllerCloseNotification"
    
    fileprivate var alamofireManager: Session?
    var safariVC: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(safariLogin(notification:)), name: NSNotification.Name(rawValue: LogInViewController.kSafariViewControllerCloseNotification), object: nil)
    }

    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func logInWithRedditAccountButtonTapped(_ sender: Any) {
        
        guard let url = URL(string: "https://www.reddit.com/api/v1/authorize.compact?") else { return }
        let parameters: Parameters = [
            "client_id": "qbv2lKywvh8s4Q",
            "response_type": "code",
            "state" : "xyzTEST",
            "redirect_uri" : "voyager://response",
            "duration": "permanent",
            "scope" : "identity,read,mysubreddits,account"
        ]
        
        let newURL = NetworkController.url(byAdding: parameters as? [String:String], to: url)
        
        safariVC = SFSafariViewController(url: newURL)
        safariVC!.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
        
        
    }
    
    @objc func safariLogin(notification: Notification) {
        let url = notification.object as! URL
        if url.scheme == "voyager" {
            let queryParams = url.query?.components(separatedBy: "&")
            var codeParam = (queryParams! as NSArray).filtered(using: NSPredicate(format: "SELF BEGINSWITH %@", "code="))
            let codeQuery = codeParam[0] as? String
            if let code = codeQuery?.replacingOccurrences(of: "code=", with: "") {
                print("My authCode is \(code)")
                
                guard let url = URL(string: "https://www.reddit.com/api/v1/access_token") else { return }
                let uuid = UUID().uuidString
                let params: Parameters = [
                    "grant_type" : "authorization_code",
                    "code" : "\(code)",
                    "redirect_uri" : "voyager://response"]
            
                
                let username = "qbv2lKywvh8s4Q"
                let password = ""
                let loginString = String(format: "%@:%@", username, password)
                let loginData = loginString.data(using: String.Encoding.utf8)! as NSData
                let base64EncodedString = loginData.base64EncodedString()
                
                let headers: HTTPHeaders = ["Content-Type" : "application/x-www-form-urlencoded",
                               "Authorization" : "Basic \(base64EncodedString)"]

                
                AF.request(url, method: .post , parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { (response) in
                    
                    KeychainWrapper.standard.set(uuid, forKey: "deviceID")
                    if let json = response.result.value as? [String:Any] {
                        print(json)
                        guard let refreshToken = json["refresh_token"] as? String else { return }
                        KeychainWrapper.standard.set(refreshToken, forKey: "refreshToken")
                        print(refreshToken)
                    }
                        
                    // Parse out response to get access token and store in Keychain...
                    
                    self.safariVC?.dismiss(animated: true, completion: {
                        let redirectVC = self.storyboard?.instantiateViewController(withIdentifier: "successVC")
                        self.present(redirectVC!, animated: true, completion: nil)
                    })
                    
                }
            }
        }
    }
    @IBAction func signUpWithRedditButtonTapped(_ sender: Any) {
        
        let registerURL = "https://www.reddit.com/register"
        guard let url = URL(string: registerURL) else { return }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        
        present(safariVC, animated: true, completion: nil)
        
    }
}

