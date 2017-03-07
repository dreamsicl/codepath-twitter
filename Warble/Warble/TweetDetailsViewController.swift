//
//  TweetDetailsViewController.swift
//  Warble
//
//  Created by Vanna Phong on 2/28/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set main tweet view
        if (tweet.retweetedStatus != nil) {
            let rt = Tweet(dictionary: tweet.retweetedStatus!)
            nameLabel.text = rt.user?.name
            screennameLabel.text = "@\((rt.user?.screenname)! as String)"
            tweetTextView.text = rt.text
            profileImageView.setImageWith(rt.user.profilePic)
            
        } else {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\((tweet.user?.screenname)! as String)"
            tweetTextView.text = tweet.text
            profileImageView.setImageWith(tweet.user.profilePic)
        }
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        timeAgoLabel.text = tweet.timeAgo
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d yyyy a"
        timestampLabel.text = formatter.string(from: tweet.timestamp!)
        
        
        
        // interaction view
        let fontSize = CGFloat(15)
        
        replyButton.titleLabel?.font = UIFont.fontAwesome(ofSize: fontSize)
        replyButton.setTitle(String.fontAwesomeIcon(name: .reply), for: .normal)
        
        retweetButton.titleLabel?.font = UIFont.fontAwesome(ofSize: fontSize)
        retweetButton.setTitle(String.fontAwesomeIcon(name: .retweet), for: .normal)
        retweetCountLabel.text = tweet.rtCountString
        
        favoriteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: fontSize)
        favoriteButton.setTitle(String.fontAwesomeIcon(name: .heart), for: .normal)
        favoriteCountLabel.text = tweet.favCountString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyButton(_ sender: Any) {
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
        
            retweetButton.setTitleColor(UIColor.darkGray, for: .normal)
            retweetCountLabel.textColor = UIColor.darkGray
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
            
            favoriteButton.setTitleColor(UIColor.darkGray, for: .normal)
            favoriteCountLabel.textColor = UIColor.darkGray
            
            self.tweet.favCount -= 1
            
        }
        
        
        self.tweet.favCountString = (self.tweet.favCount > 0) ? "\(self.tweet.favCount)" : ""
        self.favoriteCountLabel.text = self.tweet.favCountString
        
        // TODO: post to Twitter
        if let id = self.tweet.id {
            TwitterClient.sharedInstance.favoriteStatus(favoriting: self.tweet.favorited, id: "\(id)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! ComposeTweetViewController
        vc.replyTo = "@\(self.tweet.user.screenname as String)"
    }
 

}
