//
//  TaskViewController.h
//  路网采集
//
//  Created by Charles Leo on 14-7-25.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface TaskViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView * lyhTableView;
    NSArray * arrayData;
}
@end
