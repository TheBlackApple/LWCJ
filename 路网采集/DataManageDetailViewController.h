//
//  DataManageDetailViewController.h
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"
#import "OCBorghettiView.h"
#import "ASIHTTPRequest.h"

@interface DataManageDetailViewController : BaseViewController<OCBorghettiViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>
{
    
    UIScrollView *backSv;
    NSMutableArray *dropArray;
    NSMutableArray *lineArray;
    
    
}



@property (retain ,nonatomic) NSString *contentStr;
@property (retain ,nonatomic) OCBorghettiView *ocbView;
@property (retain ,nonatomic) NSString *path;


@end
