//
//  StakeViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-8.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "StakeViewController.h"
#import "AppDelegate.h"


@interface StakeViewController ()

@end

@implementation StakeViewController
@synthesize contentStr;


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
    
    self.titleLabel.text = @"桩号";
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *array = [NSArray arrayWithObjects:@"K",@"下划线",@"+",@"下划线", nil];
    for(int i=0;i<4;i++)
    {
        
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(40+(i%2?(30*((i+1)/2)+100*(i/2)):70*i), (64+60+(i%2)*15), ((i%2)?80:14),((i%2)?1:14))];
        iv.image = [UIImage imageNamed:[array objectAtIndex:i]];
        [self.view addSubview:iv];
        
    }
    
    kTf = [[UITextField alloc]initWithFrame:CGRectMake(70, 64+60, 80, 20)];
    kTf.delegate = self;
    kTf.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:kTf];
    
    jTf = [[UITextField alloc]initWithFrame:CGRectMake(200, 64+60, 80, 20)];
    jTf.delegate = self;
    jTf.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:jTf];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(50, jTf.frame.origin.y+jTf.frame.size.height+80, 220, 25);
    [sureBtn setImage:[UIImage imageNamed:@"确定"] forState:UIControlStateNormal];
    [sureBtn setImage:[UIImage imageNamed:@"确定高亮"] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 10;
    [self.view addSubview:sureBtn];
    
    
}
-(void)btnClick:(UIButton *)btn
{
    
    switch (btn.tag)
    {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 10:
        {
            
            if(![kTf.text isEqualToString:@""] && ![jTf.text isEqualToString:@""])
            {
                
                AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
                if([contentStr isEqualToString:@"centerStake"])
                {
                    
                    del.centerStake = [NSString stringWithFormat:@"K%@+%@",kTf.text,jTf.text];
                }
                if([contentStr isEqualToString:@"beginStake"])
                {
                    
                    del.beginStake = [NSString stringWithFormat:@"K%@+%@",kTf.text,jTf.text];
                }
                if([contentStr isEqualToString:@"endStake"])
                {
                    
                    del.endStake = [NSString stringWithFormat:@"K%@+%@",kTf.text,jTf.text];
                }

                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [kTf resignFirstResponder];
    [jTf resignFirstResponder];
    
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
