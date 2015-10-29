//
//  EditMessageViewController.h
//  路网采集
//
//  Created by Cecilia on 14-4-3.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"

@interface EditMessageViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    UIScrollView *backSv;
    UITextField *dropNumTf;
    UITextField *nameTf;
    UITextField *numTf;
    UITextField *routeNameTf;
    UITextField *routeStyleTf;
    UITextField *rodeStyleTf;
    UITextField *beginTf;
    UITextField *endTf;
    NSString *collectionDate;
    UIControl *control;
    NSMutableDictionary *dict;
    
}

@property (retain ,nonatomic) NSString *contentStr;
@property (retain ,nonatomic) NSString *path;

@end
