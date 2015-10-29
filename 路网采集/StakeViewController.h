//
//  StakeViewController.h
//  路网采集
//
//  Created by Cecilia on 14-4-8.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"

@interface StakeViewController : BaseViewController<UITextFieldDelegate>
{
    
    UITextField *kTf;
    UITextField *jTf;
    
}

@property (retain ,nonatomic) NSString *contentStr;


@end
