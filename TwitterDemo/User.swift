//
//  User.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 7/31/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit

class User: NSObject {

    let currentUserKey = "kCurrentUserKey"
    let userDidLoginNotification = "userDidLoginNotification"
    let userDidLogoutNotification = "userDidLogoutNotification"
    
        var name: String?
        var screenname: String?
        var profileImageUrl: String?
        var bannerImageUrl: String?
        var followerCount: Int?
        var followingCount: Int?
        var tweetCount: Int?
        var tagline: String?
        var id: String?
        var dictionary: NSDictionary
        
        init(dictionary: NSDictionary) {
            self.dictionary = dictionary
            name = dictionary["name"] as? String
            screenname = dictionary["screen_name"] as? String
            profileImageUrl = dictionary["profile_image_url"] as? String
            bannerImageUrl = dictionary["profile_banner_url"] as? String
            followerCount = dictionary["followers_count"] as? Int
            followingCount = dictionary["friends_count"] as? Int
            tweetCount = dictionary["statuses_count"] as? Int
            tagline = dictionary["description"] as? String
            id = dictionary["id_str"] as? String
        }
        
//        func logout() {
//            User.currentUser = nil
//            TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
//            
//            NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
//        }
    
    static var _currentUser: User?

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey("currentUserKey") as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        print("Error retrieving JSON")
                        
                    }
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue: 0))
                    
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentUserKey")
                } catch {
                    print("Error parsing JSON")
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "currentUserKey")
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
