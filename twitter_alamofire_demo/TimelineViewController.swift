//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, UIScrollViewDelegate {
    
    
    var tweets: [Tweet] = []
    var isMoreDataLoading = false
    
    @IBOutlet weak var tableView: UITableView!
    
    func  did(post: Tweet) {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }
    
//    func loadMoreData() {
//        
//        // ... Create the NSURLRequest (myRequest) ...
//        var myRequest: URL =
//        
//        // Configure session so that completion handler is executed on main UI thread
//        let session = URLSession(configuration: URLSessionConfiguration.default,
//                                 delegate:nil,
//                                 delegateQueue:OperationQueue.main
//        )
//        let task : URLSessionDataTask = session.dataTask(with: myRequest, completionHandler: { (data, response, error) in
//            
//            // Update flag
//            self.isMoreDataLoading = false
//            
//            // ... Use the new data to update the data source ...
//            
//            // Reload the tableView now that there is new data
//            self.tableView.reloadData()
//        })
//        task.resume()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                //... Code to load more results...
                APIManager.shared.getNewHomeTimeLine(with: Int(tweets.last!.id), completion: { (tweets: [Tweet]?, error:
                    Error?) in
                    if let error = error {
                        print("\(error.localizedDescription)")
                    } else if tweets?.count == 1{
                        
                    } else {
                        for tweet in tweets!{
                            self.tweets.append(tweet)
                        }
                        self.tableView.reloadData()
                    }
                    self.isMoreDataLoading = false
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize UIRefreshController
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        //add refresh contorl to the table view
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func composeButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "composeSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.userProfileImage.layer.masksToBounds = false
        cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.height/2
        cell.userProfileImage.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeSegue" {
            let destinationViewController = segue.destination as! ComposeViewController
            destinationViewController.delegate = self
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
