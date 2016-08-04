//
//  TweetComposeViewController.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 8/2/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController {

    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var newTweetViewText: UITextView!
    
    override func viewDidLoad() {
        newTweetViewText.becomeFirstResponder()
        
        TwitterClient.sharedInstance.currentAccount({ (user: User) -> () in
            self.nameLabel.text = user.name
            let sn = (user.screenname)! as String
            self.screenNameLabel.text = "@\(sn)"
            
            if let profileImageURL = user.profileImageUrl {
                self.profileImageLabel.setImageWithURL(NSURL(string: profileImageURL)!)
            }
            self.profileImageLabel.layer.cornerRadius = 5
            self.profileImageLabel.clipsToBounds = true

            
            }, failure: {(error: NSError) -> () in
                print("error")
        })
    }

    @IBAction func onTweetButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        TwitterClient.sharedInstance.createNewTweet(["status": self.newTweetViewText.text], success: { (tweet: Tweet) -> () in
            
            print("Tweet created")
            
            }, failure: {(error: NSError) -> () in
                print("error")
                // Do any additional setup after loading the view.
                
        })
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
