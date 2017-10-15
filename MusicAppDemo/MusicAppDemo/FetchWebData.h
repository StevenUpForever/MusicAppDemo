//
//  FetchWebData.h
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/17.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FetchWebData : NSObject

@property(nonatomic) NSMutableArray *dataArray, *imageArray, *resourceArray, *titleArray;
@property(nonatomic) NSMutableArray *bigImage, *albumName, *artist, *releaseDate, *price, *media, *webpage, *summary;

- (void)fetchMainData: (NSInteger)index;
- (void)fetchDetailData: (NSInteger)index;
- (void)fetchMediaData: (NSInteger)index;
- (void)fetchTextData: (NSInteger)index;

@end
