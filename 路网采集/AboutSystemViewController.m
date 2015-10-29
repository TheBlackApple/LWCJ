//
//  AboutSystemViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "AboutSystemViewController.h"

@interface AboutSystemViewController ()

@end

@implementation AboutSystemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self initInterface];
    
}
-(void)initInterface
{
    
    self.titleLabel.text = @"关于系统";
    //[leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(120, 120, 80, 80)];
    iv.backgroundColor = [UIColor clearColor];
    iv.image = [UIImage imageNamed:@"icon"];
    [iv.layer setCornerRadius:8.0];
    iv.layer.masksToBounds = YES;
    [self.view addSubview:iv];
    
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(125, iv.frame.origin.y+iv.frame.size.height+20, 70, 20)];
    label0.text = @"采集大师";
    label0.textAlignment = NSTextAlignmentCenter;
    label0.font = [UIFont systemFontOfSize:16];
    label0.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label0];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(110, label0.frame.origin.y+label0.frame.size.height+5, 100, 20)];
    label1.text = @"v1.4版 for iPhone";
    label1.adjustsFontSizeToFitWidth = YES;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(40, label1.frame.origin.y+label1.frame.size.height+30, 240, 40)];
    label2.text = @"交通地理信息共享服务平台是针对地理信息空间数据采集的移动端采集工具，方便快捷，数据准确。";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.numberOfLines = 2;
    label2.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label2];
    
    UIButton * btnUpdate = [UIButton buttonWithType:UIButtonTypeCustom];
    btnUpdate.frame = CGRectMake((320 -374/2)/2, label2.frame.origin.y+label2.frame.size.height+20, 374/2, 75/2);
    [btnUpdate setBackgroundImage:[UIImage imageNamed:@"btn_update"] forState:UIControlStateNormal];
    [btnUpdate setBackgroundImage:[UIImage imageNamed:@"btn_update_down"] forState:UIControlStateHighlighted];
    [btnUpdate addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btnUpdate.tag = 1;
    [btnUpdate setTitle:@"检查更新" forState:UIControlStateNormal];
    [self.view addSubview:btnUpdate];
    
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(125, btnUpdate.frame.origin.y+btnUpdate.frame.size.height+30, 70, 20)];
    label3.text = @"版权所有";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label3];
    
    
}
-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 0:
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        
        }
            break;
        case 1:
        {
            
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
