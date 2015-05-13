//
//  MemeDetailView.swift
//  MemeMe
//
//  Created by Mark Zhang on 15/5/8.
//  Copyright (c) 2015年 Mark Zhang. All rights reserved.
//

import UIKit

class MemeDetailView: UIViewController {
    
    var displayImage : UIImage?
    var imageID: Int?
    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var notificationtext: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = displayImage
        {
            memedImage.image = image
        }
        notificationtext.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Delete meme
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(imageID!)
        memedImage.image = nil
        notificationtext.hidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
