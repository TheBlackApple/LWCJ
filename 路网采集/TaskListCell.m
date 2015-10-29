//
//  TaskListCell.m
//  路网采集
//
//  Created by Charles Leo on 14/10/20.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "TaskListCell.h"

@implementation TaskListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,   10, 112/2, 112/2)];
        [self.contentView addSubview:self.mImageView];
        
        self.mLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 10, 200, 112/2)];
        self.mLabel.backgroundColor = [UIColor clearColor];
        self.mLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.mLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
