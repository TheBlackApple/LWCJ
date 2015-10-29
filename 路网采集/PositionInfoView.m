//
//  PositionInfoView.m
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "PositionInfoView.h"

@implementation PositionInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView
{
    UIImageView * locationImage =[[UIImageView alloc]initWithFrame:CGRectMake(10,(70 - 51/2)/2 , 51/2, 51/2)];
    locationImage.image = [UIImage imageNamed:@"img_cd_pic"];
    [self addSubview:locationImage];
    
     self.label = [[UILabel alloc]initWithFrame:CGRectMake(10 + 51 /2 + 10, 0, 200, 70)];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.text = [NSString stringWithFormat:@"参考位置:%@",self.mAddress];
    [self addSubview:self.label];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.label.frame.origin.x + 200 + 10, 19, 32, 32);
    [button setBackgroundImage: [UIImage imageNamed:@"img_ok"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)buttonClick
{
    if ([self.delegate respondsToSelector:@selector(positionChecked:)]) {
        [self.delegate positionChecked:self];
    }
}


@end
