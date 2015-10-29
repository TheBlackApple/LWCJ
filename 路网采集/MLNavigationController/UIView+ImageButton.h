//
//  UIView+ImageButton.h
//  MyTaxiDriver
//
//  Created by Charles Leo  on 14-3-20.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ImageButton)
+(UIView *)createButtonWithFrame:(CGRect)frame andTitle:(NSString *)title andImageName:(NSString *)imageName andTarget:(id)target andAction:(SEL)seletor andButtonType:(UIButtonType)buttonType andBackGroundColor:(UIColor *)color andButtonState:(UIControlState) state;
@end
