//
//  OfflineCityViewController.m
//  路网采集
//
//  Created by Charles Leo on 14-10-15.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "OfflineCityViewController.h"
#import "BMapKit.h"
#import "OfflineCell.h"
@interface OfflineCityViewController ()<BMKMapViewDelegate,BMKOfflineMapDelegate,UITableViewDataSource,UITableViewDelegate,OfflineCellDelegate>
{
    BMKMapView * _mapView;
    BMKOfflineMap * _offlineMap;
    NSMutableArray * _arrayOfflineCityData;
}
@property (strong,nonatomic) OfflineCell * myCell;
@end

@implementation OfflineCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    _mapView.delegate = self;
    _offlineMap.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _offlineMap.delegate = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initView];
}
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.leftBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"离线地图下载";
    
    UITableView * tablView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    tablView.delegate = self;
    tablView.dataSource = self;
    [self.view addSubview:tablView];
    
    
    _offlineMap = [[BMKOfflineMap alloc]init];

    NSArray* city = [_offlineMap searchCity:@"江西省"];
    NSLog(@"city is %@",city);
    if (city.count > 0) {
        BMKOLSearchRecord* oneCity = [city objectAtIndex:0];
        NSString * cityName = [NSString stringWithFormat:@"%@", oneCity.cityName];
        NSLog(@"cityName is %@",cityName);
        NSLog(@"city is %@",oneCity.childCities);
        _arrayOfflineCityData =[NSMutableArray arrayWithArray:oneCity.childCities];
        //[_arrayOfflineCityData removeObjectAtIndex:0];
        if (_arrayOfflineCityData.count > 0) {
            for ( int i= 0; i<_arrayOfflineCityData.count; i++) {
                BMKOLSearchRecord* oneCity = [_arrayOfflineCityData objectAtIndex:i];
                NSString * cityName = [NSString stringWithFormat:@"%@", oneCity.cityName];
                NSLog(@"cityName is %@ %d %d %d",cityName,oneCity.size,oneCity.cityType,oneCity.cityID);
                //NSLog(@"city is %@",oneCity.childCities)
            }
        }
    }
}

#pragma mark - UITableViewDelegate的代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayOfflineCityData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"ID";
    OfflineCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == Nil) {
        cell = [[OfflineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    BMKOLSearchRecord * record = [_arrayOfflineCityData objectAtIndex:indexPath.row];
    NSString * key = [NSString stringWithFormat:@"%d",record.cityID];
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSString * localmapid = [userDef objectForKey:key];
    if (localmapid !=nil) {
        [cell.btnDownLoad setBackgroundImage:[UIImage imageNamed:@"img_downmap_2"] forState:UIControlStateNormal];
        cell.mRadio.text = @"下载完成";
    }
    cell.cityName.text = record.cityName;
    cell.cityId =[NSString stringWithFormat:@"%d",record.cityID];
    CGFloat size = (CGFloat)record.size;
    cell.dataSize.text =[NSString stringWithFormat:@"%.1fM",size / (1024*1024)];
    return  cell;
}
#pragma mark -OfflineCellDelegate的代理方法
- (void)downLoadOfflineMap:(OfflineCell *)cell
{
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    NSString * localmapid = [userDef objectForKey:cell.cityId];
    if (localmapid!=nil) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已下载" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        self.myCell = cell;
//        [NSThread detachNewThreadSelector:@selector(threadMethod:) toTarget:self withObject:nil];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSLog(@"开始下载了哈哈");
            cell.mRadio.text = @"准备下载";
            [_offlineMap start:[cell.cityId floatValue]];
        });
    }
}
- (void)threadMethod:(OfflineCell *)cell
{
    NSLog(@"%@",cell.cityName);
    
}
#pragma mark -

- (void)onGetOfflineMapState:(int)type withState:(int)state
{
    
    if (type == TYPE_OFFLINE_UPDATE) {
        //id为state的城市正在下载或更新，start后会毁掉此类型
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"城市名：%@,下载比例:%d",updateInfo.cityName,updateInfo.ratio);
        NSString * radio = [NSString stringWithFormat:@"已下载:%d%%",updateInfo.ratio];
       
        self.myCell.mRadio.text = radio;
//        [self.myCell.mRadio.text stringByAppendingString:@"%"];
        if (updateInfo.ratio == 100)
        {
            [self.myCell.btnDownLoad setBackgroundImage:[UIImage imageNamed:@"img_downmap_2"] forState:UIControlStateNormal];
            self.myCell.mRadio.text = @"下载完成";
            NSString * cityID = [NSString stringWithFormat:@"%d",updateInfo.cityID];
            [[NSUserDefaults standardUserDefaults]setObject:cityID forKey:cityID];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    if (type == TYPE_OFFLINE_NEWVER) {
        //id为state的state城市有新版本,可调用update接口进行更新
        BMKOLUpdateElement* updateInfo;
        updateInfo = [_offlineMap getUpdateInfo:state];
        NSLog(@"是否有更新%d",updateInfo.update);
    }
    if (type == TYPE_OFFLINE_UNZIP) {
        //正在解压第state个离线包，导入时会回调此类型
    }
    if (type == TYPE_OFFLINE_ZIPCNT) {
        //检测到state个离线包，开始导入时会回调此类型
        NSLog(@"检测到%d个离线包",state);
        if(state==0)
        {
            //[self showImportMesg:state];
        }
    }
    if (type == TYPE_OFFLINE_ERRZIP) {
        //有state个错误包，导入完成后会回调此类型
        NSLog(@"有%d个离线包导入错误",state);
    }
    if (type == TYPE_OFFLINE_UNZIPFINISH) {
        NSLog(@"成功导入%d个离线包",state);
        //导入成功state个离线包，导入成功后会回调此类型
       // [self showImportMesg:state];
    }
    
}

- (void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
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
