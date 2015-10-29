//
//  RoteCollectionViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "RoteCollectionViewController.h"
#import "EditMessageViewController.h"
#import "baiduToWGS84.h"
#import "BMKPolylineView.h"
#import "CustomOverlayView.h"
#import "CustomOverlay.h"

@interface RoteCollectionViewController ()

@end

@implementation RoteCollectionViewController

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
- (void)viewDidAppear:(BOOL)animated
{
    
}
-(void)initInterface
{

    self.titleLabel.text = @"路线采集";
    //[self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"结束" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    locationArray = [[NSMutableArray alloc]initWithCapacity:0];
    locationOriginalArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    mapView.rotation = 90;
    mapView.overlooking = -30;
    mapView.zoomLevel = 19;
    
    mapView.userTrackingMode = BMKUserTrackingModeFollow;
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    label.backgroundColor = [UIColor blueColor];
    label.text = @"正在采集";
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 64+10, 20, 20)];
    iv.tag = 100;
    iv.image = [UIImage imageNamed:@"用户管理蓝"];
    [self.view addSubview:iv];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(280, 64+10, 40, 20);
    stopBtn.backgroundColor = [UIColor cyanColor];
    [stopBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    stopBtn.tag = 11;
    [self.view addSubview:stopBtn];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(self.view.frame.size.width-50, 400, 34, 34);
    [collectionBtn setImage:[UIImage imageNamed:@"采点"] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage imageNamed:@"采点选中"] forState:UIControlStateHighlighted];
    [collectionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    collectionBtn.tag = 12;
    [self.view addSubview:collectionBtn];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(self.view.frame.size.width-50, 300, 34, 34);
    [locationBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"定位选中"] forState:UIControlStateHighlighted];
    [locationBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    locationBtn.tag = 13;
    [self.view addSubview:locationBtn];

    
    
    UIView *layoutView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    layoutView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:layoutView];
    //开始采集
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(100, 100, 100, 100);
    closeBtn.backgroundColor = [UIColor yellowColor];
    [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = 10;
    [layoutView addSubview:closeBtn];

    
    [self timeDelay];
    
}

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
        iv.frame = CGRectMake(20, 64+10, 20, 20);
    }
    
    isFirst = !isFirst;
    
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
        case 1:
        {
            //路线采集结束
            mapView.showsUserLocation = YES;
            
            if([locationArray count])
            {
                
                double distance = [self getDistance:CLLocationCoordinate2DMake([[locationArray objectAtIndex:0] doubleValue], [[locationArray objectAtIndex:1] doubleValue]) and:CLLocationCoordinate2DMake([[locationArray objectAtIndex:[locationArray count]-2] doubleValue], [[locationArray objectAtIndex:[locationArray count]-1] doubleValue])];
                
                [locationArray addObject:[NSString  stringWithFormat:@"%.6f",distance]];

                EditMessageViewController *emvc = [[EditMessageViewController alloc]init];
                emvc.contentStr = @"线状数据";

                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setValue:locationArray forKey:@"locationArray"];
                [ud setValue:nil forKey:@"cjsj"];
                [ud synchronize];
                
                [self.navigationController pushViewController:emvc animated:YES];
                emvc.hidesBottomBarWhenPushed = NO;
                
                
            }
            else
            {
                //未定位到
                UIAlertView *av =[[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无定位信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
            break;
        case 10:
        {
            //开始采集
            [[self.view.subviews objectAtIndex:self.view.subviews.count-1] removeFromSuperview];
            
        }
            break;
        case 11:
        {
            //暂停
            if(flag == 0)
            {
                btn.backgroundColor = [UIColor redColor];
                self.rightBtn.frame = CGRectMake(0, 0, 0, 0);
            }
            else
            {
                btn.backgroundColor = [UIColor cyanColor];
                self.rightBtn.frame = CGRectMake(0, 0, 40, 40);
            }
            flag = !flag;
            
        }
            break;
        case 12:
        {
            //采点
            EditMessageViewController *emvc = [[EditMessageViewController alloc]init];
            emvc.contentStr = @"点状数据";
            
            baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
            NSArray *arr =[btw BD09ToWGS84With:mapView.centerCoordinate.longitude and:mapView.centerCoordinate.latitude];
            CLLocationCoordinate2D new = CLLocationCoordinate2DMake([[arr objectAtIndex:0] doubleValue], [[arr objectAtIndex:1] doubleValue]);
            NSLog(@"NEW:%.14f,%.14f",new.latitude,new.longitude);;
            NSArray *arr0 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",new.latitude],[NSString stringWithFormat:@"%f",new.longitude], nil];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setValue:arr0 forKey:@"locationArray"];
            [ud synchronize];
            
            emvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:emvc animated:YES];
            emvc.hidesBottomBarWhenPushed = NO;

            
        }
            break;
        case 13:
        {
            //定位
            
        }
            
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    flag = 0;
    
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

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

- (void)mapView:(BMKMapView *)mapView0 didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    static int count = 0;
	if (userLocation != nil)
    {
        
        count++;
        
//        //在定位到的我的位置添加一个大头针
//        BMKUserLocation *userLocation = mapView.userLocation;
//        userLocation.title = @"我的位置";
//        [mapView addAnnotation:userLocation];
        [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
    
        BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc]init];
        param.isAccuracyCircleShow = NO;
//        param.locationViewImgName = @"";
//        param.isRotateAngleValid = YES;
//        param.locationViewOffsetX = 0;
//        param.locationViewOffsetY = 0;
        
        [mapView updateLocationViewWithParam:param];
        
        
        
		NSLog(@"定位：%.6f %.6f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [mapView0 setCenterCoordinate:userLocation.coordinate];
        mapView0.showsUserLocation = NO;
        
        baiduToWGS84 *btw = [[baiduToWGS84 alloc]init];
        NSArray *arr =[btw BD09ToWGS84With:mapView.centerCoordinate.longitude and:mapView.centerCoordinate.latitude];
        CLLocationCoordinate2D new = CLLocationCoordinate2DMake([[arr objectAtIndex:0] doubleValue], [[arr objectAtIndex:1] doubleValue]);
        NSLog(@"NEW:%.6f,%.6f",new.latitude,new.longitude);
        
        
        
        [locationArray addObject:[NSString stringWithFormat:@"%.6f",new.latitude]];
        [locationArray addObject:[NSString stringWithFormat:@"%.6f",new.longitude]];
        
        
        [locationOriginalArray addObject:[NSDecimalNumber numberWithDouble:userLocation.coordinate.latitude]];
        [locationOriginalArray addObject:[NSDecimalNumber numberWithDouble:userLocation.coordinate.longitude]];
        
        
        [self performSelector:@selector(timeDelayAction) withObject:nil afterDelay:2.0];
        
        
    }
	
}

- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView0
{
    NSLog(@"stop locate");
    
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView0 viewForOverlay:(id <BMKOverlay>)overlay
{
    
        
    if ([overlay isKindOfClass:[CustomOverlay class]])
    {
        CustomOverlayView* cutomView = [[CustomOverlayView alloc] initWithOverlay:overlay];
        cutomView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        cutomView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        cutomView.lineWidth = 3.0;
        return cutomView;
        
        
    }
    mapView0.showsUserLocation = YES;
    
    return nil;
    
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
                [mapView addOverlay:custom];
            });
        }
    }
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
    mapView.showsUserLocation = YES;
    [self timeDelay];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
