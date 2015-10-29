//
//  OfflineCell.h
//  路网采集
//
//  Created by Charles Leo on 14-10-15.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OfflineCell;
@protocol OfflineCellDelegate <NSObject>

-(void)downLoadOfflineMap:(OfflineCell *) cell;

@end
@interface OfflineCell : UITableViewCell
@property (assign,nonatomic) id <OfflineCellDelegate> delegate;
@property (strong,nonatomic) UILabel * cityName;
@property (strong,nonatomic) UILabel * dataSize;
@property (strong,nonatomic) UIButton * btnDownLoad;
@property (strong,nonatomic) NSString * cityId;
@property (strong,nonatomic) UILabel * mRadio;

@end
