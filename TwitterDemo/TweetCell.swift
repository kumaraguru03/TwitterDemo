//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 8/1/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func didReplyToTweet(tweet: Tweet)
    func didUpdateTweet()
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    @IBOutlet weak var retweetButton: UIImageView!
    @IBOutlet weak var replyButton: UIImageView!
    
    @IBOutlet weak var timeSinceLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            // Reset state
            profileImageView.image = nil
            nameLabel.text = nil
            screenNameLabel.text = nil
            tweetTextLabel.text = nil
            timeSinceLabel.text = nil
            
            // Set up current state
            nameLabel.text = tweet.user?.name
            nameLabel.sizeToFit()
            if let screenName = tweet.user?.screenname {
                screenNameLabel.text = "@\(screenName)"
            }
            tweetTextLabel.text = tweet.text
            if let profileImageURL = tweet.user?.profileImageUrl {
                profileImageView.setImageWithURL(NSURL(string: profileImageURL)!)
            }
            timeSinceLabel.text = tweet.timeSinceString
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
