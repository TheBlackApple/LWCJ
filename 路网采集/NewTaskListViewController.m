//
//  NewTaskListViewController.m
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "NewTaskListViewController.h"
#import "MyTaskCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "TaskModel.h"
#import "TaskDetailViewController.h"
#import "DataCollectViewController.h"
#import "DateFormmter.h"


@interface NewTaskListViewController ()<UITableViewDataSource,UITableViewDelegate,MyTaskCellDelegate>
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSString * mType;
@property (strong,nonatomic) NSMutableArray * mArrayData;
@end

@implementation NewTaskListViewController
@synthesize tableHeaderView;
- (id)initWithType:(NSString *)type
{
    if (self = [super init]) {
        self.mType = type;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)getData
{
    self.mArrayData = [[NSMutableArray alloc]initWithCapacity:0];
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //创建抓取数据的请求对象
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"TaskEvent" inManagedObjectContext:appDel.managedObjetContext];
    //设置要抓取哪种类型的实体
    //设置抓取实体
    [request setEntity:entity];
    NSError * error = nil;
    //执行抓取数据的请求,返回符合条件的数据
    NSArray * array = [[appDel.managedObjetContext executeFetchRequest:request error:&error] mutableCopy];
    NSLog(@"arr.coutn is %d",array.count);
    for (int i = 0; i<array.count; i++) {
        TaskModel * model = [array objectAtIndex:i];
        if ([model.mLayer isEqualToString:self.mType]) {
            [self.mArrayData addObject:model];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.leftBtn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"新任务";
    [self getData];
    [self makeView];
}
- (void)viewDidDisappear:(BOOL)animated
{
    self.tableView.tableHeaderView = nil;
}
-(void)btnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeView
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDelegate的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mArrayData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  76;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"ID";
    MyTaskCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[MyTaskCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    TaskEvent * model = [self.mArrayData objectAtIndex:indexPath.row];
    cell.mModel = model;
    cell.mTypeImage.image = [UIImage imageNamed:model.mLayer];
    cell.mNameLabel.text = [NSString stringWithFormat:@"要素名称:%@",model.mName];
    cell.mLineNameLabel.text = [NSString stringWithFormat:@"截止时间:%@",[DateFormmter intervalToDateString:model.mDeadLine andFormaterString:@"MM-dd-yyyy"]];
    if (self.tableHeaderView != nil) {
        cell.mBtnCollect.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    MyTaskCell * cell = (MyTaskCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"code is %@",cell.mModel.mLineCode);
    if (self.tableHeaderView != nil)
    {
        NSDate * collectDate = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString * dateString = [dateFormatter stringFromDate:collectDate];
        NSLog(@"dateSting is %@",dateString);
        NSString * ptx = [[NSUserDefaults standardUserDefaults] objectForKey:@"ptx"];
        NSString * pty = [[NSUserDefaults standardUserDefaults] objectForKey:@"pty"];
        TaskModel * model = [[TaskModel alloc]init];
        model.mPtx = [ptx doubleValue];
        model.mPty = [pty doubleValue];
        model.mPos = cell.mModel.mPos;
        model.mName = cell.mModel.mName;
        model.mLineName = cell.mModel.mLineName;
        model.mCode = cell.mModel.mCode;
        model.mDeadLine =cell.mModel.mDeadLine;
        model.mId = cell.mModel.mId;
        model.mType = cell.mModel.mType;
        model.mGatherTime = cell.mModel.mGatherTime;
        model.mLayer = cell.mModel.mLayer;
        model.mAuditState = cell.mModel.mAuditState;
        model.mGather = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
        model.mState = cell.mModel.mState;
        model.mShape = cell.mModel.mShape;
        model.mStartPos = @"0";
        model.mEndPos = @"0";
        model.mImageData = cell.mModel.mImageData;
        DataCollectViewController * dataCollectView = [[DataCollectViewController alloc]initWithData:model];
        [self.navigationController pushViewController:dataCollectView animated:YES];
    }
    else
    {
        TaskDetailViewController * detailView = [[TaskDetailViewController alloc]initWithData:cell.mModel];
        [self.navigationController pushViewController:detailView animated:YES];
    }
}

#pragma mark - MyTaskCellDelegate的代理方法

- (void)myTaskCell:(MyTaskCell *)taskCell
{
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.currentTask = [[TaskEvent alloc]init];
    appDel.currentTask = taskCell.mModel;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
