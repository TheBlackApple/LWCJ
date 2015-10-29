//
//  DataManageViewController.m
//  路网采集
//
//  Created by Cecilia on 14-3-31.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "DataManageViewController.h"
#import "DataManageDetailViewController.h"
#import "FMDatabase.h"

@interface DataManageViewController ()

@end

@implementation DataManageViewController
@synthesize path;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}
-(void)initInterface
{
    
    self.titleLabel.text = @"采集大师";
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 75, 18, 18)];
    iv.image = [UIImage imageNamed:@"等待上传"];
    [self.view addSubview:iv];
    
    UILabel *sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 260, 30)];
    sumLabel.text = [NSString stringWithFormat: @"等待上传数据%d条",dropCount+lineCount];
    [self.view addSubview:sumLabel];
    
    NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",dropCount],[NSString stringWithFormat:@"%d",lineCount], nil];
    for(int i=0;i<2;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40, 120+120*i, 100, 100);
        btn.tag = 10+i;
        btn.backgroundColor = [UIColor yellowColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(160, 160+100*i, 100, 30)];
        label.text = [NSString stringWithFormat:@"%@条",[array objectAtIndex:i]];
        label.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:label];
        
    }
    
}
-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 10:
        {
            //点状数据
            DataManageDetailViewController *dmdvc = [[DataManageDetailViewController alloc]init];
            dmdvc.contentStr = @"点状数据";
            dmdvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dmdvc animated:YES];
            //dmdvc.hidesBottomBarWhenPushed = NO;
            
        }
            break;
        case 11:
        {
            //线状数据
            DataManageDetailViewController *dmdvc = [[DataManageDetailViewController alloc]init];
            dmdvc.contentStr = @"线状数据";
            dmdvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dmdvc animated:YES];
            //dmdvc.hidesBottomBarWhenPushed = NO;
            
        }
            break;
            
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    dropCount = 0;
    lineCount = 0;
    
    self.path = NSHomeDirectory();
    self.path = [path stringByAppendingPathComponent:@"/Documents/data.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.path];
    if([db open])
    {
        
        
        FMResultSet *set = [db executeQuery:@"select *from table_drop"];
        while ([set next])
        {
            
            dropCount++;
            
        }
        
        set = [db executeQuery:@"select *from table_line"];
        while ([set next])
        {
            
            lineCount++;
            
        }
        
        [db close];

    }
    
    for(UIView *v in self.view.subviews)
    {
        
        [v removeFromSuperview];
        
    }
    
    [self initInterface];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
