//
//  AddCollectionItemViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-3.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "AddCollectionItemViewController.h"
#import "AppDelegate.h"


@interface AddCollectionItemViewController ()

@end

@implementation AddCollectionItemViewController


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
    
    self.titleLabel.text = @"采集项";
    [self.leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backSv.userInteractionEnabled = YES;
    [self.view addSubview:backSv];
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    label1.backgroundColor = [UIColor yellowColor];
    label1.text = @"构造物采集项";
    [backSv addSubview:label1];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [ud objectForKey:@"collectionItemArray"];
    NSArray *array1 = [NSArray arrayWithObjects:@"桥梁",@"隧道",@"渡口",@"交通量观测站",@"检查站",@"公路涵洞",@"公路收费站",@"路线多媒体点", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"收费站所",@"管理中心",@"客运站", nil];
    for(int i=0;i<8;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(62+62*(i%3), label1.frame.origin.y+label1.frame.size.height+80*(i/3), 36, 36);
        [btn setTitle:[array1 objectAtIndex:i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[array1 objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10+i;
        [backSv addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+40, 36, 20)];
        label.text = [array1 objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [backSv addSubview:label];
        
        
        for(int i=0;i<[array0 count];i++)
        {
            
            if([btn.titleLabel.text isEqualToString:[array0 objectAtIndex:i]])
            {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = btn.frame;
                [button setTitle:btn.titleLabel.text forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"采集项图标选中"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 100+btn.tag-10;
                [backSv addSubview:button];
                
            }
        }

        
        
    }
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.frame.origin.y+label1.frame.size.height+80*(([array1 count]-1)/3)+36, self.view.frame.size.width, 40)];
    label2.backgroundColor = [UIColor yellowColor];
    label2.text = @"线状采集项";
    [backSv addSubview:label2];
    
    for(int i=0;i<3;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(62+62*(i%3), label2.frame.origin.y+label2.frame.size.height, 36, 36);
        [btn setTitle:[array2 objectAtIndex:i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[array2 objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 20+i;
        [backSv addSubview:btn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+40, 36, 20)];
        label.text = [array2 objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        [backSv addSubview:label];
        
        
        
        for(int i=0;i<[array0 count];i++)
        {
            
            if([btn.titleLabel.text isEqualToString:[array0 objectAtIndex:i]])
            {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = btn.frame;
                [button setTitle:btn.titleLabel.text forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"采集项图标选中"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 100+btn.tag-10;
                [backSv addSubview:button];
                
            }
        }
    }
    
}
-(void)btnClick:(UIButton *)btn
{
    
    
    if (btn.tag == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if((btn.tag>=10 && btn.tag<20) || (btn.tag>=20 && btn.tag<30))
    {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = btn.frame;
        [button setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"采集项图标选中"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+btn.tag-10;
        [backSv addSubview:button];
        
        
        collectionItemArray = [[NSMutableArray alloc]initWithCapacity:0];

        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [collectionItemArray addObject:btn.titleLabel.text];
        if(![ud objectForKey:@"collectionItemArray"])
        {
            
            [ud setObject:collectionItemArray forKey:@"collectionItemArray"];
        }
        else
        {
            
            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
            [array addObjectsFromArray:[ud objectForKey:@"collectionItemArray"]];
            [array addObject:btn.titleLabel.text];
            [ud setObject:array forKey:@"collectionItemArray"];
        }
        [ud synchronize];
        
    }
    if(btn.tag>=100)
    {
        //取消选中
        [btn removeFromSuperview];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ud objectForKey:@"collectionItemArray"]];
        [array removeObject:btn.titleLabel.text];
        [ud setObject:array forKey:@"collectionItemArray"];
        [ud synchronize];
        
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
