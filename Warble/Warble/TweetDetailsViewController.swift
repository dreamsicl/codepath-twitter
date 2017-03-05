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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var directMessageButton: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set main tweet view
        if (tweet.retweetedStatus != nil) {
            let rt = Tweet(dictionary: tweet.retweetedStatus!)
            nameLabel.text = rt.user?.name
            screennameLabel.text = "@\((rt.user?.screenname)! as String)"
            tweetTextView.text = rt.text
//            profileImageView.setImageWith(rt.user.profileUrl)
            
        } else {
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\((tweet.user?.screenname)! as String)"
            tweetTextView.text = tweet.text
            print("\(tweet.user.profileUrl)")
//            profileImageView.setImageWith(tweet.user.profileUrl)
            profileImageView.setImageWith(tweet.user.profileUrl)
        }
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        timeAgoLabel.text = tweet.timeAgo
        
        //            retweetCountLabel.text = tweet.rtCountString
        //            favoriteCountLabel.text = tweet.favCountString
        
        if tweet.favorited {
            favoriteButton.setImage(UIImage(named: "favor-icon-red") , for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        }
        
        // back button
//        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
//        backButton.setTitleTextAttributes(attributes, for: .normal)
//        backButton.title = String.fontAwesomeIcon(name: .chevronLeft)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
