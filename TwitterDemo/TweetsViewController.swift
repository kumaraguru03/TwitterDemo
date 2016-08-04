//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Guru Vijayakumar on 8/1/16.
//  Copyright © 2016 Guru Vijayakumar. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tweets : [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!

    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            }, failure: {(error: NSError) -> () in
                print("error")
        // Do any additional setup after loading the view.
    
        })
    }

    func refresh(refreshControl: UIRefreshControl) {

        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            print("refreshed...")
            refreshControl.endRefreshing()

            }, failure: {(error: NSError) -> () in
                print("error in refreshing")
                // Do any additional setup after loading the view.
                
        })
     
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets where tweets.count > 0 {
            return tweets.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "detailViewSegueId") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
        
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
        
            tweetDetailViewController.tweet = tweet
        }
        print("prepare for segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
