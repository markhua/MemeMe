//
//  CollorPickerViewController.swift
//  MemeMe
//
//  Created by Mark Zhang on 15/5/11.
//  Copyright (c) 2015年 Mark Zhang. All rights reserved.
//

/* Forked on Github

ColorPickerViewController.swift

Originally Created by Ethan Strider on 11/28/14

*/

import UIKit

class ColorPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Global variables
    var tag: Int = 0
    var color: UIColor = UIColor.grayColor()
    var delegate: MemeEditorViewController? = nil
    
    // This function converts from HTML colors (hex strings of the form '#ffffff') to UIColors
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // UICollectionViewDataSource Protocol:
    // Returns the number of rows in collection view
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    // UICollectionViewDataSource Protocol:
    // Returns the number of columns in collection view
    internal func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 16
    }
    // UICollectionViewDataSource Protocol:
    // Inilitializes the collection view cells
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.tag = tag++
        
        return cell
    }
    
    // Recognizes and handles when a collection view cell has been selected
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var colorPalette: Array<String>
        
        // Get colorPalette array from plist file
        let path = NSBundle.mainBundle().pathForResource("colorPalette", ofType: "plist")
        let pListArray = NSArray(contentsOfFile: path!)
        
        if let colorPalettePlistFile = pListArray {
            colorPalette = colorPalettePlistFile as! [String]
            
            var cell: UICollectionViewCell  = collectionView.cellForItemAtIndexPath(indexPath)! as UICollectionViewCell
            var hexString = colorPalette[cell.tag]
            color = hexStringToUIColor(hexString)
            self.view.backgroundColor = color
            delegate?.setMemeColor(color)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}