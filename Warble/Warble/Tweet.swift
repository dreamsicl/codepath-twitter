//
//  Tweet.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit
import DateToolsSwift

class Tweet: NSObject {
    // 1. enumerate properties
    var id: Int?
    var text: String?
    
    var timestamp: Date?
    var timeAgo: String?
    
    var rtCount: Int = 0
    var rtCountString: String!
    var retweeted: Bool = false
    var favCount: Int = 0 {
        didSet {
            
        }
    }
    var favCountString: String!
    var favorited: Bool = false
    
    var user: User!
    
    var retweetedStatus: NSDictionary?
    
    var media: NSDictionary?
    
    static var retweetColor = UIColor(red:0.10, green:0.81, blue:0.53, alpha:1.0)
    static var favoriteColor = UIColor(red:0.91, green:0.11, blue:0.31, alpha:1.0)
    
    
    // 2. deserialize json
    init(dictionary: NSDictionary) {
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        id = dictionary["id"] as? Int
        text = dictionary["text"] as? String
        
        /// rt/fav counts
        rtCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        if let retweetedStatus = retweetedStatus {
            favCount = (retweetedStatus["favorite_count"] as? Int) ?? 0
        } else {
            favCount = (dictionary["favorite_count"] as? Int) ?? 0
        }
        
        rtCountString = (rtCount > 0) ? "\(rtCount)" : ""
        favCountString = (favCount > 0) ? "\(favCount)" : ""
        
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        
        // timestamps
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            
            timeAgo = Date().shortTimeAgo(since: timestamp!)
            
        }
        
        // media
        media = dictionary["media"] as? NSDictionary
//        print("\(id)")
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
            
        }
        
        return tweets
        
    }
    
    

}
