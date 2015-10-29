//
//  UserManageViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "UserManageViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface UserManageViewController ()

@end

@implementation UserManageViewController

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
    [self initInterface];
    
}
-(void)initInterface
{
    
    self.titleLabel.text = @"用户管理";
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.frame = CGRectMake(0, 0, 40, 20);
//    [rightBtn setTitle:@"退出" forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UILabel * labelName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 84)];
//    labelName.text = @"用户名:gljcjry";
//    labelName.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:labelName];
//    
//    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 64 - 20, 10, 64, 64)];
//    iv.image = [UIImage imageNamed:@"登录页图标"];
//    [self.view addSubview:iv];
    
    
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT - 64) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    [self.view addSubview:tv];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 84)];
    view.backgroundColor = [UIColor clearColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((320 - 374/2)/2, (84-75/2)/2, 374/2, 75/2);
    [button setBackgroundImage:[UIImage imageNamed:@"btn_exit"] forState:UIControlStateNormal];
    [button setTitle:@"退出系统" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_exit_down"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(btnExit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    tv.tableFooterView = view;
    
    
}

-(void)btnExit
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@"" forKey:@"username"];
    [userDef setObject:@"" forKey:@"name"];
    [userDef setObject:@"" forKey:@"danwei"];
    [userDef setObject:@"" forKey:@"mobile"];
    [userDef setObject:@"" forKey:@"roleName"];
    [userDef setObject:@"" forKey:@"quanxi``an"];
    [userDef setObject:@"" forKey:@"id"];
    [userDef synchronize];
    
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.window.rootViewController =[[MLNavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    NSUserDefaults * userDef= [NSUserDefaults standardUserDefaults];
    
    NSString * username =[NSString stringWithFormat:@"用户名:%@",[userDef objectForKey:@"username"]];
    NSString * name = [NSString stringWithFormat:@"姓名:%@",[userDef objectForKey:@"name"]];
    NSString * danwei = [NSString stringWithFormat:@"单位:%@",[userDef objectForKey:@"danwei"]];
    
    NSString * zhiwei = [NSString stringWithFormat:@"职位:%@",[userDef objectForKey:@"zhiwei"]];
    NSString * mobile = [NSString stringWithFormat:@"电话:%@",[userDef objectForKey:@"mobile"]];
    NSString * quanxian = [NSString stringWithFormat:@"采集权限:%@",[userDef objectForKey:@"quanxian"]];
    
    
    NSArray *array = [NSArray arrayWithObjects:username,name,danwei,zhiwei,mobile,quanxian,nil];
    
//    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 12, 12)];
//    iv.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
//    [cell.contentView addSubview:iv];
    
    if (indexPath.row == 0) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 64 - 20, 10, 64, 64)];
        iv.image = [UIImage imageNamed:@"登录页图标"];
        [self.view addSubview:iv];
        [cell addSubview:iv];
    }
//
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 250, 20)];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.text = [array objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label];
//
//    
//    UIImageView *accessoryIv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"向右蓝箭头"]];
//    cell.accessoryView = accessoryIv;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
            //我的信息
            
            
        }
            break;
        case 11:
        {
            //我的采集权限
            
            
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
