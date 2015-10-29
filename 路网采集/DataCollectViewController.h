//
//  DataCollectViewController.h
//  路网采集
//
//  Created by Charles Leo on 14/10/24.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TaskModel.h"
#import "BMapKit.h"
@interface DataCollectViewController : BaseViewController
- (id)initWithData:(TaskModel *)model;
@property (strong,nonatomic) TaskModel * mModel;

@end
