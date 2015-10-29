//
//  MessageManageViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "MessageManageViewController.h"
#import "MessageDetailViewController.h"


@interface MessageManageViewController ()

@end

@implementation MessageManageViewController

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
    
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    nameLabel.text = @"省交通局";
    nameLabel.font = [UIFont systemFontOfSize:18];
    [cell.contentView addSubview:nameLabel];
    
    UILabel *titleLabel0 = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 200, 20)];
    titleLabel0.text = @"采集任务";
    titleLabel0.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:titleLabel0];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 200, 20)];
    contentLabel.text = @"北京市2014年新建桥梁采集";
    contentLabel.font =[UIFont systemFontOfSize:12];
    [cell.contentView addSubview:contentLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 10, 120, 20)];
    dateLabel.text = @"2014年3月5日";
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:dateLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageDetailViewController *mdvc = [[MessageDetailViewController alloc]init];
    mdvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mdvc animated:YES];
    mdvc.hidesBottomBarWhenPushed = NO;
    
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
