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
    
    var postError: NSError?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        // clear any previous clients
        deauthorize()
        
        // get new request token
        print("login(): fetching request token")
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "warble://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)! as String)")!
            
            UIApplication.shared.open(url, options: [:], completionHandler: { (success: Bool) in
                // do nothing
            })
        }, failure: { (error: Error?) -> Void in
            print("login(): fetching request token: ERROR: \((error?.localizedDescription)! as String)")
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogoutNotification, object: nil)
        
    }
    
    func handleOpenUrl(url: URL) {
        
        // get access token
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            // network call to get current user
            self.currentUser(success: { (user: User) in
                
                // save current user
                User.currentUser = user
                
                // call client success block
                self.loginSuccess?()
                
                
            }, failure: { (error:  Error) in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }) { (error: Error?) in
            self.loginFailure?(error!)
        }
    }
    
    func currentUser(success: @escaping (User) -> (), failure: @escaping (Error) -> () ) {
        get("/1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                
                let userDictionary = response as! NSDictionary
                
                let user = User(dictionary: userDictionary)
                
                success(user)
                
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            print("currentUser(): ERROR: \(error.localizedDescription as String)")
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: URLSessionDataTask, response: Any?) in
                
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsFromArray(dictionaries: dictionaries)
                
                success(tweets)
                
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print("homeTimeline(): ERROR: \(error)")
            failure(error)
        })
        
    }
    
    
    // MARK: - Actions on Tweets
    
    func retweetStatus(retweeting: Bool, id: String) {
        
        let endpoint = retweeting ? "retweet" : "unretweet"
        
        post("1.1/statuses/\(endpoint)/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("retweetStatus(): \(endpoint): success")
        },
             failure: { (task: URLSessionDataTask?, error: Error) in
            
                print("retweetStatus(): ERROR: \(error)")
        })
        
    }
    
    func favoriteStatus(favoriting: Bool, id: String) {
        
        let endpoint = favoriting ? "create" : "destroy"
        
        post("1.1/favorites/\(endpoint).json?id=\(id)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            print("favoriteStatus(): \(endpoint): success")
        },
             failure: { (task: URLSessionDataTask?, error: Error) in
                
                print("favoriteStatus(): ERROR: \(error)")
        })
    }
    
    
}
