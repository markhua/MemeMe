//
//  ViewController.swift
//  MemeMe
//
//  Created by Mark Zhang on 15/5/5.
//  Copyright (c) 2015年 Mark Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {

    //@IBOutlet weak var ImagePicked: UIImageView!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var imagePickerCamera: UIBarButtonItem!
    @IBOutlet weak var UpperText: UITextField!
    @IBOutlet weak var BottomText: UITextField!
    @IBOutlet weak var shareImage: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var sentMeme: UIBarButtonItem!
    @IBOutlet weak var colorButton: UIButton!
    
    var memes: [MemeObject]!
    override func viewWillAppear(animated: Bool) {
        imagePickerCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareImage.enabled = false
        if let image = imagePickerView.image  { shareImage.enabled = true }
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : 0
        ]
        super.viewDidLoad()
        UpperText.delegate = self
        BottomText.delegate = self
        UpperText.defaultTextAttributes = memeTextAttributes
        BottomText.defaultTextAttributes = memeTextAttributes
        UpperText.text = "TOP MEME"
        BottomText.text = "BOTTOM MEME"
        UpperText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        BottomText.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        UpperText.textAlignment = NSTextAlignment.Center
        BottomText.textAlignment = NSTextAlignment.Center
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeToKeyboardNotifications()
    }
    
    //subscriptions for keyboard action
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardHideNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.BottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        self.subscribeToKeyboardHideNotifications()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.BottomText.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        self.unsubscribeToKeyboardHideNotifications()
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //Text field editing delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP MEME") {textField.text = ""}
        else if (textField.text == "BOTTOM MEME") {textField.text = ""}
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Pick image from Camera
    @IBAction func PickImageFromCamera(sender: UIBarButtonItem) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    //Pick image from Album
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let pickController = UIImagePickerController()
        pickController.delegate = self
        pickController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    // Image picker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imagePickerView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Save and Share Meme
    @IBAction func shareMeme(sender: AnyObject) {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err: NSError!) -> Void in
        self.save()
        self.sentMeme.enabled = true
        controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //save a memed image
    func save() {
        var meme = MemeObject(text1: UpperText.text, text2: BottomText.text, image1: imagePickerView.image!, image2: generateMemedImage())
        //println ("saved")
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //generate a memed image
    func generateMemedImage() -> UIImage
    {
        toolBar.hidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolBar.hidden = false
        return memedImage
    }
    
    //Pop up the color picker
    @IBAction func colorPickerButton(sender: UIButton) {
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(284, 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }

    // Set the color of meme by the returns of Color Picker
    func setMemeColor (color: UIColor) {
        self.UpperText.defaultTextAttributes [NSForegroundColorAttributeName] = color
        self.BottomText.defaultTextAttributes [NSForegroundColorAttributeName] = color
    }
    
    // Display sent meme view
    @IBAction func PresentSentMemes(sender: UIButton) {
        
        self.performSegueWithIdentifier("tableview", sender: nil)
    }
}

