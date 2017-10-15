//
//  CommentsEntity+CoreDataProperties.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/22.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CommentsEntity {

    @NSManaged var comments: String?
    @NSManaged var date: NSTimeInterval
    @NSManaged var imageData: NSData?
    
    

}
