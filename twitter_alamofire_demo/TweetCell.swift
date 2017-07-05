//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var favoritesCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            userNameLabel.text = tweet.user.name
            userHandleLabel.text = "@"+tweet.user.screenName!
            tweetTextLabel.text = tweet.text
            tweetDateLabel.text = tweet.createdAtString
            favoritesCount.text = "\(String(tweet.favoriteCount!))"
            retweetCount.text = String(tweet.retweetCount)
            userProfileImage.af_setImage(withURL: tweet.user.profilePicture!)
        }
    }
    
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tweet.favorited = sender.isSelected
        if (tweet.favorited)! {
            tweet.favoriteCount! += 1
            favoritesCount.text = "\(String(tweet.favoriteCount!))"
        } else {
            tweet.favoriteCount! -= 1
            favoritesCount.text = "\(String(tweet.favoriteCount!))"
        }
    }
    
    @IBAction func retweetButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        tweet.retweeted = sender.isSelected
        if (tweet.retweeted) {
            tweet.retweetCount += 1
            retweetCount.text = String(tweet.retweetCount)
        } else {
            tweet.retweetCount -= 1
            retweetCount.text = String(tweet.retweetCount)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
