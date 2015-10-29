//
//  MainViewController.m
//  路网采集
//
//  Created by Charles Leo on 14-10-14.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "MainViewController.h"
//#import "BaseViewController.h"
#import "BMKMapView.h"
#import "BMapKit.h"
#import "CollectListView.h"
#import "MenuListView.h"
#import "AboutSystemViewController.h"
#import "UserManageViewController.h"
#import "OfflineViewController.h"
#import "SearchView.h"
#import "SearchResultViewController.h"
#import "PositionInfoView.h"
#import "TaskViewController.h"
#import "TaskModel.h"
#import "NewTaskViewController.h"
#import "AppDelegate.h"
#import "DataCollectViewController.h"
#import "baiduToWGS84.h"
#import "RoteCollectionViewController.h"
#import "NoTaskCollectViewController.h"
#import "CustomOverlay.h"
#import "CustomOverlayView.h"
#import "PointObject.h"

@interface MainViewController ()<BMKMapViewDelegate,UIScrollViewDelegate,CollectListViewDelegate,MenuListViewDelegate,SearchViewDelegate,SearchResultDelegate,BMKSearchDelegate,PositionInfoViewDelegate,UIAlertViewDelegate>
{
    UIScrollView * _lyhIndexScrollView;
    UIPageControl * _lyhPageControl;
    CollectListView * _collectListView;
    MenuListView * _menuListView;
    UIButton * btnSearch;
    BMKSearch * _search;
    PositionInfoView * _positionInfoView;
    UIButton * btnCollectPoint;
    BMKPointAnnotation * _annotation;
    UIView * _containerView;
    UILabel * numberLabel;
    NSTimer * timer; //采集定时器
    UILongPressGestureRecognizer * longPress;//长按手势
    NSString * selcetMode;
    UIButton * btnLeft;//导航栏左侧按钮
    CLLocationCoordinate2D touchPoint;
    NSMutableArray * locationArray;//WGS84
    NSMutableArray * locationOriginalArray;//BD09
    int flag;//暂停,开始标志
    UIView * lineInfoView;//采线信息视图
    UIButton *collectionBtn;//采点按钮
    UIButton *btnPhoto;//拍照按钮
    UIButton *btnStop;//终止按钮
    UILabel *lineInfoLabel;//采集的点个数,采集的线长度
    NSMutableArray * pointArray;//存储我的位置
    double myDistance;//记录线长
    NSMutableArray * overLays;
    UIView * mengBanView;
}

