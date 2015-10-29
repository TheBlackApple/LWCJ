//
//  NewTaskViewController.m
//  路网采集
//
//  Created by Charles Leo on 14/10/20.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "NewTaskViewController.h"
#import "NetRequestInterface.h"
#import "NSString+JSONDictionary.h"
#import "TaskListCell.h"
#import "TaskModel.h"
#import "TaskListModel.h"
#import "AppDelegate.h"
#import "TaskEvent.h"
#import "NewTaskListViewController.h"
#import "DateFormmter.h"
@interface NewTaskViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray * mArrayData;
@property (strong,nonatomic) NSMutableArray * mData;
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSMutableDictionary * mDict;
@property (strong,nonatomic) NSMutableDictionary * mutableDict;

@end

@implementation NewTaskViewController
@synthesize tableHeaderView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableArray *)getLocalData
{
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
    
    return [NSMutableArray arrayWithArray:array];
}
-(void)btnBack
{
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDel.isSelect = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    self.tableView.tableHeaderView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    self.mData = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * array = [self getLocalData];
    if (array.count == 0) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"立即同步" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        self.mArrayData = array;
        self.mutableDict = nil;
        self.mutableDict = [[NSMutableDictionary alloc]initWithCapacity:0];
        for (int i=0; i<self.mArrayData.count; i++) {
            TaskModel * model = [self.mArrayData objectAtIndex:i];
            NSString * countString = [NSString stringWithFormat:@"%@",[self.mutableDict objectForKey:model.mLayer]];
            if (countString == nil || [countString isEqualToString:@""]) {
                countString = @"0";
            }
            NSNumber * countNumber = [[NSNumber alloc]initWithInteger:[countString integerValue] + 1];
            [self.mutableDict setObject:countNumber forKey:model.mLayer];
        }
        
        NSArray * keyArray = self.mutableDict.allKeys;
        NSLog(@"self.mutableDict is %@",self.mutableDict);
        [self.mData removeAllObjects];
        for (int i = 0; i<keyArray.count; i++) {
            TaskListModel * model = [[TaskListModel alloc]init];
            model.mTaskListType = [keyArray objectAtIndex:i];
            model.mTaskCount = [[self.mutableDict objectForKey:[keyArray objectAtIndex:i]] integerValue];
            [self.mData addObject:model];
        }
        NSLog(@"self.mData is %@",self.mData);
        [self.tableView reloadData];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mArrayData = [[NSMutableArray alloc]initWithCapacity:0];
    self.titleLabel.text = @"选择任务";
    [self.leftBtn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
       self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView =  self.tableHeaderView;
    [self.view addSubview:self.tableView];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GIS" ofType:@"plist"];
    self.mDict= [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
}

#pragma mark -TableViewDelegate的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.mData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"ID";
    TaskListCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil) {
        cell = [[TaskListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    if (self.mData.count > 0) {
        TaskListModel  *model = [self.mData objectAtIndex:indexPath.row];
        cell.mImageView.image = [UIImage imageNamed:model.mTaskListType];
        cell.mLabel.text = [NSString stringWithFormat:@"%@ (%d)条",[self.mDict objectForKey:model.mTaskListType],model.mTaskCount];
        cell.mLayer = model.mTaskListType;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskListCell * cell = (TaskListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NewTaskListViewController * taskList = [[NewTaskListViewController alloc]initWithType:cell.mLayer];
    //是否已经采到点
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDel.isSelect == YES) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 52)];
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 32, 32)];
        imageview.image = [UIImage imageNamed:@"img_ok"];
        [headerView addSubview:imageview];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 32)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        label.text = @"数据采集成功,请选择相应任务";
        [headerView addSubview:label];
        
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(15, 52, WIDTH, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        line.alpha = 0.5;
        [headerView addSubview:line];
        taskList.tableHeaderView = headerView;
    }
    taskList.titleLabel.text = @"选择任务";
    [self.navigationController pushViewController:taskList animated:YES];
}
#pragma mark -UIAlertViewDelegate的代理方法

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self synchroData];
}
-(void)synchroData
{
    NSString * strUrl = [NSString stringWithFormat:@"%@plan/list/%@",requestHeader,[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
    NSLog(@"strUrl is %@",strUrl);
    NetRequestInterface * requestData= [[NetRequestInterface alloc]init];
    __weak NetRequestInterface * request = requestData;
    requestData.HUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    requestData.HUD.labelText = @"正在同步...";
    
    [requestData setCompleteBlock:^{
        NSString * strData = request.receiveData;
        NSArray * array = [strData JSONValue];
        self.mutableDict = [[NSMutableDictionary alloc]initWithCapacity:0];
        if ([array isKindOfClass:[NSArray class]])
        {
            request.HUD.labelText = @"同步完成";
            [request.HUD hide:YES afterDelay:2];
            [self.mArrayData removeAllObjects];
            if (array.count > 0) {
                AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                dispatch_async(dispatch_get_current_queue(), ^{
                    //持久化之前先删除数据
                    NSFetchRequest * request = [[NSFetchRequest alloc]init];
                    NSEntityDescription * entity = [NSEntityDescription entityForName:@"TaskEvent" inManagedObjectContext:appDel.managedObjetContext];
                    [request setEntity:entity];
                    NSError * error = nil;
                    //执行抓取数据的请求,返回符合条件的数据
                    NSArray * arrayLocal = [[appDel.managedObjetContext executeFetchRequest:request error:&error] mutableCopy];
                    //设置要抓取哪种类型的实体
                    
                    if(!error && arrayLocal.count > 0){
                        for(NSManagedObject * object in arrayLocal) {
                            [appDel.managedObjetContext deleteObject:object];
                        }
                    }
                    if (![appDel.managedObjetContext save:&error])
                    {
                        NSLog(@"error:%@",error);
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        for ( int i = 0; i<array.count; i++) {
                            NSDictionary * dict = [array objectAtIndex:i];
                        
                            TaskModel * model = [[TaskModel alloc]init];
                            model.mId = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
                            model.mName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                            model.mLineName = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lineName"]];
                            model.mLayer = [NSString stringWithFormat:@"%@",[dict objectForKey:@"layer"]];
                            //  NSString * time =[NSString stringWithFormat:@"%@",[dict objectForKey:@"deadLine"]];
                            //  [DateFormmter intervalToDateString:time andFormaterString:@"MM-dd-yyyy"];
                            model.mGather = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
                            model.mGatherTime = [NSString stringWithFormat:@"%@",[dict objectForKey:@"gatherTime"]];
                            model.mDeadLine = [NSString stringWithFormat:@"%@",[dict objectForKey:@"deadLine"]];
                            model.mCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
                            model.mPos = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pos"]];
                            model.mLineCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lineCode"]];
                            model.mType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                            model.mState = [NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]];
                            model.mAuditState = [NSString stringWithFormat:@"%@",[dict objectForKey:@"auditState"]];
                            
                            NSLog(@"mAuditState is %@ %@%@%@",model.mAuditState,model.mType,model.mState,model.mId);
                            
                            NSString * countString = [NSString stringWithFormat:@"%@",[self.mutableDict objectForKey:model.mLayer]];
                            if (countString == nil || [countString isEqualToString:@""]) {
                                countString = @"0";
                            }
                            NSNumber * countNumber = [[NSNumber alloc]initWithInteger:[countString integerValue] + 1];
                            [self.mutableDict setObject:countNumber forKey:model.mLayer];
                            [self.mArrayData addObject:model];
                            [self checkModel:model];
                            
                            TaskEvent * taskModel = [NSEntityDescription insertNewObjectForEntityForName:@"TaskEvent" inManagedObjectContext:appDel.managedObjetContext];
                            taskModel.mId = model.mId;
                            taskModel.mName = model.mName;
                            taskModel.mLineName = model.mLineName;
                            taskModel.mLayer = model.mLayer;
                            taskModel.mDeadLine = model.mDeadLine;
                            taskModel.mCode = model.mCode;
                            taskModel.mPos = model.mPos;
                            taskModel.mLineCode = model.mLineCode;
                            taskModel.mType = model.mType;
                            taskModel.mState = model.mState;
                            taskModel.mAuditState = model.mAuditState;
                            taskModel.mGather = model.mGather;
                            taskModel.mGatherTime = model.mGatherTime;
                            NSError * errors;
                            if ([appDel.managedObjetContext save:&errors]) {
                                NSLog(@"保存实体成功!!");
                            }
                            else
                            {
                                NSLog(@"保存实体出错: %@,%@" , errors ,[errors userInfo]);
                            }
                            NSLog(@"mutableDict is %@",self.mutableDict);
                            
                            [[NSUserDefaults standardUserDefaults]setObject:self.mutableDict forKey:@"list"];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            NSArray * keyArray = self.mutableDict.allKeys;
                            [self.mData removeAllObjects];
                            for (int i = 0; i<keyArray.count; i++) {
                                TaskListModel * model = [[TaskListModel alloc]init];
                                model.mTaskListType = [keyArray objectAtIndex:i];
                                model.mTaskCount = [[self.mutableDict objectForKey:[keyArray objectAtIndex:i]] integerValue];
                                [self.mData addObject:model];
                            }
                            NSLog(@"self.mData is %@",self.mData);
                            [self.tableView reloadData];
                        }
                    });
                }) ;
            }
        }
        else
        {
            request.HUD.labelText = @"同步失败";
            [request.HUD hide:YES afterDelay:2];
        }
    }];
    [requestData setFailBlock:^{
        request.HUD.labelText = @"同步失败";
        [request.HUD hide:YES afterDelay:2];
    }];
    [requestData basicRequest:strUrl];
}
-(void)checkModel:(TaskModel *)model
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
