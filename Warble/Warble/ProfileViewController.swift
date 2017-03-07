//
//  ProfileViewController.swift
//  Warble
//
//  Created by Vanna Phong on 3/4/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User!
    var tweets: [Tweet]!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // user info
        bannerImageView.setImageWith(user.bannerUrl!)
        profileImageView.setImageWith(user.profilePicBig)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        nameLabel.text = user.name
        screennameLabel.text = "@\(user.screenname as String)"
        descriptionLabel.text = user.tagline
        
        // populate # tweets/following/followers string
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let statusesString = numberFormatter.string(from: user.statusesCount as NSNumber)! + " Tweets | "
        let followingString = numberFormatter.string(from: user.followingCount as NSNumber)! + " Following | "
        let followersString = numberFormatter.string(from: user.followersCount as NSNumber)! + " Followers"
        
        tweetsLabel.text =  statusesString + followingString + followersString
        
        // table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // load user tweets 
        TwitterClient.sharedInstance.userTimeline(screenname: user.screenname, success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print("userTimeline(\(self.user.screenname)): ERROR: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
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
