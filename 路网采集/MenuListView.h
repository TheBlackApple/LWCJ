//
//  MenuListView.h
//  路网采集
//
//  Created by Charles Leo on 14-10-14.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuListView;
@protocol MenuListViewDelegate <NSObject>

- (void)menuSelect:(MenuListView *)menuListView andIndexPathRow:(NSInteger) row;
@end
@interface MenuListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic) id <MenuListViewDelegate> delegate;
@end
