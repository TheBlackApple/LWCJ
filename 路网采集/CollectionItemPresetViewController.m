//
//  CollectionItemPresetViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "CollectionItemPresetViewController.h"
#import "AddCollectionItemViewController.h"
#import "AppDelegate.h"

@interface CollectionItemPresetViewController ()

@end

@implementation CollectionItemPresetViewController
@synthesize titleStr;


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
    
    
    if([titleStr isEqualToString:@"采集项"])
    {
        
        [self.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *array0 = [NSArray arrayWithArray:[ud objectForKey:@"collectionItemArray"]];
        if([array0 count])
        {
            for(int i=0;i<[array0 count];i++)
            {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(62+62*(i%3), 20+60+80*(i/3), 36, 36);
                [btn setTitle:[array0 objectAtIndex:i] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:[array0 objectAtIndex:i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 10+i;
                [backSv addSubview:btn];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+40, 36, 20)];
                label.text = btn.titleLabel.text;
                label.textAlignment = NSTextAlignmentCenter;
                label.adjustsFontSizeToFitWidth = YES;
                [backSv addSubview:label];
                
            }
        }
    }
    if([titleStr isEqualToString:@"采集项预设置"])
    {
        
        [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn.tag = 2;
        
        
        
        NSArray *array1 = [NSArray arrayWithObjects:@"桥梁",@"隧道",@"渡口",@"交通量观测站",@"检查站",@"公路涵洞",@"公路收费站",@"路线多媒体点", nil];
        NSArray *array2 = [NSArray arrayWithObjects:@"收费站所",@"管理中心",@"客运站", nil];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSArray *array0 = [NSArray arrayWithArray:[ud objectForKey:@"collectionItemArray"]];
        
        //if([array0 count])
        {
            
            NSMutableArray *arr1 = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray *arr2 = [[NSMutableArray alloc]initWithCapacity:0];
            
            for(int i = 0;i<[array0 count];i++)
            {
                
                for(int j=0;j<[array1 count];j++)
                {
                    
                    if([[array0 objectAtIndex:i] isEqualToString:[array1 objectAtIndex:j]])
                    {
                        
                        [arr1 addObject:[array0 objectAtIndex:i]];
                        
                    }
                }
                
                for(int k=0;k<[array2 count];k++)
                {
                    
                    if([[array0 objectAtIndex:i] isEqualToString:[array2 objectAtIndex:k]])
                    {
                        
                        [arr2 addObject:[array0 objectAtIndex:i]];
                        
                    }
                }
            }
            [arr1 addObject:@"添加"];
            [arr2 addObject:@"添加"];
            
            
            UILabel *structrueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            structrueLabel.text = [NSString stringWithFormat:@"  预设 构造物类型(%d个)", [arr1 count]];
            structrueLabel.backgroundColor = [UIColor yellowColor];
            [backSv addSubview:structrueLabel];
            
            
            for(int i=0;i<[arr1 count];i++)
            {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(62+62*(i%3), structrueLabel.frame.origin.y+structrueLabel.frame.size.height+20+80*(i/3), 36, 36);
                [btn setTitle:[arr1 objectAtIndex:i] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:[arr1 objectAtIndex:i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+i;
                if(i == [arr1 count]-1)
                {
                    btn.tag = 1;
                }
                
                [backSv addSubview:btn];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+40, 36, 20)];
                label.text = btn.titleLabel.text;
                label.textAlignment = NSTextAlignmentCenter;
                label.adjustsFontSizeToFitWidth = YES;
                [backSv addSubview:label];
            }
            
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, structrueLabel.frame.origin.y+structrueLabel.frame.size.height+20+80*(([arr1 count]-1)/3+1), self.view.frame.size.width, 40)];
            lineLabel.text = [NSString stringWithFormat:@"  预设 线状类型(%d个)", [arr2 count]];
            lineLabel.backgroundColor = [UIColor yellowColor];
            [backSv addSubview:lineLabel];
            
            
            for(int i=0;i<[arr2 count];i++)
            {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(62+62*(i%3), lineLabel.frame.origin.y+lineLabel.frame.size.height+20+80*(i/3), 36, 36);
                [btn setTitle:[arr2 objectAtIndex:i] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:[arr2 objectAtIndex:i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 200+i;
                
                if(i == [arr2 count]-1)
                {
                    btn.tag = 1;
                }
                
                
                [backSv addSubview:btn];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+40, 36, 20)];
                label.text = btn.titleLabel.text;
                label.textAlignment = NSTextAlignmentCenter;
                label.adjustsFontSizeToFitWidth = YES;
                [backSv addSubview:label];
            }
        }
    }

}


-(void)btnClick:(UIButton *)btn
{

    if(btn.tag == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(btn.tag == 1)
    {
        //添加采集项
        AddCollectionItemViewController *acivc = [[AddCollectionItemViewController alloc]init];
        acivc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:acivc animated:YES];
        acivc.hidesBottomBarWhenPushed = NO;
        
    }
    if(btn.tag == 2)
    {
        //删除
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[ud objectForKey:@"collectionItemArray"]];
        
        for(int i=0;i<[deleteArray count];i++)
        {
            
            [array removeObject:[deleteArray objectAtIndex:i]];
            
        }
        
        [ud setObject:array forKey:@"collectionItemArray"];
        [ud synchronize];
        
        
        for(UIView *v in backSv.subviews)
        {
            
            [v removeFromSuperview];
            
        }
        
        deleteArray = [[NSMutableArray alloc]initWithCapacity:0];
        [self initInterface];
        
        
    }
    if(btn.tag>=10 && btn.tag<100)
    {
        //选中当前项并返回上个页面
        AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
        del.structureStyle = btn.titleLabel.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if(btn.tag>=100 && btn.tag<200)
    {
        //构造物类型选中
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = btn.frame;
        [button setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"采集项图标选中"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 300+btn.tag;
        [backSv addSubview:button];

        [deleteArray addObject:btn.titleLabel.text];
        
        
    }
    if(btn.tag>=200 && btn.tag<300)
    {
        //线状类型选中
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = btn.frame;
        [button setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"采集项图标选中"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 300+btn.tag;
        [backSv addSubview:button];
        
        [deleteArray addObject:btn.titleLabel.text];
        
    }
    if(btn.tag>=300)
    {
        
        [btn removeFromSuperview];
        
        UIButton *button = (UIButton *)[backSv viewWithTag:btn.tag-300];
        [deleteArray removeObject:button.titleLabel.text];
        
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    for(UIView *v in self.view.subviews)
    {
        
        [v removeFromSuperview];
        
    }
    
    self.titleLabel.text = titleStr;
    
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backSv.userInteractionEnabled = YES;
    [self.view addSubview:backSv];

    
    
    deleteArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self initInterface];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
