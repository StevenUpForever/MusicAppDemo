//
//  DetailTableViewController.h
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/17.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FetchWebData.h"

@interface PlayListTableViewController : UITableViewController
@property(nonatomic) FetchWebData *webdata;
@property(nonatomic) NSUInteger index;

@end
