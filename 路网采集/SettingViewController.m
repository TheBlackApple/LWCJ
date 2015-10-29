//
//  SettingViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "SettingViewController.h"
#import "MessageManageViewController.h"
#import "CollectionItemPresetViewController.h"
#import "AboutSystemViewController.h"
#import "UserManageViewController.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

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
    
    
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    
}
-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 1:
        {
            //导航栏右侧按钮:用户管理
            UserManageViewController *umvc = [[UserManageViewController alloc]init];
            umvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:umvc animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        
    }
    
    NSArray *array = [NSArray arrayWithObjects:@"消息管理",@"采集项预设置",@"关于系统", nil];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 12, 12)];
    iv.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:iv];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 140, 20)];
    label.text = [array objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        //消息管理
        MessageManageViewController *mmvc = [[MessageManageViewController alloc]init];
        mmvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mmvc animated:YES];
        //mmvc.hidesBottomBarWhenPushed = NO;
        
    }
    if(indexPath.row == 1)
    {
        //采集项预设置
        CollectionItemPresetViewController *cipvc = [[CollectionItemPresetViewController alloc]init];
        cipvc.hidesBottomBarWhenPushed = YES;
        cipvc.titleStr = @"采集项预设置";
        [self.navigationController pushViewController:cipvc animated:YES];
        //cipvc.hidesBottomBarWhenPushed = NO;
        
    }
    if(indexPath.row == 2)
    {
        //关于系统
        AboutSystemViewController *asvc = [[AboutSystemViewController alloc]init];
        asvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:asvc animated:YES];
        asvc.hidesBottomBarWhenPushed = NO;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
