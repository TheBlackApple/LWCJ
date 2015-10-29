//
//  FactoryClass.h
//  MyTaxi-V1.0.1
//
//  Created by hdsx-mac-mini on 13-8-6.
//  Copyright (c) 2013年 YaHuiLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryClass : NSObject

//导航栏工厂
+(UIView *)createNavigationControllerWithTitle:(NSString *)title andTarget:(id)target andAction:(SEL)selector;
//按钮工厂
+(UIButton *)createButtonWithTitle:(NSString *)title andBackImageName:(NSString *)imageName andFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)selector andButtonType:(UIButtonType)btnType andBackGroundColor:(UIColor *)backColor;
//标签工厂
+(UILabel *)createLabelWithFrame:(CGRect)frame andFont:(UIFont *)font andBackGroudColor:(UIColor *) backColor andTextColor:(UIColor *)textColor andLineBreakMode:(NSInteger)lineBreakMode andTextAlign:(NSInteger)textAlign andNumberOfLine:(NSInteger)number;
//文本编辑框工厂
+(UITextField *)createTextFiledWithFrame:(CGRect)frame andFont:(UIFont *)font andBorderStyle:(UITextBorderStyle)borderStyle andTextAlign:(NSInteger)textAlign andPlaceHolder:(NSString *)placeHoleder andKeyBordType:(NSInteger)keyBordType;
//图片工厂
+(UIImageView *)createImageViewRoundCornerViewWithFrame:(CGRect)frame andBackColor:(UIColor *)backColor andImageName:(NSString *)imageName;
//视图工厂
+(UIView *)createViewRoundCornerViewWithFrame:(CGRect)frame andBackColor:(UIColor *)backColor;
//网络检车工厂
+(UIView *)createBannerView;
//导航返回按钮工厂
+(UIBarButtonItem *)createNavigationBackButton;
//UItextView工厂
+(UITextView *)createTextViewWithFrame:(CGRect)frame andFont:(UIFont *)font andTextAlign:(NSInteger)textAlign andKeyBordType:(NSInteger)keyBordType;

@end
