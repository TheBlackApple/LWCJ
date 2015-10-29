//
//  MyTaskCell.h
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEvent.h"
@class MyTaskCell;
@protocol MyTaskCellDelegate <NSObject>
- (void)myTaskCell:(MyTaskCell *)taskCell;

@end
@interface MyTaskCell : UITableViewCell
@property (strong,nonatomic) UIImageView * mTypeImage;
@property (strong,nonatomic) UILabel * mNameLabel;
@property (strong,nonatomic) UILabel * mLineNameLabel;
@property (strong,nonatomic) UILabel * mTime;
@property (strong,nonatomic) UIButton * mBtnCollect;
@property (strong,nonatomic) TaskEvent * mModel;
@property (assign,nonatomic) id <MyTaskCellDelegate> delegate;
@end
