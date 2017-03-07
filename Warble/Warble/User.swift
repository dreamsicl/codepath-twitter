//
//  User.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = Notification.Name(rawValue: "UserDidLogout")
    
    var name: String!
    var screenname: String!
    var profilePic: URL!
    var profilePicBig: URL!
    var tagline: String! // description
    
    var favsCount: Int!
    var followersCount: Int!
    var followingCount: Int!
    var statusesCount: Int!
    
    var bannerUrl: URL?
    
    var json: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.json = dictionary
        
        // author
        name = dictionary["name"] as! String
        screenname = dictionary["screen_name"] as! String
        
        let profileUrlString = dictionary["profile_image_url_https"] as! String
        let profilePicBigString = profileUrlString.replacingOccurrences(of: "normal", with: "bigger")
        profilePic = URL(string: profileUrlString)
        profilePicBig = URL(string: profilePicBigString)
        
        tagline = dictionary["description"] as! String
        
        favsCount = dictionary["favourites_count"] as! Int
        followersCount = dictionary["followers_count"] as! Int
        followingCount = dictionary["friends_count"] as! Int
        statusesCount = dictionary["statuses_count"] as! Int
        
        let bannerString = dictionary["profile_banner_url"] as? String ///mobile_retina"
        if let bannerString = bannerString {
            bannerUrl = URL(string: bannerString)
        }
        
        
//        print("\(dictionary)")
    
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            
            // if a currentUser is not currently saved, fetch one from data
            if _currentUser == nil {
                
                // get data from saved json
                let defaults = UserDefaults.standard
                let data = defaults.object(forKey: "currentUserJson") as? Data
                
                // convert to dictionary to construct User
                if let data = data {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    
                    // set User to new dictionary
                    _currentUser = User(dictionary: dictionary)
                }
                
                
            }
            
            return _currentUser
        }
        
        set(user) {
            
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.json!, options: [])
                
                defaults.set(data, forKey: "currentUserJson")
            } else {
                defaults.removeObject(forKey: "currentUserJson")
            }
            
            
            defaults.synchronize()
        }
    }
    
}
