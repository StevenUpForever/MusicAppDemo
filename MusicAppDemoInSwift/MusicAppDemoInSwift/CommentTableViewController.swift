//
//  CommentTableViewController.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/22.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

import UIKit
import CoreData

class CommentTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedController: NSFetchedResultsController = {
        var innerFetchedController = NSFetchedResultsController()
        let coreDataProcess = CoreDataProcess.defaultStack
        let fetchRequest = self.fetchRequest
        innerFetchedController = NSFetchedResultsController.init(fetchRequest: fetchRequest, managedObjectContext: coreDataProcess.managedObjectContext, sectionNameKeyPath: "section", cacheName: nil)
        innerFetchedController.delegate = self
        return innerFetchedController
    }()
    
    lazy var fetchRequest: NSFetchRequest = {
        let fetchRequest = NSFetchRequest.init(entityName: "CommentsEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
        return fetchRequest
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedController.performFetch()
        } catch let error as NSError {
            print(error.description)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.fetchedController.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo: NSFetchedResultsSectionInfo = self.fetchedController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("thirdCell", forIndexPath: indexPath) ?? UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "thirdCell")
        let entity = self.fetchedController.objectAtIndexPath(indexPath) as! CommentsEntity
        cell.imageView?.image = UIImage.init(data: entity.imageData!)
        cell.imageView?.layer.cornerRadius = (cell.imageView?.image?.size.width)! / 2
        cell.textLabel?.text = entity.comments
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedController.sections![section]
        return sectionInfo.name
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let comment = self.fetchedController.objectAtIndexPath(indexPath) as! CommentsEntity
            let coreData: CoreDataProcess = CoreDataProcess.defaultStack
            coreData.managedObjectContext.deleteObject(comment)
            coreData.saveContext()
        }
    }

    // mark - NSFetchedController part
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        case NSFetchedResultsChangeType.Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case NSFetchedResultsChangeType.Insert:
            self.tableView.insertSections(NSIndexSet.init(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
        case NSFetchedResultsChangeType.Delete:
            self.tableView.deleteSections(NSIndexSet.init(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoUpdate" {
            if let cell = sender as? UITableViewCell {
                let indexPath: NSIndexPath = self.tableView.indexPathForCell(cell)!
                let comment = segue.destinationViewController as! WriteCommentsViewController
                comment.entity = self.fetchedController.objectAtIndexPath(indexPath) as? CommentsEntity
            }
        }
    }

}
