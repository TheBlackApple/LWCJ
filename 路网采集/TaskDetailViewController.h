//
//  TaskDetailViewController.h
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskEvent.h"
#import "BaseViewController.h"
@interface TaskDetailViewController : BaseViewController
- (id)initWithData:(TaskEvent *)model;
@property (strong,nonatomic) TaskEvent * mModel;
@end
