//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Rey Oliva on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView
import AlamofireImage

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController {
    
    var delegate: ComposeViewControllerDelegate?
    var user: User = User.current!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var tweetTextView: RSKPlaceholderTextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.af_setImage(withURL: user.profilePicture!)
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2
        userProfileImage.clipsToBounds = true
        tweetTextView.layer.cornerRadius = 8
        tweetButton.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapPost(_ sender: Any) {
        APIManager.shared.composeTweet(with: tweetTextView.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