@property (strong,nonatomic) BMKMapView * mMapView;
@property (strong,nonatomic) UIImageView * mImageView;
@property (strong,nonatomic) BMKPoiInfo * mPoiInfo;
@property (strong,nonatomic) TaskModel * mCurrentTask;
@property (strong,nonatomic) UIImageView * mTipImage;//主页操作提示图片
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"采集系统";
        btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame = CGRectMake(0, 0, 64/2, 64/2);
        [btnLeft addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btnLeft.tag = 100;
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"img_nav_cd"] forState:UIControlStateNormal];
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"img_nav_cddown"] forState:UIControlStateHighlighted];
        UIBarButtonItem * barLeft = [[UIBarButtonItem alloc]initWithCustomView:btnLeft];
        self.navigationItem.leftBarButtonItem = barLeft;

        UIButton * btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        btnRight.frame = CGRectMake(0, 0, 64/2, 64/2);
        [btnRight addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btnRight.tag = 101;
        [btnRight setBackgroundImage:[UIImage imageNamed:@"img_task"] forState:UIControlStateNormal];
        [btnRight setBackgroundImage:[UIImage imageNamed:@"img_task_down"] forState:UIControlStateHighlighted];
        UIBarButtonItem * barRight = [[UIBarButtonItem alloc]initWithCustomView:btnRight];
        self.navigationItem.rightBarButtonItem = barRight;
    }
    return self;
}
-(BOOL)isLeftListAdded
{
    UIView * view = [self.view viewWithTag:1000];
    if (view !=nil) {
        return YES;
    }
    return NO;
}
-(BOOL)isRightListAdded
{
    UIView * view = [self.view viewWithTag:1001];
    if (view != nil) {
        return YES;
    }
    return NO;
}
- (void)makeLeftListView
{
    if ([self isLeftListAdded])
    {
        [_collectListView removeFromSuperview];
        _collectListView = nil;
    }
    else
    {
        _collectListView = [[CollectListView alloc]initWithFrame:CGRectMake(2, 0, 304/2, 287/2)];
        _collectListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"left"]];
        _collectListView.tag = 1000;
        _collectListView.delegate = self;
        [self.view addSubview:_collectListView];
    }
    if ([self isRightListAdded]) {
        [_menuListView removeFromSuperview];
        _menuListView= nil;
    }
}
-(void)makeRightListView
{
    if ([self isRightListAdded]) {
        [_menuListView removeFromSuperview];
        _menuListView = nil;
    }
    else
    {
        _menuListView = [[MenuListView alloc]initWithFrame:CGRectMake(WIDTH - 304/2- 2, 0, 304/2, 287/2)];
        _menuListView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"right"]];
        _menuListView.delegate = self;
        _menuListView.tag = 1001;
        [self.view addSubview:_menuListView];
    }
    if ([self isLeftListAdded])
    {
        [_collectListView removeFromSuperview];
        _collectListView = nil;
    }
}
-(void)makePostionInfoView
{
    UIView * view = [self.view viewWithTag:400];
    [view removeFromSuperview];
    _positionInfoView = [[PositionInfoView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, WIDTH, 70)];
    _positionInfoView.tag =400;
    if (self.mPoiInfo == nil) {
         _positionInfoView.label.text =[NSString stringWithFormat:@"参考位置:获取中..."];
    }
    else
    {
         _positionInfoView.label.text =[NSString stringWithFormat:@"参考位置:%@", self.mPoiInfo.name];
    }
    _positionInfoView.delegate = self;
    _positionInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_positionInfoView];
    [UIView animateWithDuration:0.35 animations:^{
        _positionInfoView.frame = CGRectMake(0, self.view.bounds.size.height - 70, WIDTH, 70);//btnCollectPoint.frame.origin.y - 70
        btnCollectPoint.frame = CGRectMake(btnCollectPoint.frame.origin.x, HEIGHT -_positionInfoView.frame.size.height - btnCollectPoint.frame.size.height - 64, btnCollectPoint.frame.size.width, btnCollectPoint.frame.size.height);
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    btnCollectPoint.frame = CGRectMake(310 - 50, self.view.bounds.size.height - 61, 100/2, 102/2);
    self.mMapView.showsUserLocation = YES;
    [self.mMapView setCenterCoordinate:self.mMapView.userLocation.coordinate animated:YES];
    [self.mMapView removeAnnotation:_annotation];
    _annotation = nil;
    UIView * view= [self.view viewWithTag:400];
    [UIView animateWithDuration:0.35 animations:^{
        view.frame = CGRectMake(0, self.view.bounds.size.height, WIDTH, 70);
    }completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    _collectListView.delegate = nil;
    _positionInfoView.delegate = nil;
}
#pragma mark - PositonInfoViewDelegate的代理方法
- (void)positionChecked:(PositionInfoView *)positionView
{
    NSLog(@"开始采点");
    //移除位置信息
    [UIView animateWithDuration:0.35 animations:^{
        _positionInfoView.frame = CGRectMake(0, HEIGHT, WIDTH, _positionInfoView.frame.size.height);
    }
    completion:^(BOOL finished) {
        [_positionInfoView removeFromSuperview];
    }];
    //采点
    if ([selcetMode isEqualToString:@"point"])
    {
        NSLog(@"point");
        baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
        NSArray *arr =[btw BD09ToWGS84With:self.mMapView.userLocation.coordinate.longitude and:self.mMapView.userLocation.coordinate.latitude];
        CLLocationCoordinate2D goalCoordiante = CLLocationCoordinate2DMake([[arr objectAtIndex:1] doubleValue], [[arr objectAtIndex:0] doubleValue]);
        NSNumber * ptxNumber = [NSNumber numberWithDouble:goalCoordiante.longitude];
        NSNumber * ptyNumber = [NSNumber numberWithDouble:goalCoordiante.latitude];
        NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:ptxNumber forKey:@"ptx"];
        [userDef setObject:ptyNumber forKey:@"pty"];
        [userDef synchronize];
        
    }
    //长按采点
    else if([selcetMode isEqualToString:@"longPress"])
    {
        NSLog(@"longpress");
        baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
        NSArray *arr =[btw BD09ToWGS84With: touchPoint.longitude and:touchPoint.latitude];
        CLLocationCoordinate2D goalCoordiante = CLLocationCoordinate2DMake([[arr objectAtIndex:1] doubleValue], [[arr objectAtIndex:0] doubleValue]);
        NSNumber * ptxNumber = [NSNumber numberWithDouble:goalCoordiante.longitude];
        NSNumber * ptyNumber = [NSNumber numberWithDouble:goalCoordiante.latitude];
        NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:ptxNumber forKey:@"ptx"];
        [userDef setObject:ptyNumber forKey:@"pty"];
        [userDef synchronize];
    }
    [self makeAnimationAndCollectPoint];
}
-(void)makeAnimationAndCollectPoint
{
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _containerView.backgroundColor = [UIColor whiteColor];
    _containerView.alpha = 0.8;
    [self.view.window addSubview:_containerView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, WIDTH, 40)];
    label.text = @"正在采集...";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:30.0f];
    label.textColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [_containerView addSubview:label];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 110 + 60, 100, 100)];
    imageView.image = [UIImage imageNamed:@"get_point"];
    [_containerView addSubview:imageView];
    
    numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, HEIGHT - WIDTH + 40, WIDTH - 40, WIDTH - 40)];
    numberLabel.text = @"";
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.font = [UIFont systemFontOfSize:70.0f];
    numberLabel.textColor = [UIColor colorWithRed:52.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [_containerView addSubview:numberLabel];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerGo) userInfo:nil repeats:YES];
    
}
- (void)timerGo
{
    NSLog(@"AAA");
    static int number = 3;
    numberLabel.text = [NSString stringWithFormat:@"%d",number];
    [UIView animateWithDuration:0.35 animations:^{
        
    }];
    if (number == 0) {
        [_containerView removeFromSuperview];
        NSLog(@"采集完成!!");
        number = 3;
        [timer invalidate];
        timer = nil;
        [self.mMapView removeAnnotation:_annotation];
        AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSLog(@"currentTask is %@",appDel.currentTask);
        
        if (appDel.currentTask == nil) {
            UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"位置信息采集成功" delegate:self cancelButtonTitle:@"无采集任务" otherButtonTitles:@"选择任务", nil];
            [alertView show];
        }
        else
        {
            NSNumber * ptx = [[NSUserDefaults standardUserDefaults] objectForKey:@"ptx"];
            NSNumber * pty = [[NSUserDefaults standardUserDefaults] objectForKey:@"pty"];
            
            TaskModel * model = [[TaskModel alloc]init];
            model.mPtx = [ptx doubleValue];
            model.mPty = [pty doubleValue];
            model.mPos = appDel.currentTask.mPos;
            model.mName = appDel.currentTask.mName;
            model.mLineName = appDel.currentTask.mLineName;
            model.mCode = appDel.currentTask.mCode;
            model.mDeadLine =appDel.currentTask.mDeadLine;
            model.mId = appDel.currentTask.mId;
            model.mType = appDel.currentTask.mType;
            model.mGatherTime = appDel.currentTask.mGatherTime;
            model.mLayer = appDel.currentTask.mLayer;
            model.mAuditState = appDel.currentTask.mAuditState;
            model.mGather = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
            model.mState = appDel.currentTask.mState;
            model.mShape = appDel.currentTask.mShape;
            model.mStartPos = @"0";
            model.mEndPos = @"0";

            DataCollectViewController * dataCollectView = [[DataCollectViewController alloc]initWithData:model];
            [self.navigationController pushViewController:dataCollectView animated:YES];
        }
    }
    number --;
}
#pragma mark - UIAlertViewDelegate的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"无采集任务");
        NoTaskCollectViewController * noTaskView = [[NoTaskCollectViewController alloc]init];
        [self.navigationController pushViewController:noTaskView animated:YES];
    }
    else
    {
        NSLog(@"选择任务");
        AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDel.isSelect = YES;
        NewTaskViewController * taskList = [[NewTaskViewController alloc]init];
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
        taskList.titleLabel.text = @"选择任务";
        [self.navigationController pushViewController:taskList animated:YES];
    }
}
- (void)addAnnotation
{
    if (_annotation !=nil) {
        [self.mMapView removeAnnotation:_annotation];

    }
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.coordinate = self.mMapView.userLocation.coordinate;
    [self.mMapView addAnnotation:_annotation];
    [self.mMapView setCenterCoordinate:self.mMapView.userLocation.coordinate];
}
-(void)reverseCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_search == nil) {
         _search = [[BMKSearch alloc]init];
        _search.delegate = self;
    }
    [_search reverseGeocode:coordinate];
}

