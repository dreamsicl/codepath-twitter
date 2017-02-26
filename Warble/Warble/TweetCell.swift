
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
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\((tweet.user?.screenname)! as String)"
            tweetTextLabel.text = tweet.text
            profileImageView.setImageWith((tweet.user?.profileUrl)!)
            
            timeAgoLabel.text = tweet.timeAgo
            
            replyImageView.image = UIImage(named: "reply-icon")
            retweetImageView.image = UIImage(named: "retweet-icon")
            favoriteImageView.image = UIImage(named: "favor-icon")
            
            if tweet.rtCount > 0 {
                retweetCountLabel.text = "\(tweet.rtCount)"
            } else {
                retweetCountLabel.text = ""
            }
            
            if tweet.favCount > 0 {
                favoriteCountLabel.text = "\(tweet.favCount)"
            } else {
                favoriteCountLabel.text = ""
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        print("\(tweet.user?.name)")
//        print("\(tweet.user?.screenname)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
