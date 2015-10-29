//
//  RodeStyleViewController.m
//  路网采集
//
//  Created by Cecilia on 14-5-5.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "RodeStyleViewController.h"
#import "AppDelegate.h"


@interface RodeStyleViewController ()

@end

@implementation RodeStyleViewController

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
    
    [self initInterface];
    
}

-(void)initInterface
{
    
    self.titleLabel.text = @"路段类型";
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"上行",@"下行",@"双向",@"匝道",@"其他", nil];
    for(int i=0;i<5;i++)
    {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 64+35*i, self.view.frame.size.width-40, 30)];
        label.userInteractionEnabled = YES;
        label.text = [array objectAtIndex:i];
        [self.view addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(280, label.frame.origin.y+10, 20, 20);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"框未选中"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"框选中"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        [self.view addSubview:btn];

    }
}

-(void)btnClick:(UIButton *)btn
{
    
    if(btn.tag == 0)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if(btn.tag>=10)
    {
        
        for(int i=10;i<15;i++)
        {
            
            UIButton *button0 = (UIButton *)[self.view viewWithTag:i];
            [button0 setImage:[UIImage imageNamed:@"框未选中"] forState:UIControlStateNormal];

        }
        
        [btn setImage:[UIImage imageNamed:@"框选中"] forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
        
        
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        del.rodeStyleTf = btn.titleLabel.text;
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
