//
//  CollectListView.h
//  路网采集
//
//  Created by Charles Leo on 14-10-14.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectListView;
@protocol CollectListViewDelegate <NSObject>

- (void)modeSelect:(CollectListView *)collectListView andIndexPathRow:(NSInteger) row;

@end
@interface CollectListView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (assign,nonatomic) id <CollectListViewDelegate> delegate;
@end
