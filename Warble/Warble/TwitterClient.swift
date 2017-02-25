//
//  TwitterClient.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "4uwY894kVL2E1KIIGS4xnLQsb", consumerSecret: "nPURIyLSDUR0q7wwJnftkpIyVEFhmQVeNxPe89L5kS6y1FmrvW")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "warble://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)! as String)")!
            
            UIApplication.shared.open(url, options: [:], completionHandler: { (success: Bool) -> Void in
                if success {
                    
                } else {
                    
                }
                
            })
        }, failure: { (error: Error?) -> Void in
            print("error fetching request token: \((error?.localizedDescription)! as String)")
        })
    }
    
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.loginSuccess?()
            
        }) { (error: Error?) in
            self.loginFailure?(error!)
        }
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsFromArray(dictionaries: dictionaries)
                
                success(tweets)
                
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("error getting home timeline: \(error.localizedDescription as String)")
            failure(error)
        })
        
    }
    
    func currentUser() {
        get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                
                //                    print("account: \(response)")
                
                let userDictionary = response as! NSDictionary
                
                let user = User(dictionary: userDictionary)
                
                print("name: \(user.name)")
                print("screenname: \(user.screenname)")
                print("profile url: \(user.profileUrl)")
                print("description: \(user.tagline)")
                
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("error getting credentials: \(error.localizedDescription as String)")
        })
    }
    
    
}
