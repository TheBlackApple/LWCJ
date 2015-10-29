//
//  SearchView.m
//  路网采集
//
//  Created by Charles Leo on 14-10-16.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView
{
    UITextField * _textField ;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 44)];
    label.text = @"关键字:";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor darkGrayColor];
    [self addSubview:label];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake( 55, 2.5, WIDTH - 20 - 55, 44-5)];
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont boldSystemFontOfSize:14.0f];
    _textField.placeholder = @"酒店";
    [self addSubview:_textField];
    
    UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 44, WIDTH - 20, 44);
    //button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_search_bg"]];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_search_bg"] forState:UIControlStateNormal];
    [button setTitle:@"确认搜索" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor grayColor];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}
- (void)buttonClick:(UIButton *)sender
{
    NSLog(@"开始搜索了");
    [_textField resignFirstResponder];
    if (_textField.text == nil || [_textField.text isEqualToString:@""]) {
        [[iToast makeText:@"请输入关键字"]show];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return  YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_textField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchView:text:)])
    {
        [self.delegate searchView:self text:textField.text];
    }
    
}
@end
