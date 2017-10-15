//
//  DetailEntity+CoreDataProperties.h
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/18.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DetailEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *comments;
@property (nonatomic) NSTimeInterval date;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *location;

@end

NS_ASSUME_NONNULL_END
