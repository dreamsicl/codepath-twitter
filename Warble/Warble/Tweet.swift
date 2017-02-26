//
//  Tweet.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    // 1. enumerate properties
    var text: String?
    
    var timestamp: Date?
    var timeAgo: Int!
    var timeAgoString: String!
    
    var rtCount: Int = 0
    var favCount: Int = 0
    var user: User?
    
    
    // 2. deserialize json
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        
        rtCount = (dictionary["retweet_count"] as? Int) ?? 0
        favCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
            
            // time ago in seconds
            timeAgo = Int(Date().timeIntervalSince(timestamp!))
            if timeAgo > 60 { // greater than 1 minute ago
                timeAgo = timeAgo / 60
                timeAgoString = "\(timeAgo)s ago"
                
                
                if timeAgo! > 60 { // greater than 1 hour ago
                    timeAgo = timeAgo! / 60
                    timeAgoString = "\(timeAgo)m ago"
                    
                    if timeAgo! > 24 { // greater than 1 day ago
                        timeAgo = timeAgo! / 24
                        timeAgoString = "\(timeAgo)d ago"
                    }
                }
            }
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
