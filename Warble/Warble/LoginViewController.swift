//
//  LoginViewController.swift
//  Warble
//
//  Created by Vanna Phong on 2/25/17.
//  Copyright © 2017 Vanna Phong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "4uwY894kVL2E1KIIGS4xnLQsb", consumerSecret: "nPURIyLSDUR0q7wwJnftkpIyVEFhmQVeNxPe89L5kS6y1FmrvW")!
        
        twitterClient.deauthorize()
        twitterClient.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "warble://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            
            print("got a request token: \(requestToken?.token)")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)! as String)")!
            print("\(url)")
            UIApplication.shared.open(url, options: [:], completionHandler: { (success: Bool) -> Void in
                if success {
                    
                } else {
                    
                }
                
            })
        }, failure: { (error: Error?) -> Void in
            print("error fetching request token: \((error?.localizedDescription)! as String)")
        })
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
