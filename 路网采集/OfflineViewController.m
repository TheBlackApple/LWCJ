//
//  OfflineViewController.m
//  路网采集
//
//  Created by Charles Leo on 14-10-15.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "OfflineViewController.h"
#import "OfflineCityViewController.h"
#import "OfflineProvinceViewController.h"
@interface OfflineViewController ()

@end

@implementation OfflineViewController

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
	[self initView];
}

- (void)initView
{
    [self.leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"离线地图下载";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH - 175/2)/2, 80, 175/2, 175/2)];
    imageView.image =[UIImage imageNamed:@"img_downmap_1"];
    [self.view addSubview:imageView];
    
    UILabel * offlineName = [[UILabel alloc]initWithFrame:CGRectMake(0,175/2+imageView.frame.origin.y + 20, WIDTH, 30)];
    offlineName.backgroundColor = [UIColor clearColor];
    offlineName.textAlignment = NSTextAlignmentCenter;
    offlineName.font = [UIFont boldSystemFontOfSize:14.0];
    offlineName.text = @"江西省离线地图包";
    [self.view addSubview:offlineName];
    
    UILabel * offlineTip = [[UILabel alloc]initWithFrame:CGRectMake(25,offlineName.frame.origin.y + 40, WIDTH - 50, 60)];
    offlineTip.backgroundColor = [UIColor clearColor];
    offlineTip.textAlignment = NSTextAlignmentCenter;
    offlineTip.numberOfLines = 0;
    offlineTip.lineBreakMode = NSLineBreakByCharWrapping;
    offlineTip.font = [UIFont systemFontOfSize:14.0];
    offlineTip.text = @"地图文件较大,需要耗费流量较多,建议您在WI-FI网络下下载!";
    [self.view addSubview:offlineTip];
    NSArray * array = @[@"下载离线地图",@"下载各市地图"];
    CGFloat height = offlineTip.frame.origin.y + 60 ;
    for ( int i = 0; i<1; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        button.frame = CGRectMake((WIDTH - 374/2)/2, height + 90/2 * i + 30, 374/2, 75/2);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_update"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_update_down"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200 + i;
        [self.view addSubview:button];
    }
}
- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 200:
        {
            OfflineCityViewController * city = [[OfflineCityViewController alloc]init];
           // OfflineProvinceViewController * province = [[OfflineProvinceViewController alloc]init];
            [self.navigationController pushViewController:city animated:YES];
            break;
        }
        case 201:
        {
            OfflineCityViewController * city = [[OfflineCityViewController alloc]init];
            [self.navigationController pushViewController:city animated:YES];
            break;
        }
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
