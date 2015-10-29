//
//  MyTaskCell.m
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "MyTaskCell.h"

@implementation MyTaskCell
@synthesize mModel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mTypeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,   10, 112/2, 112/2)];
        [self.contentView addSubview:self.mTypeImage];
        
        self.mNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 10, 220, 112/2 / 3)];
        self.mNameLabel.backgroundColor = [UIColor clearColor];
        self.mNameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:self.mNameLabel];
        
        self.mLineNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 10 + 112 /6, 220, 112/2 /3)];
        self.mLineNameLabel.backgroundColor = [UIColor clearColor];
        self.mLineNameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:self.mLineNameLabel];
        
        self.mTime = [[UILabel alloc]initWithFrame:CGRectMake(76, 10 + 112/3, 220, 112/2/3)];
        self.mTime.backgroundColor = [UIColor clearColor];
        self.mTime.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:self.mTime];
        
        self.mBtnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mBtnCollect.frame = CGRectMake(WIDTH - 36 - 5 , 20, 72/2, 72/2);
        [self.mBtnCollect setBackgroundImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        [self.mBtnCollect addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.mBtnCollect];
    }
    return self;
}
- (void)buttonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(myTaskCell:)]) {
        [self.delegate myTaskCell:self];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
