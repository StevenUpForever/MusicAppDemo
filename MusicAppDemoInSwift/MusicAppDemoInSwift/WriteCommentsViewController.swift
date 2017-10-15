//
//  WriteCommentsViewController.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/22.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

import UIKit
import CoreData

class WriteCommentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textInput: UITextView!
    
    var entity: CommentsEntity?
    var alertController = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertViewLoad()
        self.utilityLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alertViewLoad() {
       self.alertController = UIAlertController.init(title: "Choose photos", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        let action1: UIAlertAction = UIAlertAction.init(title: "From gallery", style: UIAlertActionStyle.Default) { (action: UIAlertAction) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        let action2: UIAlertAction = UIAlertAction.init(title: "From Camera", style: UIAlertActionStyle.Default) { (alertAction: UIAlertAction) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        let action3: UIAlertAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        self.alertController.addAction(action1)
        self.alertController.addAction(action2)
        self.alertController.addAction(action3)
        }
    
    func utilityLoad() {
        
        self.textInput.layer.borderWidth = 1.0
        self.textInput.layer.cornerRadius = 2.0
        self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0
        self.imageButton.layer.borderWidth = 1.0
        
        if self.entity != nil {
            self.imageButton.setImage(UIImage.init(data: entity!.imageData!), forState: UIControlState.Normal)
            self.textInput.text = self.entity!.comments
        }
    }
    
    //mark -  button functions
    
    @IBAction func imageButtonProcess() {
        self.presentViewController(self.alertController, animated: true, completion: nil)
            }
    
    @IBAction func doneButtonProcess(sender: AnyObject) {
        if self.entity != nil {
            self.updateData()
        }
        else {
            self.insertData()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        

    }
    
    @IBAction func cancelButtonProcess(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageButton.setImage(image, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //mark - coreData process
    
    func insertData() {
        //The key point for insert real time
        let core = CoreDataProcess.defaultStack
        let insertEntity = NSEntityDescription.insertNewObjectForEntityForName("CommentsEntity", inManagedObjectContext: core.managedObjectContext) as! CommentsEntity
        insertEntity.comments = self.textInput.text
        insertEntity.imageData = UIImageJPEGRepresentation((self.imageButton.imageView?.image)!, 0.75)
        insertEntity.date = NSDate.timeIntervalSinceReferenceDate()
        core.saveContext()
    }
    
    func updateData() {
        self.entity?.comments = self.textInput.text
        self.entity?.imageData = UIImageJPEGRepresentation((self.imageButton.imageView?.image)!, 0.75)
        let core = CoreDataProcess.defaultStack
        core.saveContext()
    }
    
    
    
    
    

}
