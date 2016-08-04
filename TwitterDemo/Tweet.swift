//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 7/31/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeSinceString: String?
    var id: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweeted: Bool?
    var favorited: Bool?

    class func tweetTimeStampAsString(timestamp: NSDate) -> String {
        let ti = -Int(timestamp.timeIntervalSinceNow)
        var timeAsString: String?
        
        if ti < 60 {
            timeAsString = "\(ti)s"
        } else if ti < 3600 {
            let mins = ti / 60
            timeAsString = "\(mins)m"
        } else if ti < 86400 {
            let hours = (ti / 60) / 60
            timeAsString = "\(hours)h"
        } else {
            let days = ((ti / 60) / 60) / 24
            timeAsString = "\(days)d"
        }
        return timeAsString!
    }
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        print("\(createdAtString)")
        
        id = dictionary["id_str"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int)!
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
        
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        timeSinceString = Tweet.tweetTimeStampAsString(createdAt!)
    }
    
    
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}