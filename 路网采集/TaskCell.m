//
//  TaskCell.m
//  路网采集
//
//  Created by Charles Leo on 14-7-25.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell
@synthesize mCodeLabel,mTitleLabel,mZHLabel,mImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeView];
    }
    return self;
}
- (void)makeView
{
    //图标
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,110/2 - 20 , 20, 40)];
    imageView.image = [UIImage imageNamed:@""];
    imageView.backgroundColor = [UIColor grayColor];
    self.mImageView = imageView;
    [self.contentView addSubview:self.mImageView];
    
    //要素名称
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:14.0f];
    title.textColor = [UIColor blackColor];
    self.mTitleLabel = title;
    [self.contentView addSubview:self.mTitleLabel];
    //要素代码
    UILabel * code = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, 200, 30)];
    code.backgroundColor = [UIColor clearColor];
    code.font = [UIFont systemFontOfSize:12.0f];
    code.textColor = [UIColor blackColor];
    self.mCodeLabel = code;
    [self.contentView addSubview:self.mCodeLabel];
    //中心桩号
    UILabel * zhuanghao = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 200, 30)];
    zhuanghao.backgroundColor = [UIColor clearColor];
    zhuanghao.font = [UIFont systemFontOfSize:12.0f];
    zhuanghao.textColor = [UIColor blackColor];
    self.mZHLabel = zhuanghao;
    [self.contentView addSubview:self.mZHLabel];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
