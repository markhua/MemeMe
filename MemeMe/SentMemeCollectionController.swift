//
//  SentMemeCollectionController.swift
//  MemeMe
//
//  Created by Mark Zhang on 15/5/9.
//  Copyright (c) 2015年 Mark Zhang. All rights reserved.
//

import UIKit

class SentMemeCollectionController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var memes: [MemeObject]!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        //reload data in case any meme was deleled in table view
        collectionView.reloadData()

        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    // MARK: Table View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.cellimage.image = meme.memedImage
        return cell
    }
    
    // Display meme detail when click one meme
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        //When click a meme,it navigates to the detail or delete the meme depending on the navigation bar button status
        if navigationItem.leftBarButtonItem!.title == "Edit"
        {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailView")! as! MemeDetailView
            detailController.displayImage = self.memes[indexPath.row].memedImage
            detailController.imageID = indexPath.row
            self.navigationController!.pushViewController(detailController, animated: true)
        }else
        {
            memes.removeAtIndex(indexPath.row)
            //Update tableview with new data source
            self.collectionView.deleteItemsAtIndexPaths([indexPath])
            //Delete row from model
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
        }
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
