//
//  CommentsEntity.swift
//  MusicAppDemoInSwift
//
//  Created by Chengzhi Jia on 15/11/22.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

import Foundation
import CoreData


class CommentsEntity: NSManagedObject {
    
    func section() -> String? {
        let thisDate = NSDate.init(timeIntervalSince1970: date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(thisDate)
    }
    
    
    
    

// Insert code here to add functionality to your managed object subclass
    

}
