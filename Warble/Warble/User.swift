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
    
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String? // description
    
    var json: NSDictionary?
    
    
    init(dictionary: NSDictionary) {
        self.json = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        // unwrap if non-nil
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    
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
