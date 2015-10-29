//
//  SearchResultCell.h
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface SearchResultCell : UITableViewCell
@property (strong,nonatomic) UIImageView * mImageView;
@property (strong,nonatomic) UILabel * mReferenceLabel;
@property (strong,nonatomic) UILabel * mPositionInfo;
@property (strong,nonatomic) UIImageView * mCheckedImage;
@property (strong,nonatomic) BMKPoiInfo * mPoiInfo;
@end
