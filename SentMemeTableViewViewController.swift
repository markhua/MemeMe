//
//  SentMemeTableViewViewController.swift
//  MemeMe
//
//  Created by Mark Zhang on 15/5/8.
//  Copyright (c) 2015年 Mark Zhang. All rights reserved.
//

import UIKit

class SentMemeTableViewViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var memes: [MemeObject]!
    
    //get datasource from share model
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    //Display both meme text and memeimage in each row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = "\(meme.topText) , \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
    }
    
    //Dispaly meme detail after clicking each meme
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView")! as! MemeDetailView
        detailController.displayImage = self.memes[indexPath.row].memedImage
        detailController.imageID = indexPath.row
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    //Implement delete option when swipe on each table row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            memes.removeAtIndex(indexPath.row)
            
            //Update tableview with new data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            //Delete row from model
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
        }
    }
    
    //Enable edit button
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        // Do any additional setup after loading the view.
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(true, animated: animated)
        tableView.setEditing(editing, animated: true)
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