- (void)clearCollectLineView
{
    [lineInfoView removeFromSuperview];
    [collectionBtn removeFromSuperview];
    [btnPhoto removeFromSuperview];
    [btnStop removeFromSuperview];
}
#pragma CollectListViewDelegate的代理方法
- (void)modeSelect:(CollectListView *)collectListView andIndexPathRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            NSLog(@"Left A");
            if (timer !=nil) {
                [timer invalidate];
                timer = nil;
            }
            [self.mMapView removeOverlays:overLays];
            selcetMode = @"point";
            [btnLeft setBackgroundImage:[UIImage imageNamed:@"img_nav_cd"] forState:UIControlStateNormal];
            [self clearCollectLineView];
            [collectListView removeFromSuperview];//移除采集列表视图
            [_positionInfoView removeFromSuperview];//移除位置信息视图
            btnCollectPoint.hidden = NO;
            btnSearch.hidden = NO;
            btnCollectPoint.frame = CGRectMake(310 - 50, self.view.bounds.size.height - 61, 100/2, 102/2);
            self.mMapView.showsUserLocation = YES;
            [self.mMapView setCenterCoordinate:self.mMapView.userLocation.coordinate animated:YES];
            if (_annotation !=nil) {
                [self.mMapView removeAnnotation:_annotation];
                _annotation = nil;
            }
            
            UIView * view= [self.view viewWithTag:400];
            [UIView animateWithDuration:0.35 animations:^{
                view.frame = CGRectMake(0, self.view.bounds.size.height, WIDTH, 70);
            }
            completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
            break;
        }
        case 1:
        {
            NSLog(@"Left B");

            pointArray = nil;
            overLays = nil;
            pointArray = [[NSMutableArray alloc]initWithCapacity:0];//坐标点
            overLays = [[NSMutableArray alloc]initWithCapacity:0];//存储overs
             [btnLeft setBackgroundImage:[UIImage imageNamed:@"icon_line"] forState:UIControlStateNormal];
            [collectListView removeFromSuperview];
            btnCollectPoint.hidden = YES;
            btnSearch.hidden = YES;
            [_positionInfoView removeFromSuperview];
            [self makeCollectLineView];
            break;
        }
        case 2:
        {
            NSLog(@"Left C");
            if (timer !=nil) {
                [timer invalidate];
                timer = nil;
            }
            [self.mMapView removeOverlays:overLays];
             [btnLeft setBackgroundImage:[UIImage imageNamed:@"icon_touch"] forState:UIControlStateNormal];
            [self clearCollectLineView];
            [_positionInfoView removeFromSuperview];//移除位置信息视图
            btnCollectPoint.hidden = YES;
            btnSearch.hidden = NO;
            [collectListView removeFromSuperview];
            selcetMode = @"longPress";
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"islongFirst"] intValue] == 0)
            {
                [self addLongPressTipView];
            }
           
            ;break;
        }
        default:
            break;
    }
}
//采线视图
- (void)makeCollectLineView
{
    locationArray = [[NSMutableArray alloc]initWithCapacity:0];
    locationOriginalArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    lineInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 44 - 64, WIDTH, 44)];
    lineInfoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineInfoView];
    //跳动的红点
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 11, 20, 20)];
    iv.tag = 100;
    iv.image = [UIImage imageNamed:@"img_dot_shan"];
    [lineInfoView addSubview:iv];
    lineInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 2, self.view.frame.size.width-40, 40)];
    lineInfoLabel.font = [UIFont systemFontOfSize:12.0f];
    lineInfoLabel.backgroundColor = [UIColor clearColor];
    lineInfoLabel.text = @"已采集点0个,已采集路线0.0km";
    lineInfoLabel.textAlignment = NSTextAlignmentLeft;
    lineInfoLabel.userInteractionEnabled = YES;
    [lineInfoView addSubview:lineInfoLabel];
    //开始暂停按钮
    UIButton *beginAndStop = [UIButton buttonWithType:UIButtonTypeCustom];
    beginAndStop.frame = CGRectMake(WIDTH - 40, 10, 24, 24);
    [beginAndStop setBackgroundImage:[UIImage imageNamed:@"img_zt_down"] forState:UIControlStateNormal];
    [beginAndStop addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    beginAndStop.tag = 105;
    [lineInfoView addSubview:beginAndStop];
    
    //采点按钮
    collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(WIDTH - 50 - 10, self.view.bounds.size.height - 64 - 173, 100/2, 102/2);
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"btn_cd"] forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"btn_cd_down"] forState:UIControlStateHighlighted];
    [collectionBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.tag = 106;
    [self.view addSubview:collectionBtn];
    //拍照按钮
  
    btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPhoto.frame = CGRectMake(WIDTH - 60, collectionBtn.frame.origin.y + collectionBtn.frame.size.height + 10, 100/2, 102/2);
    [btnPhoto setBackgroundImage:[UIImage imageNamed:@"img_photo"] forState:UIControlStateNormal];
    [btnPhoto setBackgroundImage:[UIImage imageNamed:@"img_photo_down"] forState:UIControlStateHighlighted];
    [btnPhoto addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnPhoto.tag = 107;
    [self.view addSubview:btnPhoto];
    //终止按钮
    
    btnStop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStop.frame = CGRectMake(WIDTH - 60, btnPhoto.frame.origin.y + btnPhoto.frame.size.height + 10, 100/2, 102/2);
    [btnStop setBackgroundImage:[UIImage imageNamed:@"img_over"] forState:UIControlStateNormal];
    [btnStop setBackgroundImage:[UIImage imageNamed:@"img_over_down"] forState:UIControlStateHighlighted];
    [btnStop addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnStop.tag = 108;
    [self.view addSubview:btnStop];
    
    
    mengBanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    mengBanView.backgroundColor = [UIColor whiteColor];
    mengBanView.alpha = 0.5;
   
    UIButton *  btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStart.frame = CGRectMake((WIDTH - 93)/2, (HEIGHT - 95)/2, 93, 95);
    [btnStart setBackgroundImage:[UIImage imageNamed:@"img_cx_begin"] forState:UIControlStateNormal];
    [btnStart addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnStart.tag = 109;
    [mengBanView addSubview:btnStart];
    [self.view.window addSubview:mengBanView];
    
}
//定时器方法
-(void)timerAction
{
    static BOOL isFirst = YES;
    UIImageView *iv = (UIImageView *)[self.view viewWithTag:100];
    
    if(isFirst)
    {
        iv.frame = CGRectZero;
    }
    else
    {
        iv.frame = CGRectMake(20, 12, 20, 20);
    }
    isFirst = !isFirst;
}

-(void)addLongPressTipView
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    imageView.image = [UIImage imageNamed:@"longPressGray"];
    [self.view.window addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
    tapOne.numberOfTapsRequired = 1;
    tapOne.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:tapOne];
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:@"islongFirst"];
    [userDef synchronize];
}
- (void)tapEvent:(UITapGestureRecognizer *)gesture
{
    [gesture.view removeFromSuperview];
}
#pragma mark -SearchResultDelegate的代理方法

-(void)searchResultView:(SearchResultViewController *)searchView poiInfo:(BMKPoiInfo *)poiInfo
{
    NSLog(@"search result %@ %@ %f %f",poiInfo.name,poiInfo.address,poiInfo.pt.latitude,poiInfo.pt.longitude);
    //此处添加mark
    //code ....
    self.mPoiInfo = poiInfo;
    _annotation = nil;
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.coordinate = poiInfo.pt;
    [self.mMapView addAnnotation:_annotation];
    [self.mMapView setCenterCoordinate:poiInfo.pt];
    baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
    NSArray *arr =[btw BD09ToWGS84With:poiInfo.pt.longitude and:poiInfo.pt.latitude];
    CLLocationCoordinate2D goalCoordiante = CLLocationCoordinate2DMake([[arr objectAtIndex:0] doubleValue], [[arr objectAtIndex:1] doubleValue]);
    
    NSNumber * ptxNumber = [NSNumber numberWithDouble:goalCoordiante.longitude];
    NSNumber * ptyNumber = [NSNumber numberWithDouble:goalCoordiante.latitude];
    [[NSUserDefaults standardUserDefaults]setObject:ptxNumber forKey:@"ptx"];
    [[NSUserDefaults standardUserDefaults]setObject:ptyNumber forKey:@"pty"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
#pragma mark -SearchViewDelegate的代理方法
- (void)searchView:(SearchView *)search text:(NSString *)text
{
    if (text !=nil && ![text isEqualToString:@""]) {
        _search = [[BMKSearch alloc]init];
        _search.delegate = self;
        [_search poiSearchInCity:@"北京" withKey:text pageIndex:0];
    }
    else
    {
        [[iToast makeText:@"请输入关键字"]show];
    }
}
#pragma mark - BMKSearchDelegate的代理方法

- (void)onGetAddrResult:(BMKSearch*)searcher result:(BMKAddrInfo *)result errorCode:(int)error
{
    NSLog(@"strAddress is %@",result.strAddr);
    _positionInfoView.label.text = [NSString stringWithFormat:@"参考位置:%@",result.strAddr];
    
}
- (void)onGetPoiResult:(BMKSearch *)searcher result:(NSArray *)poiResultList searchType:(int)type errorCode:(int)error
{
    NSLog(@"poiResultList is %@",poiResultList);
    
    BMKPoiResult * result = [poiResultList objectAtIndex:0];
    NSLog(@"result is %@",result.poiInfoList);
    NSArray * array = [[NSArray alloc]initWithArray:result.poiInfoList];
    if (array.count >0) {
        SearchResultViewController * searchResultView = [[SearchResultViewController alloc]initWithData:array];
        searchResultView.mDelegate = self;
        [self.navigationController pushViewController:searchResultView animated:YES];
        [self removeSearchView];
    }
    else
    {
         [[iToast makeText:@"没有搜索结果"]show];
    }
}


#pragma mark -MenuListViewDelegate的代理方法
-(void)menuSelect:(MenuListView *)menuListView andIndexPathRow:(NSInteger)row
{
    switch (row) {
        case 0:
        {
            NSLog(@"Right A");
            
            [_menuListView removeFromSuperview];
            UserManageViewController * userMag  = [[UserManageViewController alloc]init];
            [self.navigationController pushViewController:userMag animated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"Right B");
            [_menuListView removeFromSuperview];
            OfflineViewController * offlineView= [[OfflineViewController alloc]init];
            [self.navigationController pushViewController:offlineView animated:YES];
            
            break;
        }
        case 2:
        {
            NSLog(@"Right C");
            
            [_menuListView removeFromSuperview];
            AboutSystemViewController * aboutView = [[AboutSystemViewController alloc]init];
            [self.navigationController pushViewController:aboutView animated:YES];
            break;
        }
        default:
            break;
    }
}
-(void)makeSearchView
{
    SearchView * searchView = [[SearchView alloc]initWithFrame:CGRectMake(btnSearch.frame.origin.x + 48, btnSearch.frame.origin.y + 48, 0, 0)];
    searchView.frame = CGRectMake(10, btnSearch.frame.origin.y + 48, WIDTH - 20, 80);
    searchView.transform = CGAffineTransformMakeScale(0, 0);
    searchView.userInteractionEnabled = YES;
    searchView.delegate = self;
    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg"]];
     searchView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:searchView];
   
    searchView.tag = 300;
    [UIView animateWithDuration:0.35 animations:^{
        //searchView.frame = CGRectMake(10, btnSearch.frame.origin.y + 48, WIDTH - 20, 80);
        searchView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_close_down"] forState:UIControlStateHighlighted];
    }];
}
-(void)removeSearchView
{
    UIView * view = [self.view viewWithTag:300];
    [UIView animateWithDuration:0.35 animations:^{
        //view.frame = CGRectMake(btnSearch.frame.origin.x + 48, btnSearch.frame.origin.y + 48, 0, 0);
         view.transform = CGAffineTransformMakeScale(0, 0);
    }completion:^(BOOL finished) {
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
        [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search_down"] forState:UIControlStateHighlighted];
        [view removeFromSuperview];
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 100:
        {
            [self makeLeftListView];
            break;
        }
        case 101:
            [self makeRightListView];
            break;
        case 102:
            NSLog(@"heihei");
            [self makePostionInfoView];
            [self reverseCoordinate:self.mMapView.userLocation.coordinate];
            [self addAnnotation];
            break;
        case 103:
        {
            NSLog(@"hhhha");
            TaskViewController * taskView =[[TaskViewController alloc]init];
            [self.navigationController pushViewController:taskView animated:YES];
            break;
        }
        case 104:
        {
            NSLog(@"huhuhu");
            UIView * view = [self.view viewWithTag:300];
            if (view)
            {
                [self removeSearchView];
            }
            else
            {
                 [self makeSearchView];
            }
            break;
        }
        case 105:
        {
            //暂停
            if(flag % 2 == 0)
            {
                NSLog(@"flagA is %d",flag/2);
                [sender setBackgroundImage:[UIImage imageNamed:@"img_begin_down"] forState:UIControlStateNormal];
                selcetMode = @"";
//                self.mMapView.showsUserLocation = NO;
//                self.mMapView.delegate = nil;
                //self.rightBtn.frame = CGRectMake(0, 0, 0, 0);
            }
            else
            {
                NSLog(@"flagB is %d",flag/2);
                 [sender setBackgroundImage:[UIImage imageNamed:@"img_zt_down"] forState:UIControlStateNormal];
                selcetMode = @"line";
//                self.mMapView.showsUserLocation = YES;
//                self.mMapView.delegate = self;
                //self.rightBtn.frame = CGRectMake(0, 0, 40, 40);
            }
            flag++;
        }
            break;
        case 106:
        {
            AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDel.isLinePoint = YES;
            UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"位置信息采集成功" delegate:self cancelButtonTitle:@"无采集任务" otherButtonTitles:@"选择任务", nil];
            [alertView show];
        }
            break;
        case 107:
            
            break;
        case 108://终止采线
        {
            //路线采集结束
            self.mMapView.showsUserLocation = YES;
            selcetMode = @"point";
            if([locationArray count])
            {
                double distance = [self getDistance:CLLocationCoordinate2DMake([[locationArray objectAtIndex:0] doubleValue], [[locationArray objectAtIndex:1] doubleValue]) and:CLLocationCoordinate2DMake([[locationArray objectAtIndex:[locationArray count]-2] doubleValue], [[locationArray objectAtIndex:[locationArray count]-1] doubleValue])];
                
                [locationArray addObject:[NSString  stringWithFormat:@"%.6f",distance]];
                //任务列表
                AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDel.isSelect = YES;
                appDel.collectType = @"line";
                NewTaskViewController * taskList = [[NewTaskViewController alloc]init];
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
                taskList.titleLabel.text = @"选择任务";
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSLog(@"pointArray is %@",pointArray);
                [ud setObject:pointArray forKey:@"locationArray"];
                [ud synchronize];
                
                [self.navigationController pushViewController:taskList animated:YES];
            }
            else
            {
                //未定位到
                UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无定位信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }

        }
            break;
            case 109:
        {
            selcetMode = @"line";
            //定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            
            [mengBanView removeFromSuperview];
        }
        default:
            break;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initView];
    
//   [self makeIndexView];
}
-(void)viewDidAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"mainisFirst"] intValue]==0)
    {
        [self addMainTipImage];
    }
}
//提示方法二
- (void)addMainTipImage
{
    NSLog(@"添加主页提示");
    self.mTipImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.mTipImage.image = [UIImage imageNamed:@"img_yindao_1"];
    self.mTipImage.userInteractionEnabled = YES;
    [self.view.window addSubview:self.mTipImage];
    [self.view.window bringSubviewToFront:self.mTipImage];
    
    UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchEvent:)];
    tapOne.numberOfTapsRequired = 1;
    tapOne.numberOfTouchesRequired = 1;
    [self.mTipImage addGestureRecognizer:tapOne];
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:[NSNumber numberWithBool:YES] forKey:@"mainisFirst"];
    [userDef synchronize];
}
- (void)touchEvent:(UITapGestureRecognizer *)gesture
{
    static int index = 0;
    NSArray * array = @[@"img_yindao_2",@"img_yindao_3"];
    if (index <2) {
        self.mTipImage.image = [UIImage imageNamed:[array objectAtIndex:index]];
    }
    if (index == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mTipImage removeFromSuperview];
        });
    }
    index++;
}
//提示方法一
-(void)makeIndexView
{
    NSUserDefaults * userData = [NSUserDefaults standardUserDefaults];
    if (![userData objectForKey:@"isMainFirst"])
    {
        self.navigationController.navigationBarHidden = YES;
        _lyhIndexScrollView = [[UIScrollView alloc]init];
        _lyhIndexScrollView.backgroundColor = [UIColor clearColor];
        _lyhIndexScrollView.frame = CGRectMake(0, 0,WIDTH , HEIGHT);
        _lyhIndexScrollView.contentSize = CGSizeMake(WIDTH*2, HEIGHT);
        _lyhIndexScrollView.pagingEnabled= YES;
        _lyhIndexScrollView.bounces = NO;
        _lyhIndexScrollView.delegate= self;
        [self.view addSubview:_lyhIndexScrollView];
        [self.view bringSubviewToFront:_lyhIndexScrollView];
        _lyhPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100, HEIGHT-100, 120, 30)];
        _lyhPageControl.backgroundColor = [UIColor clearColor];
        _lyhPageControl.userInteractionEnabled = NO;
        _lyhPageControl.numberOfPages = 2;
        [self.view addSubview:_lyhPageControl];
        _lyhPageControl.currentPage = 0;
        NSArray * array = @[@"indexMain1.jpg",@"indexMain2.jpg"];
        int i;
        for(i=0;i<2;i++)
        {
            UIImageView *view = [[UIImageView alloc] init];
            view.frame = CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT);
            view.image = [UIImage imageNamed:[array objectAtIndex:i]];
            view.backgroundColor = [UIColor blueColor];
            [_lyhIndexScrollView addSubview:view];
        }
        NSNumber * number = [[NSNumber alloc]initWithBool:YES];
        [userData setObject:number forKey:@"isMainFirst"];
        [userData synchronize];
    }
}


