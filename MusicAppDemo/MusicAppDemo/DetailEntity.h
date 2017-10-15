//
//  DetailEntity.h
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/18.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailEntity : NSManagedObject

@property (readonly, nonatomic) NSString *section;

@end

NS_ASSUME_NONNULL_END

#import "DetailEntity+CoreDataProperties.h"
