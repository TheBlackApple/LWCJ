//
//  TaskDetailViewController.m
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "DateFormmter.h"
#import "AppDelegate.h"
#import "DateFormmter.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController
@synthesize mModel;
- (id)initWithData:(TaskEvent *)model
{
    if (self = [super init]) {
        self.mModel = model;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.leftBtn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [self makeView];
}
-(void)btnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeView
{
    //图标
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 112/2, 112/2)];
    imageView.image =[UIImage imageNamed:self.mModel.mLayer];
    [self.view addSubview:imageView];
    
    //标题
    UILabel * title =[[UILabel alloc]initWithFrame:CGRectMake(76, 10, 60, 112/2)];
    title.text = @"采集任务";
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:title];
    
    //分割线
    UILabel * lineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height + 20, WIDTH, 1)];
    lineOne.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineOne];
    
    //截止日期
    UILabel * deadline = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x + title.frame.size.width + 10, 10, 120, 112/2)];
    NSLog(@"date is %@",self.mModel.mDeadLine);
    deadline.text =[NSString stringWithFormat:@"完成时间:%@",[DateFormmter intervalToDateString:self.mModel.mDeadLine andFormaterString:@"MM-dd-yyyy"]];
    deadline.backgroundColor = [UIColor clearColor];
    deadline.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:deadline];
    
    //要素名称
    UILabel * ysName = [[UILabel alloc]initWithFrame:CGRectMake(50, 40 + 112/2, WIDTH - 50, 30)];
    ysName.text =[NSString stringWithFormat:@"要素名称:%@" ,self.mModel.mName];
    ysName.backgroundColor = [UIColor clearColor];
    ysName.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:ysName];
    
    //要素代码
    UILabel * ysCode = [[UILabel alloc]initWithFrame:CGRectMake(50, 30 + 112/2 + 30, WIDTH - 50, 112/2)];
    ysCode.text =[NSString stringWithFormat:@"要素代码:%@", self.mModel.mCode];
    ysCode.backgroundColor = [UIColor clearColor];
    ysCode.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:ysCode];

    //中心桩号
    UILabel * zxCode = [[UILabel alloc]initWithFrame:CGRectMake(50, 30 +112/2 + 60, WIDTH - 50, 112/2)];
    zxCode.text =[NSString stringWithFormat:@"中心桩号:%@", self.mModel.mPos];
    zxCode.backgroundColor = [UIColor clearColor];
    zxCode.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:zxCode];

    //采集类型
    UILabel * cjType = [[UILabel alloc]initWithFrame:CGRectMake(50, 30 +112/2 + 90, WIDTH - 50, 112/2)];
    cjType.text =[NSString stringWithFormat:@"采集类型:%@", self.mModel.mLayer];
    cjType.backgroundColor = [UIColor clearColor];
    cjType.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:cjType];
    //中间文本
    UILabel * text =[[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 55)/2, cjType.frame.origin.y +cjType.frame.size.height, 55, 20)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:12.0f];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"所属路线";
    [self.view addSubview:text];

    //左边分割线
    UILabel * lineLeft =[[UILabel alloc]initWithFrame:CGRectMake(0,cjType.frame.origin.y + cjType.frame.size.height + 10, (WIDTH-55)/2, 1)];
    lineLeft.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineLeft];
        //右边分割线
    UILabel * lineRight =[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-55)/2 + 55,cjType.frame.origin.y+ cjType.frame.size.height + 10, WIDTH, 1)];
    lineRight.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineRight];

    //路线代码
    UILabel * lineCode = [[UILabel alloc]initWithFrame:CGRectMake(50, 60 + 112/2 + 120, WIDTH - 50, 112/2)];
    lineCode.text =[NSString stringWithFormat:@"路线代码:%@", self.mModel.mLineCode];
    lineCode.backgroundColor = [UIColor clearColor];
    lineCode.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:lineCode];
    
    //路线名称
    UILabel * lineName = [[UILabel alloc]initWithFrame:CGRectMake(50, 60 + 112/2 + 150 , WIDTH - 50, 112/2)];
    lineName.text =[NSString stringWithFormat:@"路线名称:%@", self.mModel.mLineName];
    lineName.backgroundColor = [UIColor clearColor];
    lineName.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:lineName];
    
    UIButton * btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCollect.frame = CGRectMake((WIDTH - 230/2)/2, lineName.frame.origin.y + lineName.frame.size.height + 20, 230/2, 75/2);
    [btnCollect setTitle:@"采集" forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:[UIImage imageNamed:@"btn_public"] forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:[UIImage imageNamed:@"btn_public_down"] forState:UIControlStateHighlighted];
    [btnCollect addTarget:self action:@selector(btnCollect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCollect];
    
}
- (void)btnCollect:(id)sender
{
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.currentTask = self.mModel;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
