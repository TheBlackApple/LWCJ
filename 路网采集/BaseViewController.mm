
//
//  BaseViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize titleLabel,leftBtn,rightBtn;

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
	
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"确定"] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor cyanColor]];
    
    [self initNavBar];
    
}

-(void)initNavBar
{
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    titleLabel.text = @"";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    leftBtn.tag = 0;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 40);
    rightBtn.tag = 1;
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
