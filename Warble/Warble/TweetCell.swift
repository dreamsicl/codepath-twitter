
//  TweetViewCell.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var dmButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            
            // set main tweet view
            if (tweet.retweetedStatus != nil) {
                let rt = Tweet(dictionary: tweet.retweetedStatus!)
                nameLabel.text = rt.user?.name
                screennameLabel.text = "@\((rt.user?.screenname)! as String)"
                tweetTextLabel.text = rt.text
                profileImageView.setImageWith((rt.user?.profileUrl)!)
                
            } else {
                nameLabel.text = tweet.user?.name
                screennameLabel.text = "@\((tweet.user?.screenname)! as String)"
                tweetTextLabel.text = tweet.text
                profileImageView.setImageWith((tweet.user?.profileUrl)!)
            }
            profileImageView.layer.cornerRadius = 3
            profileImageView.clipsToBounds = true
            
            timeAgoLabel.text = tweet.timeAgo
            
            retweetCountLabel.text = tweet.rtCountString
            favoriteCountLabel.text = tweet.favCountString
            
            if tweet.favorited {
                favoriteButton.setTitleColor(Tweet.favoriteColor, for: .normal)
            } else {
                favoriteButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let fontSize = CGFloat(15)
        
        replyButton.titleLabel?.font = UIFont.fontAwesome(ofSize: fontSize)
        replyButton.setTitle(String.fontAwesomeIcon(name: .reply), for: .normal)
        
        retweetButton.titleLabel?.font = UIFont.fontAwesome(ofSize: fontSize)
        retweetButton.setTitle(String.fontAwesomeIcon(name: .retweet), for: .normal)
        
        favoriteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: fontSize)
        favoriteButton.setTitle(String.fontAwesomeIcon(name: .heart), for: .normal)
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onRtButton(_ sender: Any) {
        // locally toggle tweet rted state
        self.tweet.retweeted = !self.tweet.retweeted
        
        
        // visually change button based on rted state
        if self.tweet.retweeted {
            retweetButton.setTitleColor(Tweet.retweetColor, for: .normal)
            retweetCountLabel.textColor = Tweet.retweetColor
            self.tweet.rtCount += 1
            
            
        } else {
            retweetButton.setTitleColor(UIColor.lightGray, for: .normal)
            retweetCountLabel.textColor = UIColor.lightGray
            self.tweet.rtCount -= 1
        }
        
        // update count string
        self.tweet.rtCountString = (self.tweet.rtCount > 0) ? "\(self.tweet.rtCount)" : ""
        self.retweetCountLabel.text = self.tweet.rtCountString
        
        // TODO: post to Twitter
        if let id = self.tweet.id {
            TwitterClient.sharedInstance.retweetStatus(retweeting: self.tweet.retweeted, id: "\(id)")
        }
    }
    
    @IBAction func onFavButton(_ sender: Any) {
        // toggle tweet favorited state
        self.tweet.favorited = !self.tweet.favorited
        
        // visually change button based on favorited state
        if self.tweet.favorited {
            
            favoriteButton.setTitleColor(Tweet.favoriteColor, for: .normal)
            favoriteCountLabel.textColor = Tweet.favoriteColor
            
            self.tweet.favCount += 1
            
        } else {
            
            favoriteButton.setTitleColor(UIColor.lightGray, for: .normal)
            favoriteCountLabel.textColor = UIColor.lightGray
            
            self.tweet.favCount -= 1
            
        }
        
        
        self.tweet.favCountString = (self.tweet.favCount > 0) ? "\(self.tweet.favCount)" : ""
        self.favoriteCountLabel.text = self.tweet.favCountString
        
        // TODO: post to Twitter
        if let id = self.tweet.id {
            TwitterClient.sharedInstance.favoriteStatus(favoriting: self.tweet.favorited, id: "\(id)")
        }
    }
    

}
