//
//  StructureCollectionViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "StructureCollectionViewController.h"
#import "EditMessageViewController.h"
#import "BMKGroundOverlay.h"
#import "AppDelegate.h"
#import "Base64.h"
#import "ASIHTTPRequest.h"
#import "baiduToWGS84.h"
#import <stdio.h>



@interface StructureCollectionViewController ()

@end

@implementation StructureCollectionViewController

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
    
    self.titleLabel.text = @"构造物采集";
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"结束" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.rotation = 90;
    //mapView.overlooking = -30;
    mapView.zoomLevel = 19;
    mapView.showsUserLocation = NO;
    mapView.userTrackingMode = BMKUserTrackingModeNone;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];

    
    
//    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
//    label.backgroundColor = [UIColor yellowColor];
//    label.text = [NSString stringWithFormat:@"正在采点：已采集点%d个", del.dropSaveCount];
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//    
//    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 64+10, 20, 20)];
//    iv.tag = 100;
//    iv.image = [UIImage imageNamed:@"用户管理蓝"];
//    [self.view addSubview:iv];
    
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-120, 34, 34);
    [collectionBtn setImage:[UIImage imageNamed:@"采点"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"采点选中"] forState:UIControlStateHighlighted];
    [collectionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.tag = 10;
    [self.view addSubview:collectionBtn];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(self.view.frame.size.width-50, self.view.frame.size.height-70, 34, 34);
    [locationBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"定位选中"] forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.tag = 11;
    [self.view addSubview:locationBtn];
}
//-(void)timerAction
//{
//    
//    static BOOL isFirst = YES;
//    UIImageView *iv = (UIImageView *)[self.view viewWithTag:100];
//
//    if(isFirst)
//    {
//        iv.frame = CGRectZero;
//    }
//    else
//    {
//        iv.frame = CGRectMake(20, 64+10, 20, 20);
//    }
//    
//    isFirst = !isFirst;
//    
//}
-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:
        {
            //结束:采线结束
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
            
        case 10:
        {
            //采点
            EditMessageViewController *emvc = [[EditMessageViewController alloc]init];
            emvc.contentStr = @"点状数据";
            
            //坐标转换
            baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
            NSArray *arr =[btw BD09ToWGS84With:mapView.centerCoordinate.longitude and:mapView.centerCoordinate.latitude];
            CLLocationCoordinate2D new = CLLocationCoordinate2DMake([[arr objectAtIndex:0] doubleValue], [[arr objectAtIndex:1] doubleValue]);
            NSLog(@"NEW:%.14f,%.14f",new.latitude,new.longitude);;
            NSArray *arr0 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",new.latitude],[NSString stringWithFormat:@"%f",new.longitude], nil];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:arr0 forKey:@"locationArray"];
            [ud setValue:nil forKey:@"cjsj"];
            [ud synchronize];
            
            emvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:emvc animated:YES];
            emvc.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 11:
        {
            //定位
        }
            break;
            
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    [timer invalidate];
    timer = nil;
    
}
/*在地图View将要启动定位时，会调用此函数*/
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/*用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */

- (void)mapView:(BMKMapView *)mapView0 didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil)
    {
		NSLog(@"定位：%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);        

        [mapView0 setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
    }
	
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
