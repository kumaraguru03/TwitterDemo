//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 7/31/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "HCCSZlqf3Ll4LGd3MXU89DTdX", consumerSecret: "ER1rjSIkfyFFuyA4au4GI8tqfCSVyf2hSi0m8JsooV2EnQymT5")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token!")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
            }) { (error: NSError!) -> Void in
                print("Failed to get the token: \(error)")
                self.loginFailure?(error)
                
        }

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("got access token")
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
            print("Failed to receive access token: \(error)")
            self.loginFailure?(error)
        }

    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("errorrrr: \(error)")
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("/1.1/account/verify_credentials.json", parameters: nil, progress: nil,
                   success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    
                    let userDictionary  = response as! NSDictionary
                    let user = User(dictionary: userDictionary)
                    success(user)
                    
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
                failure(error)
        })

    }
}
