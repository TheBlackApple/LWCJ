//
//  LoginViewController.h
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    
    UIScrollView *backSv;
    UITextField *usernameTf;
    UITextField *passwordTf;
    UIControl *control;
}

@end
