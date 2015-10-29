//
//  MenuListView.m
//  路网采集
//
//  Created by Charles Leo on 14-10-14.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "MenuListView.h"
#import "ModeListCell.h"

@implementation MenuListView

@synthesize delegate;
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
    //    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    //    imageView.image = [UIImage imageNamed:@"left"];
    //    [self addSubview:imageView];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(2.5, 9, self.bounds.size.width- 5, self.bounds.size.height - 18)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:tableView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"ID";
    ModeListCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if (!cell) {
        cell = [[ModeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray * arrayImage = @[@"img_icon_user",@"img_icon_download",@"img_icon_about"];
    NSString * userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    if (userName == nil) {
        userName = @"gljcjry";
    }
    NSArray * arrayTitle = [NSArray arrayWithObjects:userName,@"离线地图下载",@"关于系统", nil];

    cell.mImageView.image = [UIImage imageNamed:[arrayImage objectAtIndex:indexPath.row]];
    cell.mLabel.text = [arrayTitle objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(menuSelect:andIndexPathRow:)]) {
        [self.delegate menuSelect:self andIndexPathRow:indexPath.row];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
