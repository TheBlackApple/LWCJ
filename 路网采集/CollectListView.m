//
//  CollectListView.m
//  路网采集
//
//  Created by Charles Leo on 14-10-14.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "CollectListView.h"
#import "ModeListCell.h"
@implementation CollectListView
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
    NSArray * arrayImage = @[@"img_icon_cd",@"img_icon_cx",@"img_icon_dx"];
    NSArray * arrayTitle = @[@"采点模式",@"采线模式",@"地图点选模式"];
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
    if ([self.delegate respondsToSelector:@selector(modeSelect:andIndexPathRow:)]) {
        [self.delegate modeSelect:self andIndexPathRow:indexPath.row];
    }
}





@end
