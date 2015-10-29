



//
//  MessageDetailViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

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
    
    self.titleLabel.text = @"消息管理";
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(10, 84, 30, 20)];
    label0.text = @"来自:";
    label0.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label0];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 80, 200, 20)];
    nameLabel.text = @"省交通局";
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 75, 80, 20)];
    dateLabel.text = @"2014年3月5日";
    dateLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:dateLabel];
    
    UILabel *titleLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(50, 130, 260, 20)];
    titleLabel0.text =[NSString stringWithFormat:@"标题：%@",@"采集任务"];
    titleLabel0.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:titleLabel0];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 160, 40, 20)];
    contentLabel.text = @"内容:";
    contentLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:contentLabel];
    
    UILabel *contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 155, 210, 60)];
    contentLabel1.text = @"采集北京市海淀区2014年新建桥梁数据，请于2014年3月10日前将数据上传至采集系统。";
    contentLabel1.font = [UIFont systemFontOfSize:14];
    contentLabel1.numberOfLines = 0;
    [self.view addSubview:contentLabel1];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(140, self.view.frame.size.height-60, 40, 40);
    deleteBtn.tag = 10;
    [deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    
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
        case 10:
        {
            //删除
            
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
