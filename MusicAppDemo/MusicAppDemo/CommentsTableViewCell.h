//
//  CommentsTableViewCell.h
//  MusicAppDemo
//
//  Created by Chengzhi Jia on 15/10/18.
//  Copyright © 2015年 Chengzhi Jia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailEntity.h"

@interface CommentsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *detailComment;

@end
