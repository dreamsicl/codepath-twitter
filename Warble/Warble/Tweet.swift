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
    var id: String?
    var text: String?
    
    var timestamp: Date?
    var timeAgo: String?
    
    var rtCount: Int = 0
    var rtCountString: String!
    var favCount: Int = 0
    var favCountString: String!
    
    var user: User?
    
    var retweetedStatus: NSDictionary?
    
    
    // 2. deserialize json
    init(dictionary: NSDictionary) {
        retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        id = dictionary["id"] as? String
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
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            
            timeAgo = Date().shortTimeAgo(since: timestamp!)
            
        }
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
