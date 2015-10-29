//
//  LoginViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "MainViewController.h"
#import "NetRequestInterface.h"
#import "NSString+JSONDictionary.h"
@interface LoginViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _lyhIndexScrollView;
    UIPageControl * _lyhPageControl;
    NetRequestInterface * loginRequest;
}
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.leftBarButtonItem = nil;
    [self initInterface];
    [self makeIndexView];
   
    
}
-(void)makeIndexView
{
    NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
    if (![userData objectForKey:@"isFirst"])
    {
        self.navigationController.navigationBarHidden = YES;
        _lyhIndexScrollView = [[UIScrollView alloc]init];
        _lyhIndexScrollView.backgroundColor = [UIColor clearColor];
        _lyhIndexScrollView.frame = CGRectMake(0, 0,WIDTH , HEIGHT);
        _lyhIndexScrollView.contentSize = CGSizeMake(WIDTH*3, HEIGHT);
        _lyhIndexScrollView.pagingEnabled= YES;
        _lyhIndexScrollView.bounces = NO;
        _lyhIndexScrollView.delegate= self;
        [self.view addSubview:_lyhIndexScrollView];
        [self.view bringSubviewToFront:_lyhIndexScrollView];
        _lyhPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, HEIGHT-100, 120, 30)];
        _lyhPageControl.backgroundColor = [UIColor clearColor];
        _lyhPageControl.userInteractionEnabled = NO;
        _lyhPageControl.numberOfPages = 3;
        [self.view addSubview:_lyhPageControl];
        _lyhPageControl.currentPage = 0;
        NSArray * array = @[@"welcome1.jpg",@"welcome2.jpg",@"welcome_jx.jpg"];
        int i;
        for(i=0;i<3;i++)
        {
            UIImageView *view = [[UIImageView alloc] init];
            view.frame = CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT);
            view.image = [UIImage imageNamed:[array objectAtIndex:i]];
            view.backgroundColor = [UIColor blueColor];
            [_lyhIndexScrollView addSubview:view];
        }
        NSNumber * number = [[NSNumber alloc]initWithBool:YES];
        [userData setObject:number forKey:@"isFirst"];
        [userData synchronize];
    }
}


#pragma mark Srollview的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x/320;
    //显示当前页
    _lyhPageControl.currentPage = x;
    if(x == 2)
    {
        self.navigationController.navigationBarHidden = NO;
        [UIView animateWithDuration:1 animations:^{
            _lyhIndexScrollView.alpha = 0;
        } completion:^(BOOL finished) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isFirst"];
            [userDefaults synchronize];
            NSLog(@"...移除引导页...");
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_lyhIndexScrollView removeFromSuperview];
                [_lyhPageControl removeFromSuperview];

            });
        }];
    }
}
-(void)initInterface
{
    
    self.titleLabel.text = @"用户登录";
    
    
    backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:backSv];
    
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(128, 80, 64, 64)];
    iv.image = [UIImage imageNamed:@"登录页图标"];
    [backSv addSubview:iv];
    
    
    
    UIImageView *usernameIv = [[UIImageView alloc]initWithFrame:CGRectMake(55, iv.frame.origin.y+iv.frame.size.height+40, 211, 34)];
    usernameIv.image = [UIImage imageNamed:@"输入框灰"];
    usernameIv.tag = 100;
    usernameIv.userInteractionEnabled = YES;
    [backSv addSubview:usernameIv];
    
    UIImageView *univ = [[UIImageView alloc]initWithFrame:CGRectMake(65, usernameIv.frame.origin.y+8, 18, 18)];
    univ.image = [UIImage imageNamed:@"登录帐号灰"];
    univ.tag = 101;
    [backSv addSubview:univ];
    
    usernameTf = [[UITextField alloc]initWithFrame:CGRectMake(90, iv.frame.origin.y+iv.frame.size.height+40, 180, 34)];
    usernameTf.delegate = self;
    usernameTf.placeholder = @"请输帐号";
    usernameTf.text = @"gljcjry";
    [backSv addSubview:usernameTf];
    
    
    UIImageView *passwordIv = [[UIImageView alloc]initWithFrame:CGRectMake(55, usernameTf.frame.origin.y+usernameTf.frame.size.height+10, 211, 34)];
    passwordIv.image = [UIImage imageNamed:@"输入框灰"];
    passwordIv.tag = 102;
    passwordIv.userInteractionEnabled = YES;
    [backSv addSubview:passwordIv];
    
    UIImageView *piv = [[UIImageView alloc]initWithFrame:CGRectMake(65, passwordIv.frame.origin.y+8, 18, 18)];
    piv.tag = 103;
    piv.image = [UIImage imageNamed:@"登录密码灰"];
    [backSv addSubview:piv];
    
    passwordTf = [[UITextField alloc]initWithFrame:CGRectMake(90, usernameTf.frame.origin.y+usernameTf.frame.size.height+10, 180, 34)];
    passwordTf.delegate = self;
    passwordTf.text = @"123456";
    passwordTf.secureTextEntry = YES;
    passwordTf.placeholder = @"请输密码";
    [backSv addSubview:passwordTf];
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(55, passwordTf.frame.origin.y+passwordTf.frame.size.height+10, 211, 34);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"登录高亮"] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 10;
    [backSv addSubview:loginBtn];
    
    
    control = [[UIControl alloc]initWithFrame:backSv.frame];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [backSv addSubview:control];
    [backSv sendSubviewToBack:control];
    
    
}

