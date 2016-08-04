//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 8/2/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet : Tweet!

    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextView: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var replyTweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.replyTweetTextView.hidden = true
        self.tweetTextView.text = tweet.text
        self.screenNameLabel.text = tweet.user?.screenname
        self.nameLabel.text = tweet.user?.name
        self.profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true

//        self.createdAtLabel.text = "\(tweet.createdAtString!))"
        refreshData()

    }
    
    func refreshData() {
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favouriteCountLabel.text = "\(tweet.favoritesCount)"
        
        if (tweet.favorited == true) {
            favouritesButton.setImage(UIImage(named: "FavoriteOn"), forState: UIControlState.Normal)
        }
        if (tweet.retweeted == true) {
            retweetButton.setImage(UIImage(named: "RetweetOn"), forState: UIControlState.Normal)
        }
    }
    
    
    @IBAction func replyButtonTap(sender: AnyObject) {
        replyTweetTextView.hidden = false
        let sn = (tweet.user?.screenname)! as String
        
        replyTweetTextView.text = "@\(sn) "
        
        replyTweetTextView.becomeFirstResponder()
        
    }
    @IBAction func retweetButtonTap(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(tweet.id!)
        tweet.retweetCount += 1
        tweet.retweeted = true
        refreshData()

    }
    
    @IBAction func onReply(sender: AnyObject) {

        TwitterClient.sharedInstance.createNewTweet(["status": self.replyTweetTextView.text, "in_reply_to_status_id": tweet.id!], success: { (tweet: Tweet) -> () in
            
            print("Reply sent to tweet id: " + "\(tweet.id)")
            
            }, failure: {(error: NSError) -> () in
                print("error in replying to tweet")
                // Do any additional setup after loading the view.
                
        })
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func favButtonTap(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(tweet.id!)
        tweet.favoritesCount += 1
        tweet.favorited = true
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
