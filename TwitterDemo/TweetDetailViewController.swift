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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweetTextView.text = tweet.text
        self.screenNameLabel.text = tweet.user?.screenname
        self.nameLabel.text = tweet.user?.name
        self.profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
//        self.createdAtLabel.text = tweet.createdAtString!
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
    
    @IBAction func retweetButtonTap(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetTweet(tweet.id!)
        tweet.retweetCount += 1
        tweet.retweeted = true
        refreshData()

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
