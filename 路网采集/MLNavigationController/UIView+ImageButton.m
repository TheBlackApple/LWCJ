//
//  UIView+ImageButton.m
//  MyTaxiDriver
//
//  Created by Charles Leo  on 14-3-20.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import "UIView+ImageButton.h"
#import "FactoryClass.h"
@implementation UIView (ImageButton)
+(UIView *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andImageName:(NSString *)imageName andTarget:(id)target andAction:(SEL)seletor andButtonType:(UIButtonType)buttonType andBackGroundColor:(UIColor *)color andButtonState:(UIControlState)state
{
    UIView * containerView = [[UIView alloc]initWithFrame:frame];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 12, 18)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:imageName];
    [containerView addSubview:imageView];
    
    UIButton * navButton = [FactoryClass createButtonWithTitle:title andBackImageName:@"" andFrame:CGRectMake(0,8,70,28) andTarget:target andAction:seletor andButtonType:buttonType andBackGroundColor:[UIColor clearColor]];
    navButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [containerView addSubview:navButton];
    
    return containerView ;;
}

@end
