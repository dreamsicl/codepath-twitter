//
//  ComposeTweetViewController.swift
//  Warble
//
//  Created by Vanna Phong on 3/4/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    
    let maxLength = 140
    
    var replyTo: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // customize navigation bar
        let tweetButton = UIBarButtonItem()
        tweetButton.title = "Tweet"
        tweetButton.action = #selector(onTweet)
        self.navigationItem.rightBarButtonItem = tweetButton
        
        profileImageView.setImageWith((User.currentUser?.profilePic)!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        nameLabel.text = User.currentUser?.name
        screennameLabel.text = "@\((User.currentUser?.screenname)! as String)"
        
        if let reply = self.replyTo {
           tweetField.text = reply
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onTweet() {
        
        let alertController = UIAlertController()
        alertController.title = "Error"
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
        }
        alertController.addAction(OKAction)
        
        if (tweetField.text?.characters.count)! > maxLength {
            // error
            alertController.message = "Tweet is too long."
            self.present(alertController, animated: true, completion: {
            })
        } else {
            TwitterClient.sharedInstance.tweet(tweet: tweetField.text!, success: {
                self.performSegue(withIdentifier: "toHomeTimeline", sender: self)
            }, failure: { (error: Error) in
                
                
                alertController.message = "\(error.localizedDescription)"
                self.present(alertController, animated: true, completion: {
                })
            })
            
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
