//
//  DataCollectionViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "DataCollectionViewController.h"
#import "StructureCollectionViewController.h"
#import "RoteCollectionViewController.h"
#import "UserManageViewController.h"


@interface DataCollectionViewController ()

@end

@implementation DataCollectionViewController

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
	
    [self initInterface];
}
-(void)initInterface
{
    
    self.titleLabel.text = @"采集大师";
    [self.rightBtn setImage:[UIImage imageNamed:@"用户管理灰"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"用户管理蓝"] forState:UIControlStateHighlighted];
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *array = [NSArray arrayWithObjects:@"构造物采集",@"路线采集",@"构造物采集高亮",@"路线采集高亮", nil];
    for (int i=0; i<2; i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:i+2]] forState:UIControlStateHighlighted];
        btn.frame = CGRectMake(100, 90+120*i, 100, 100);
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
    }
    
}

-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 1:
        {
            //用户管理
            UserManageViewController *umvc = [[UserManageViewController alloc]init];
            umvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:umvc animated:YES];
            
        }
            break;
            
        case 10:
        {
            //构造物采集
            StructureCollectionViewController *scvc = [[StructureCollectionViewController alloc]init];
            scvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:scvc animated:YES];
            //scvc.hidesBottomBarWhenPushed = NO;
            
        }
            break;
        case 11:
        {
            //路线采集
            RoteCollectionViewController *rcvc = [[RoteCollectionViewController alloc]init];
            rcvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rcvc animated:YES];
            //rcvc.hidesBottomBarWhenPushed = NO;
            
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