-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 10:
        {
            if(usernameTf.text.length>0 && passwordTf.text.length>0)
            {
                NSString *loginStr = [NSString stringWithFormat:@"%@user/login?userName=%@&password=%@",requestHeader,usernameTf.text,passwordTf.text];
                NSLog(@"loginStr is %@",loginStr);
                loginRequest = [[NetRequestInterface alloc]init];
                __weak NetRequestInterface * login = loginRequest;
                login.HUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                login.HUD.labelText = @"登录中...";
                [loginRequest setCompleteBlock:^{
                   
                    NSString *status = login.receiveData;
                  // NSLog(@"receiveData is %@",login.receiveData);
                    NSDictionary * dict = [status JSONValue];
                   // NSLog(@"dict is %@",dict);
                    if ([dict isKindOfClass:[NSDictionary class]])
                    {
                        NSString * state = [NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]];
                        if ([state isEqualToString:@"1"])
                        {
                            login.HUD.labelText = @"登录成功";
                            [login.HUD hide:YES afterDelay:2];
                            NSDictionary * department = [dict objectForKey:@"department"];
                            NSString * danwei = [NSString stringWithFormat:@"%@",[department objectForKey:@"name"]];
                            NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
                            [ud setObject:[dict objectForKey:@"username"]forKey:@"username"];   //用户名
                            [ud setObject:[dict objectForKey:@"name"] forKey:@"name"];       //真实姓名
                            [ud setObject:danwei forKey:@"danwei"];
                            [ud setObject:[dict objectForKey:@"mobile"] forKey:@"mobile"];
                            
                            NSDictionary * role = [dict objectForKey:@"role"];
                            [ud setObject:[role objectForKey:@"roleName"] forKey:@"zhiwei"];
                            [ud setObject:[role objectForKey:@"describe"] forKey:@"quanxian"];
                            [ud setObject:[dict objectForKey:@"id"] forKey:@"id"];
                            [ud synchronize];
                            
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLogin"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
                            del.window.rootViewController = del.navCtrl;
                        }
                       
                    }
                    else
                    {
                        login.HUD.labelText = @"登录失败";
                        [login.HUD hide:YES afterDelay:2];

                       // [[iToast makeText:@"服务错误"]show];
                    }
                }];
                [loginRequest setFailBlock:^{
                    NSLog(@"请求失败!!");
                    login.HUD.labelText = @"登录失败";
                    [login.HUD hide:YES afterDelay:2];
                }];
                [loginRequest basicRequest:loginStr];
            }
        }
            break;
            
        default:
            break;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == usernameTf)
    {
        UIImageView *iv = (UIImageView *)[backSv viewWithTag:100];
        iv.image = [UIImage imageNamed:@"输入框蓝"];
        UIImageView *iv1 = (UIImageView *)[backSv viewWithTag:101];
        iv1.image = [UIImage imageNamed:@"登录帐号蓝"];
        [backSv setContentOffset:CGPointMake(0, 40) animated:YES];
        
    }
    if(textField == passwordTf)
    {
        
        UIImageView *iv = (UIImageView *)[backSv viewWithTag:102];
        iv.image = [UIImage imageNamed:@"输入框蓝"];
        UIImageView *iv1 = (UIImageView *)[backSv viewWithTag:103];
        iv1.image = [UIImage imageNamed:@"登录密码蓝"];
        [backSv setContentOffset:CGPointMake(0, 80) animated:YES];
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField == usernameTf)
    {
        UIImageView *iv = (UIImageView *)[backSv viewWithTag:100];
        iv.image = [UIImage imageNamed:@"输入框灰"];
        UIImageView *iv1 = (UIImageView *)[backSv viewWithTag:101];
        iv1.image = [UIImage imageNamed:@"登录帐号灰"];
        [backSv setContentOffset:CGPointMake(0, 40) animated:YES];
        
    }
    if(textField == passwordTf)
    {
        UIImageView *iv = (UIImageView *)[backSv viewWithTag:102];
        iv.image = [UIImage imageNamed:@"输入框灰"];
        UIImageView *iv1 = (UIImageView *)[backSv viewWithTag:103];
        iv1.image = [UIImage imageNamed:@"登录密码灰"];
        [backSv setContentOffset:CGPointMake(0, 80) animated:YES];
    }
}

-(void)controlAction
{
    [usernameTf resignFirstResponder];
    [passwordTf resignFirstResponder];
    [backSv setContentOffset:CGPointMake(0, 0) animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
