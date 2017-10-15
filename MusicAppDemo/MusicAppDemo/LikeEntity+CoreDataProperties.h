//
//  LikeEntity+CoreDataProperties.h
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/18.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LikeEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface LikeEntity (CoreDataProperties)

@property (nonatomic) int16_t likeCount;
@property (nonatomic) int16_t unlikeCount;

@end

NS_ASSUME_NONNULL_END
