//
//  ModeListCell.m
//  路网采集
//
//  Created by Charles Leo on 14-10-14.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "ModeListCell.h"

@implementation ModeListCell
@synthesize mImageView,mLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 64/2, 64/2)];
        [self.contentView addSubview:self.mImageView];
        self.mLabel = [[UILabel alloc]initWithFrame:CGRectMake(5 + 32 + 5, 5, 100, 32)];
        self.mLabel.font = [UIFont systemFontOfSize:13.0f];
        self.mLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.mLabel];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
