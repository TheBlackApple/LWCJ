//
//  DataManageDetailViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-1.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "DataManageDetailViewController.h"
#import "EditMessageViewController.h"
#import "FMDatabase.h"
#import "AppDelegate.h"

@interface DataManageDetailViewController ()

@end

@implementation DataManageDetailViewController
@synthesize contentStr;
@synthesize ocbView;
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
	
    NSLog(@"viewDidload");
    
    
    self.titleLabel.text = @"数据管理";
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.frame = CGRectMake(0, 0, 80, 20);
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn setTitle:@"批量上传" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backSv.userInteractionEnabled = YES;
    [self.view addSubview:backSv];

    
    [self dbQuery];
    [self initInterface];
    
    
}
-(void)initInterface
{
    
    
    NSArray *array = [NSArray arrayWithObjects:@"点状数据",@"线状数据", nil];
    for(int i=0;i<2;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(160*i, 0, 160, 40);
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backSv addSubview:btn];
        
    }
    
    if([contentStr isEqualToString:@"点状数据"])
    {
        
        [self initDropView];
        
    }
    if([contentStr isEqualToString:@"线状数据"])
    {
        
        [self initLineView];
        
    }
}
-(void)initDropView
{
    
    
    if([dropArray count])
    {
        
        for(UIView *v in ocbView.subviews)
        {
            
            [v removeFromSuperview];
            
        }
        ocbView.frame = CGRectZero;
        
        backSv.contentSize = CGSizeMake(self.view.frame.size.width, 40+80*[dropArray count]+40);
        ocbView = [[OCBorghettiView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, backSv.contentSize.height-40)];
        
        ocbView.delegate = self;
        ocbView.accordionSectionHeight = 80;
        ocbView.accordionSectionColor = [UIColor lightGrayColor];
        [backSv addSubview:ocbView];
        
        for(int i=0;i<[dropArray count];i++)
        {
            
            UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            tv.tag = 1000+i;
            tv.dataSource = self;
            tv.delegate = self;
            tv.showsVerticalScrollIndicator = NO;
            [ocbView addSectionWithTitle:nil andView:tv andImage:@"确定" andName:[[dropArray objectAtIndex:i] objectAtIndex:1] andStake:[[dropArray objectAtIndex:i] objectAtIndex:2] andHuman:[[dropArray objectAtIndex:i] objectAtIndex:5] andDate:[[dropArray objectAtIndex:i] objectAtIndex:3] andStakeEnd:nil andContent:contentStr];
        }

    }
    
}
-(void)initLineView
{
    
    
    for(UIView *v in ocbView.subviews)
    {
        
        [v removeFromSuperview];
        
    }
    ocbView.frame = CGRectZero;
    
    if([lineArray count])
    {
        
        backSv.contentSize = CGSizeMake(self.view.frame.size.width, 40+80*[lineArray count]+40);
        ocbView = [[OCBorghettiView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, backSv.contentSize.height-40)];
        
        ocbView.delegate = self;
        ocbView.accordionSectionHeight = 80;
        ocbView.accordionSectionColor = [UIColor yellowColor];
        [backSv addSubview:ocbView];
        
        for(int i=0;i<[lineArray count];i++)
        {
            
            UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
            tv.tag = 1000+i;
            tv.dataSource = self;
            tv.delegate = self;
            tv.showsVerticalScrollIndicator = NO;
            [ocbView addSectionWithTitle:nil andView:tv andImage:@"确定" andName:[[lineArray objectAtIndex:i] objectAtIndex:1] andStake:[[lineArray objectAtIndex:i] objectAtIndex:4] andHuman:[[lineArray objectAtIndex:i] objectAtIndex:8] andDate:[[lineArray objectAtIndex:i] objectAtIndex:6] andStakeEnd:[[lineArray objectAtIndex:i] objectAtIndex:5] andContent:contentStr];
            
        }

    }
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([contentStr isEqualToString:@"点状数据"])
    {
        return [dropArray count];
    }
    else
    {
        return [lineArray count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        
    }
    
    NSArray *array = [NSArray arrayWithObjects:@"查看",@"删除",@"上传", nil];
    for(int i=0;i<3;i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(80+80*i, 10, 24, 24);
        [btn setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = (indexPath.row+1)*100+i;
        [cell.contentView addSubview:btn];
        
        
    }

    //cell.contentView.backgroundColor = [UIColor lightTextColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)btnClick:(UIButton *)btn
{
    if(btn.tag == 0)
    {
            
        [self.navigationController popViewControllerAnimated:YES];
            
    }
    if(btn.tag == 1)
    {
        //批量上传
        
        
    }
    if(btn.tag == 10)
    {
        //点状数据
        contentStr = @"点状数据";
        [self initDropView];
            
    }
    if(btn.tag == 11)
    {
        //线状数据
        contentStr = @"线状数据";
        [self initLineView];
        
    }
    if(btn.tag>=100)
    {
        
        if(btn.tag%100 == 0)
        {
            //查看
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            if([contentStr isEqualToString:@"点状数据"])
            {
                del.dropArray = [NSArray arrayWithArray:[dropArray objectAtIndex:btn.tag/100-1]];
                [ud setValue:[del.dropArray objectAtIndex:3] forKey:@"cjsj"];

            }
            if([contentStr isEqualToString:@"线状数据"])
            {
                del.lineArray = [NSArray arrayWithArray:[lineArray objectAtIndex:btn.tag/100-1]];
                [ud setValue:[del.lineArray objectAtIndex:6] forKey:@"cjsj"];
                NSArray *arr = [NSArray arrayWithObjects:[del.lineArray objectAtIndex:10],[del.lineArray objectAtIndex:11],[del.lineArray objectAtIndex:12],[del.lineArray objectAtIndex:13],[del.lineArray objectAtIndex:9], nil];
                [ud setValue:arr forKey:@"relocationArray"];

            }
            
            [ud synchronize];
            
            
            EditMessageViewController *emvc = [[EditMessageViewController alloc]init];
            emvc.contentStr = contentStr;
            
            emvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:emvc animated:YES];
            emvc.hidesBottomBarWhenPushed = NO;
            
        }
        if(btn.tag%100 == 1)
        {
            //删除
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定删除数据吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            av.tag = btn.tag/100-1;
            [av show];
            
            
        }
        if(btn.tag%100 == 2)
        {
            //上传
            //[dropArray objectAtIndex:btn.tag/100-1]
            [self uploadData];
            
        }
    }
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        //确定删除
        FMDatabase *db = [FMDatabase databaseWithPath:self.path];
        if([db open])
        {
            
            BOOL res ;
            if([contentStr isEqualToString:@"点状数据"])
            {
                
                res = [db executeUpdate:@"delete from table_drop where cjsj=?",[[dropArray objectAtIndex:alertView.tag] objectAtIndex:3]];
                
                
            }
            if([contentStr isEqualToString:@"线状数据"])
            {
                
                res = [db executeUpdate:@"delete from table_line where cjsj=?",[[lineArray objectAtIndex:alertView.tag] objectAtIndex:6]];
                
            }
            
            if(res)
            {
                
                NSLog(@"delete success!");
                [db close];
                
                for(UIView *v in backSv.subviews)
                {
                    
                    [v removeFromSuperview];
                    
                }
                
                [self dbQuery];
                [self initInterface];

            }
            else
            {
                
                NSLog(@"delete failed!");
                [db close];
                
            }
        }
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"viewwillappear");
    
}

-(void)dbQuery
{
    
    self.path = NSHomeDirectory();
    self.path = [path stringByAppendingPathComponent:@"/Documents/data.db"];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.path];
    if([db open])
    {
        
        dropArray = [[NSMutableArray alloc]initWithCapacity:0];
        lineArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        FMResultSet *set = [db executeQuery:@"select *from table_drop"];
        while ([set next])
        {
            
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
            for(int i=0;i<12;i++)
            {
                if(i == 11)
                {
                    [arr addObject:[set dataForColumnIndex:i]];
                }
                else
                {
                    [arr addObject:[set stringForColumnIndex:i]];
                }
            }
            
            [dropArray addObject:arr];
            
        }
        
        
        set = [db executeQuery:@"select *from table_line"];
        while ([set next])
        {
            
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
            for(int i=0;i<16;i++)
            {
                [arr addObject:[set stringForColumnIndex:i]];
            }
            
            [lineArray addObject:arr];
            
        }
        
        
        [db close];
    }

}
-(void)uploadData
{
    
    NSString *uploadStr = nil;
    ASIHTTPRequest *request = nil;
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    
    if([contentStr isEqualToString:@"点状数据"])
    {
        
        [dict setValue:[dropArray objectAtIndex:0] forKey:@"code"];
        [dict setValue:[dropArray objectAtIndex:1] forKey:@"name"];
        [dict setValue:[dropArray objectAtIndex:2] forKey:@"pos"];
        [dict setValue:[dropArray objectAtIndex:3] forKey:@"cjsj"];
        [dict setValue:[dropArray objectAtIndex:4] forKey:@"scsj"];
        [dict setValue:[dropArray objectAtIndex:5] forKey:@"scr"];
        [dict setValue:[dropArray objectAtIndex:6] forKey:@"ptx"];
        [dict setValue:[dropArray objectAtIndex:7] forKey:@"pty"];
        [dict setValue:[dropArray objectAtIndex:8] forKey:@"type"];
        [dict setValue:[dropArray objectAtIndex:9] forKey:@"codeAlpha"];
        [dict setValue:[dropArray objectAtIndex:10] forKey:@"codeNum"];
        
        uploadStr = [NSString stringWithFormat:@"%@/gps/addPoint",requestHeader];
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:uploadStr]];
        [request setValuesForKeysWithDictionary:dict];
        
        
    }
    if([contentStr isEqualToString:@"线状数据"])
    {
        
        [dict setValue:[lineArray objectAtIndex:0] forKey:@"roadcode"];
        [dict setValue:[lineArray objectAtIndex:1] forKey:@"roadname"];
        [dict setValue:[lineArray objectAtIndex:2] forKey:@"ldxz"];
        [dict setValue:[lineArray objectAtIndex:3] forKey:@"ldlx"];
        [dict setValue:[lineArray objectAtIndex:4] forKey:@"qdzh"];
        [dict setValue:[lineArray objectAtIndex:5] forKey:@"zdzh"];
        [dict setValue:[lineArray objectAtIndex:6] forKey:@"cjsj"];
        [dict setValue:[lineArray objectAtIndex:7] forKey:@"scsj"];
        [dict setValue:[lineArray objectAtIndex:8] forKey:@"scr"];
        [dict setValue:[lineArray objectAtIndex:9] forKey:@"lxlc"];
        [dict setValue:[lineArray objectAtIndex:10] forKey:@"qdjd"];
        [dict setValue:[lineArray objectAtIndex:11] forKey:@"qdwd"];
        [dict setValue:[lineArray objectAtIndex:12] forKey:@"zdjd"];
        [dict setValue:[lineArray objectAtIndex:13] forKey:@"zdwd"];
        [dict setValue:[lineArray objectAtIndex:14] forKey:@"codeAlpha"];
        [dict setValue:[lineArray objectAtIndex:15] forKey:@"codeNum"];
 

        uploadStr = [NSString stringWithFormat:@"%@/gps/addLine",requestHeader];
        [request setValuesForKeysWithDictionary:dict];
        
    }
    
    request.delegate = self;
    [request startAsynchronous];
    

}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"request.responseString:%@",request.responseString);
    NSString *status = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    if([status integerValue] == 1)
    {
        //上传成功
        
    }
    else
    {
        //上传失败
        
    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
