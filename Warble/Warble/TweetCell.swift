
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
            
            timeAgoLabel.text = tweet.timeAgo
            
            retweetCountLabel.text = tweet.rtCountString
            favoriteCountLabel.text = tweet.favCountString
            
            if tweet.favorited {
                favoriteButton.setImage(UIImage(named: "favor-icon-red") , for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
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
            retweetButton.setImage(UIImage(named: "retweet-icon-green") , for: .normal)
            
            self.tweet.rtCount += 1
            
        } else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
            
            self.tweet.rtCount -= 1
        }
        
        // update count string
        self.tweet.rtCountString = (self.tweet.rtCount > 0) ? "\(self.tweet.rtCount)" : ""
        self.retweetCountLabel.text = self.tweet.rtCountString
        
        // TODO: post to Twitter
        
    }
    
    @IBAction func onFavButton(_ sender: Any) {
        // toggle tweet favorited state
        self.tweet.favorited = !self.tweet.favorited
        
        // visually change button based on favorited state
        if self.tweet.favorited {
            favoriteButton.setImage(UIImage(named: "favor-icon-red") , for: .normal)
            favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: -1.0, bottom: 0.0, right: 0.0)
            
            self.tweet.favCount += 1
            
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
            favoriteButton.imageEdgeInsets = UIEdgeInsets(top: -4.0, left: 0.0, bottom: 0.0, right: 0.0)
            
            self.tweet.favCount -= 1
            
        }
        
        
        self.tweet.favCountString = (self.tweet.favCount > 0) ? "\(self.tweet.favCount)" : ""
        self.favoriteCountLabel.text = self.tweet.favCountString
        
        // TODO: post to Twitter
    }
    

}
