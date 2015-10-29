//
//  FactoryClass.m
//  MyTaxi-V1.0.1
//
//  Created by hdsx-mac-mini on 13-8-6.
//  Copyright (c) 2013年 YaHuiLiu. All rights reserved.
//

#import "FactoryClass.h"

#import <QuartzCore/QuartzCore.h>
@implementation FactoryClass
//网络检测工厂
+(UIView *)createBannerView
{
    UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, 44.0)];
    // [bannerView setBackgroundColor:(self.mode == MMReachabilityModeOverlay ? [UIColor clearColor] : [UIColor whiteColor])];
    UILabel *noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, bannerView.frame.size.width, bannerView.frame.size.height)];
    [noConnectionLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [noConnectionLabel setTextColor:[UIColor whiteColor]];
    [noConnectionLabel setShadowColor:[UIColor blackColor]];
    [noConnectionLabel setText:@"没有网络连接!"];
    [noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
    [noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [noConnectionLabel setBackgroundColor:[UIColor redColor]];
    [noConnectionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = noConnectionLabel.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.8 green:0 blue:0 alpha:0.8] CGColor],
                       (id)[[UIColor colorWithRed:0.4 green:0 blue:0 alpha:0.8] CGColor],
                       nil];
    [bannerView.layer insertSublayer:gradient atIndex:0];
    [bannerView addSubview:noConnectionLabel];
    
    return bannerView;
}
//导航栏工厂
+(UIView *)createNavigationControllerWithTitle:(NSString *)title andTarget:(id)target andAction:(SEL)selector
{
    UIView * mNavigationView = [[UIView alloc]init];
    UILabel * mNavTitle;
    if ([SYSTEMVERSION characterAtIndex:0] > 6) {
        mNavigationView.frame = CGRectMake(0, 20, 320, 44);
    }
    else
    {
        mNavigationView.frame = CGRectMake(0, 0, 320, 44);
    }
    mNavigationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topbg"]];
    if (target !=nil)
    {
        UIButton * btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        //设置按钮标题字体
        btnBack.tag = 123;
        btnBack.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 30, 30)];
        label.text = @"返回";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0];
        [btnBack addSubview:label];
        
        btnBack.frame = CGRectMake(10, 7, 50, 30);
        [btnBack setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        [btnBack addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        [mNavigationView addSubview:btnBack];
    }
    mNavTitle = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, 150, 30)];
    mNavTitle.textAlignment = NSTextAlignmentCenter;
    mNavTitle.font = [UIFont systemFontOfSize:15.0f];
    mNavTitle.backgroundColor = [UIColor clearColor];
    mNavTitle.textColor = [UIColor whiteColor];
    mNavTitle.text = title;
    [mNavigationView addSubview:mNavTitle];
    
    return mNavigationView;
}
//按钮工厂
+(UIButton *)createButtonWithTitle:(NSString *)title andBackImageName:(NSString *)imageName andFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)selector andButtonType:(UIButtonType)btnType andBackGroundColor:(UIColor *)backColor
{
    UIButton * button = [UIButton buttonWithType:btnType];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = backColor;
    button.layer.cornerRadius = 6.0;
    button.titleLabel.textColor = [UIColor whiteColor];
    
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}
//标签工厂
+(UILabel *)createLabelWithFrame:(CGRect)frame andFont:(UIFont *)font andBackGroudColor:(UIColor *)backColor andTextColor:(UIColor *)textColor andLineBreakMode:(NSInteger)lineBreakMode andTextAlign:(NSInteger)textAlign andNumberOfLine:(NSInteger)number
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = textColor;
    //label.textAlignment = textAlign;
    label.numberOfLines = number;
    label.font = font;
    label.backgroundColor = backColor;
    //label.lineBreakMode = lineBreakMode;
    return label;
}

//图片工厂
+(UIImageView *)createImageViewRoundCornerViewWithFrame:(CGRect)frame andBackColor:(UIColor *)backColor andImageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.backgroundColor = backColor;
    imageView.layer.cornerRadius = 9.0;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderColor = 0;
    return imageView ;
}
//视图工厂
+(UIView *)createViewRoundCornerViewWithFrame:(CGRect)frame andBackColor:(UIColor *)backColor
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backColor;
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderColor = 0;
    return view ;
}
//导航栏返回按钮工厂
+(UIBarButtonItem *)createNavigationBackButton
{
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    [returnButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [returnButtonItem setTintColor:[UIColor whiteColor]];
    [returnButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor colorWithRed:1 green:1 blue:1 alpha:1], NSForegroundColorAttributeName,
                                              [UIColor colorWithRed:1 green:1 blue:1 alpha:1], UITextAttributeTextShadowColor,
                                              [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                              [UIFont systemFontOfSize:15.0f], NSFontAttributeName,
                                              nil] forState:UIControlStateNormal];
    returnButtonItem.title = @"返 回";
    return returnButtonItem;
}
+(UITextField *)createTextFiledWithFrame:(CGRect)frame andFont:(UIFont *)font andBorderStyle:(UITextBorderStyle)borderStyle andTextAlign:(NSInteger)textAlign andPlaceHolder:(NSString *)placeHoleder andKeyBordType:(NSInteger)keyBordType
{
    UITextField * textFiled = [[UITextField alloc]init];
    textFiled.frame = frame;
    textFiled.borderStyle =borderStyle;
    textFiled.placeholder = placeHoleder;
    textFiled.textAlignment = textAlign;
    textFiled.keyboardType = keyBordType;
    textFiled.font = font;
    return textFiled ;
}
+(UITextView *)createTextViewWithFrame:(CGRect)frame andFont:(UIFont *)font andTextAlign:(NSInteger)textAlign andKeyBordType:(NSInteger)keyBordType
{
    UITextView * textFiled = [[UITextView alloc]init];
    textFiled.frame = frame;
   // textFiled.borderStyle =borderStyle;
   // textFiled.placeholder = placeHoleder;
    textFiled.textAlignment = textAlign;
    textFiled.keyboardType = keyBordType;
    textFiled.font = font;
    return textFiled ;
}
@end
