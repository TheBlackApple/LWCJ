//
//  OfflineCell.m
//  路网采集
//
//  Created by Charles Leo on 14-10-15.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "OfflineCell.h"

@implementation OfflineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initview];
    }
    return self;
}

-(void)initview
{
    self.cityName = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    self.cityName.font = [UIFont boldSystemFontOfSize:15.0f];
    self.cityName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.cityName];
    
    self.mRadio = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 110, 30)];
    self.mRadio.font = [UIFont systemFontOfSize:13.0f];
    self.mRadio.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.mRadio];
    
    self.dataSize = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 20 - 10 - 36 -30, 10, 100, 30)];
    self.dataSize.font = [UIFont systemFontOfSize:13.0f];
    self.dataSize.textColor = [UIColor darkGrayColor];
    self.dataSize.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.dataSize];

    self.btnDownLoad = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDownLoad.frame = CGRectMake(WIDTH - 20 - 36, 7, 36, 36);
    [self.btnDownLoad setBackgroundImage:[UIImage imageNamed:@"img_downmap_3"] forState:UIControlStateNormal];
    [self.btnDownLoad addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnDownLoad];
    
    
}
-(void)buttonClick
{
    NSLog(@"click");
    if ([self.delegate respondsToSelector:@selector(downLoadOfflineMap:)])
    {
         [self.delegate downLoadOfflineMap:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
