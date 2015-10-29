//
//  NewTaskViewController.h
//  路网采集
//
//  Created by Charles Leo on 14/10/20.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NewTaskViewController : BaseViewController
@property (strong,nonatomic) UIView * tableHeaderView;

-(void)synchroData;
@end
