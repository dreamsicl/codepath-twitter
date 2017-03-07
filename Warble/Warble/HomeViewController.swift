//
//  HomeViewController.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit
import FontAwesome_swift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var tweets: [Tweet]!
    
    var tappedIndexPath: IndexPath?
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var composeTweetButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // compose tweet button
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 18)] as [String: Any]
        composeTweetButton.setTitleTextAttributes(attributes, for: .normal)
        composeTweetButton.title = String.fontAwesomeIcon(name: .pencilSquareO)
        
        // get tweets from home timeline to display in table
        TwitterClient.sharedInstance.homeTimeline(max_id: "0", success: { (tweets: [Tweet]) in
        
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: Error) in
            print("\(error.localizedDescription as String)")
        }

        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Pull to refresh
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        self.tableView.insertSubview(refreshControl, at: 0)
        self.tableView.sendSubview(toBack: refreshControl)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
        
    }
    
    /* MARK: - Table View */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(tappedProfilePic))
        cell.profileImageView.addGestureRecognizer(tapImage)
        let tapReply = UITapGestureRecognizer(target: self, action: #selector(tappedReplyButton))
        cell.replyButton.addGestureRecognizer(tapReply)
        
        return cell
    }
    
    
    // MARK: - Additional network calls (infinite scroll, pull to refresh)
    func loadMoreHomeTimeline(max_id: String) {
        
        TwitterClient.sharedInstance.homeTimeline(max_id: max_id, success: { (moreTweets: [Tweet]) in
            
            self.isMoreDataLoading = false
            self.tweets = self.tweets + moreTweets
            self.tableView.reloadData()
            
        }) { (error: Error) in
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!self.isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = self.tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(self.tableView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                isMoreDataLoading = true
                
                // Code to load more results
                let max_id = tweets[tweets.count - 1].id! - 1
                loadMoreHomeTimeline(max_id: "\(max_id)")
            }
        }
    }
    
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .gray
            activityIndicatorView.hidesWhenStopped = true
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.isHidden = true
        }
        
        func startAnimating() {
            self.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // load *new* tweets
        let max_id = (tweets.first?.id)! + 1
        
        TwitterClient.sharedInstance.homeTimeline(max_id: "\(max_id)", success: { (newTweets: [Tweet]) in
            
            self.tweets.insert(contentsOf: newTweets, at: 0)
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            
        }) { (error: Error) in
            
            print("pullToRefresh(): ERROR: \(error)")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "tweetDetails") {
            
            let vc = segue.destination as! TweetDetailsViewController
            let indexPath = self.tableView.indexPath(for: sender as! TweetCell)
            
            let tweet = tweets[(indexPath?.row)!]
            vc.tweet = tweet
            
            
        } else if (segue.identifier == "profileView") {
            
            let vc = segue.destination as! ProfileViewController
            let tweet = tweets[(tappedIndexPath?.row)!]
            
            if tweet.retweeted {
                // open retweeted user, not the user we're following
                let rt = Tweet(dictionary: tweet.retweetedStatus!)
                vc.user = rt.user
            } else {
                vc.user = tweet.user
            }
            
        } else if (segue.identifier == "cellReplyTo") {
            let vc = segue.destination as! ComposeTweetViewController
            let tweet = tweets[(self.tappedIndexPath?.row)!]
            
            if tweet.retweeted {
                let rt = Tweet(dictionary: tweet.retweetedStatus!)
                vc.replyTo = "@\(rt.user.screenname as String) @\(tweet.user.screenname as String)"
            } else {
                vc.replyTo = "@\(tweet.user.screenname as String)"
            }
            
        }
    }
    
    func tappedReplyButton(recognizer: UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tableView)
        self.tappedIndexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        self.performSegue(withIdentifier: "cellReplyTo", sender: self)
    }
    
    
    func tappedProfilePic(recognizer: UITapGestureRecognizer) {
        
        let tapLocation = recognizer.location(in: self.tableView)
        self.tappedIndexPath = self.tableView.indexPathForRow(at: tapLocation)
        
        self.performSegue(withIdentifier: "profileView", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated:true)
    }
 

}
