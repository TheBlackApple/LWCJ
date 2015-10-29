//
//  SearchResultViewController.h
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BMapKit.h"
@class SearchResultViewController;
@protocol SearchResultDelegate <NSObject>

-(void)searchResultView:(SearchResultViewController *)searchView poiInfo:(BMKPoiInfo*)poiInfo;

@end
@interface SearchResultViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView * tableView;
@property (strong,nonatomic) NSArray * dataArray;
@property (assign,nonatomic) id <SearchResultDelegate> mDelegate;
-(id)initWithData:(NSArray *)data;
@end
