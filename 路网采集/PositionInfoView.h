//
//  PositionInfoView.h
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PositionInfoView;
@protocol PositionInfoViewDelegate <NSObject>

-(void)positionChecked:(PositionInfoView *)positionView;

@end
@interface PositionInfoView : UIView
@property (strong,nonatomic) NSString * mAddress;
@property (assign,nonatomic) id <PositionInfoViewDelegate> delegate;
@property (strong,nonatomic) UILabel * label;
//-(id)initWithAddress:(NSString *)address;
@end
