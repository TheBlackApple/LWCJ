//
//  SearchResultViewController.m
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCell.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController


- (id)initWithData:(NSArray *)data
{
    if (self = [super init]) {
        self.dataArray = [[NSArray alloc]initWithArray:data];
        for (int i=0; i<self.dataArray.count; i++) {
             BMKPoiInfo * poiInfo = [self.dataArray objectAtIndex:i];
            NSLog(@"inf %@ %@",poiInfo.name,poiInfo.address);
        }
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}
-(void)initView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT  -64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.titleLabel.text = @"搜索列表";
    [self.leftBtn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BMKPoiInfo * poiInfo =[self.dataArray objectAtIndex:indexPath.row];
    NSLog(@"info is %f %f",poiInfo.pt.latitude,poiInfo.pt.longitude);
    cell.mReferenceLabel.text = [NSString stringWithFormat:@"%d.参考位置:%@",indexPath.row + 1,poiInfo.name];
    cell.mPositionInfo.text = [NSString stringWithFormat:@"位置信息:%@",poiInfo.address];
    cell.mPoiInfo = poiInfo;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultCell * cell = (SearchResultCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.mCheckedImage.hidden = NO;
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self.mDelegate respondsToSelector:@selector(searchResultView:poiInfo:)]) {
            [self.mDelegate searchResultView:self poiInfo:cell.mPoiInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
    });
}


@end
