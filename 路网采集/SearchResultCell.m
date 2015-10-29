//
//  SearchResultCell.m
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, (150-51)/2-51/2, 51/2, 51/2)];
        self.mImageView.image = [UIImage imageNamed:@"img_cd_pic"];
        [self.contentView addSubview:self.mImageView];
        self.mReferenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + 51/2 + 10, 5, 220, 30)];
        self.mReferenceLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.mReferenceLabel.backgroundColor = [UIColor clearColor];
        self.mReferenceLabel.numberOfLines = 0;
        self.mReferenceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.mReferenceLabel];
        
        self.mPositionInfo = [[UILabel alloc]initWithFrame:CGRectMake(20 + 51/2 + 10, 35, 200, 35)];
        self.mPositionInfo.lineBreakMode = NSLineBreakByWordWrapping;
        self.mPositionInfo.numberOfLines = 0;
        self.mPositionInfo.font = [UIFont systemFontOfSize:10.0f];
        self.mPositionInfo.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.mPositionInfo];
        
        self.mCheckedImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 20 - 32, (150 - 64)/2 - 32/2-5, 32, 32)];
        
        self.mCheckedImage.image = [UIImage imageNamed:@"img_ok"];
        self.mCheckedImage.hidden = YES;
        [self.contentView addSubview:self.mCheckedImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
