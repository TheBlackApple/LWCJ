//
//  NewTaskListViewController.h
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface NewTaskListViewController : BaseViewController
@property (strong,nonatomic) UIView * tableHeaderView;
-(id)initWithType:(NSString *)type;
@end