#pragma mark Srollview的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x/320;
    //显示当前页
    _lyhPageControl.currentPage = x;
    if(x == 1)
    {
        self.navigationController.navigationBarHidden = NO;
        [UIView animateWithDuration:1 animations:^{
            _lyhIndexScrollView.alpha = 0;
        } completion:^(BOOL finished) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isFirst"];
            [userDefaults synchronize];
            NSLog(@"...移除引导页...");
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_lyhIndexScrollView removeFromSuperview];
                [_lyhPageControl removeFromSuperview];
                _lyhPageControl = nil;
                _lyhIndexScrollView = nil;
            });
        }];
    }
}
-(void)initView
{
    self.mMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    self.mMapView.delegate = self;
    self.mMapView.zoomLevel = 15;
    self.mMapView.showsUserLocation = YES;
    [self.view addSubview:self.mMapView];
    if ([SYSTEMVERSION characterAtIndex:0] > '7') {
        CLLocationManager * locationMg = [[CLLocationManager alloc]init];
        [locationMg setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//        self.mMapView.showsUserLocation = YES;
    }
    btnCollectPoint = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCollectPoint.frame = CGRectMake(310 - 50, self.view.bounds.size.height - 64 - 60, 100/2, 102/2);
    [btnCollectPoint setBackgroundImage:[UIImage imageNamed:@"btn_cd"] forState:UIControlStateNormal];
    [btnCollectPoint setBackgroundImage:[UIImage imageNamed:@"btn_cd_down"] forState:UIControlStateHighlighted];
    [btnCollectPoint addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnCollectPoint.tag = 102;
    [self.view addSubview:btnCollectPoint];
    
    UIButton * btnTask = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTask.frame = CGRectMake(310 - 48, 10, 96/2, 96/2);
    [btnTask setBackgroundImage:[UIImage imageNamed:@"btn_tasks"] forState:UIControlStateNormal];
    [btnTask setBackgroundImage:[UIImage imageNamed:@"btn_tasks_down"] forState:UIControlStateHighlighted];
    [btnTask addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnTask.tag = 103;
    [self.view addSubview:btnTask];
    
    btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(310 - 48, 68, 96/2, 96/2);
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [btnSearch setBackgroundImage:[UIImage imageNamed:@"btn_search_down"] forState:UIControlStateHighlighted];
    [btnSearch addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.tag = 104;
    [self.view addSubview:btnSearch];
    selcetMode = @"point";
    [self.view.window bringSubviewToFront:self.mTipImage];
   
}
#pragma mark - BMKMapViewDelegate的代理方法
-(void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"添加了 %@",views);
    self.mMapView.showsUserLocation = NO;
    [self makePostionInfoView];
}
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    if ([selcetMode isEqualToString:@"longPress"])
    {
        touchPoint = coordinate;
        [self.mMapView removeAnnotation:_annotation];
        [_positionInfoView removeFromSuperview];
        [self reverseCoordinate:coordinate];
        _annotation = nil;
        _annotation = [[BMKPointAnnotation alloc] init];
        _annotation.coordinate = coordinate;
        [self.mMapView addAnnotation:_annotation];
        [self.mMapView setCenterCoordinate:coordinate];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView * pinView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        pinView.pinColor = BMKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        return pinView;
    }
    return nil;
}
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    
    
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 3.0;
        return cutomView;
    }
    self.mMapView.showsUserLocation = YES;
    
    return nil;
    
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    static BOOL isFirst = YES;
    if (isFirst) {
        [self.mMapView setCenterCoordinate:userLocation.coordinate animated:YES];
        NSLog(@"userLocation is %@",userLocation.title);
        isFirst =!isFirst;
    }
    if ([selcetMode isEqualToString:@"line"]) {
        //static int count = 0;
        if (userLocation != nil)
        {
            
           // count++;
            
            //在定位到的我的位置添加一个大头针
//            BMKUserLocation *userLocation = mapView.userLocation;
//            userLocation.title = @"我的位置";
//            [mapView addAnnotation:userLocation];
//            [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
            
            BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
            param.isAccuracyCircleShow = NO;
            //        param.locationViewImgName = @"";
            //        param.isRotateAngleValid = YES;
            //        param.locationViewOffsetX = 0;
            //        param.locationViewOffsetY = 0;
            
            [mapView updateLocationViewWithParam:param];
            
            
            
            NSLog(@"定位：%.6f %.6f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
            [mapView setCenterCoordinate:userLocation.coordinate];
            mapView.showsUserLocation = NO;
            
            baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
            NSArray *arr =[btw BD09ToWGS84With:mapView.centerCoordinate.longitude and:mapView.centerCoordinate.latitude];
            CLLocationCoordinate2D new = CLLocationCoordinate2DMake([[arr objectAtIndex:0] doubleValue], [[arr objectAtIndex:1] doubleValue]);
            NSLog(@"NEW:%.6f,%.6f",new.latitude,new.longitude);
            
            [locationArray addObject:[NSString stringWithFormat:@"%.6f",new.latitude]];
            [locationArray addObject:[NSString stringWithFormat:@"%.6f",new.longitude]];
            
            NSString * latAndlon = [NSString stringWithFormat:@"%lf,%lf",new.latitude,new.longitude];
            [pointArray addObject:latAndlon];
            
            //计算采线长度,
            if (pointArray.count > 2) {
                NSString * original = [pointArray objectAtIndex:pointArray.count - 2];
                NSString * end = [pointArray objectAtIndex:pointArray.count - 1];
                NSArray * originalArray = [original componentsSeparatedByString:@","];
                NSArray * endArray = [end componentsSeparatedByString:@","];
                CLLocation * originalLocation = [[CLLocation alloc]initWithLatitude:[[originalArray objectAtIndex:0] doubleValue] longitude:[[originalArray objectAtIndex:1] doubleValue]];
                CLLocation * endLocation = [[CLLocation alloc]initWithLatitude:[[endArray objectAtIndex:0] doubleValue] longitude:[[endArray objectAtIndex:1] doubleValue]];
                double distance = [originalLocation distanceFromLocation:endLocation];
                myDistance += distance;
                NSLog(@"distance is %f",myDistance);
            }
            AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            lineInfoLabel.text = [NSString stringWithFormat:@"已采集点%d个,已采集路线%.1fkm",appDel.dropSaveCount,myDistance/1000];
            [locationOriginalArray addObject:[NSDecimalNumber numberWithDouble:userLocation.coordinate.latitude]];
            [locationOriginalArray addObject:[NSDecimalNumber numberWithDouble:userLocation.coordinate.longitude]];
            
            [self performSelector:@selector(timeDelayAction) withObject:nil afterDelay:2.0];
        }
    }
}
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
    
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

-(double)getDistance:(CLLocationCoordinate2D)first and:(CLLocationCoordinate2D)second
{
    
	//地球半径
	double r = 6378137; //米
	//经度
	double lat1 = first.longitude * M_PI/180;
	double lat2 = second.longitude * M_PI/180;
	double a = lat1 - lat2;
	double b = (first.latitude - second.latitude)*M_PI/180;
	double sa2 = sin(a/2);
	double sb2 = sin(b/2);
	double distance = 2*r*asin(sqrt(sa2*sa2 + cos(lat1)*cos(lat2)*sb2*sb2));
    NSLog(@"distance:%.14f",distance);
	return distance;
    
}

-(void)timeDelayAction
{
    
    self.mMapView.showsUserLocation = YES;
    [self timeDelay];
    
}
-(void)timeDelay
{
    
    if([locationOriginalArray count]>=4)
    {
        
        for(int i = 0;i<[locationArray count]-4;i = i+2)
        {
            dispatch_async(dispatch_get_current_queue(), ^{
                CLLocationCoordinate2D coor1 = CLLocationCoordinate2DMake([[locationOriginalArray objectAtIndex:i] doubleValue], [[locationOriginalArray objectAtIndex:i+1] doubleValue]);
                BMKMapPoint pt1 = BMKMapPointForCoordinate(coor1);
                
                CLLocationCoordinate2D coor2 = CLLocationCoordinate2DMake([[locationOriginalArray objectAtIndex:i+2] doubleValue], [[locationOriginalArray objectAtIndex:i+3] doubleValue]);
                BMKMapPoint pt2 = BMKMapPointForCoordinate(coor2);
                
                BMKMapPoint temppoints[] = {0,0};
                temppoints[0].x = pt2.x;
                temppoints[0].y = pt2.y;
                temppoints[1].x = pt1.x;
                temppoints[1].y = pt1.y;
                CustomOverlay* custom = [[CustomOverlay alloc] initWithPoints:temppoints count:2];
                [overLays addObject:custom];
                [self.mMapView addOverlay:custom];
            });
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
