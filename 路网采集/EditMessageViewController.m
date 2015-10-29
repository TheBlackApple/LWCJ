//
//  EditMessageViewController.m
//  路网采集
//
//  Created by Cecilia on 14-4-3.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "EditMessageViewController.h"
#import "CollectionItemPresetViewController.h"
#import "StakeViewController.h"
#import "RodeStyleViewController.h"
#import "FMDatabase.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"


@interface EditMessageViewController ()

@end

@implementation EditMessageViewController
@synthesize contentStr;
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
    
    self.path = NSHomeDirectory();
    self.path = [path stringByAppendingPathComponent:@"/Documents/data.db"];
    NSLog(@"self.path:%@",self.path);
    
    
    self.titleLabel.text = @"编辑信息";
    [self.leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backSv.userInteractionEnabled = YES;
    [self.view addSubview:backSv];
    
    
    UIButton *saveUpdateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveUpdateBtn.frame = CGRectMake(50, 10, 220, 25);
    [saveUpdateBtn setImage:[UIImage imageNamed:@"保存并立即上传数据"] forState:UIControlStateNormal];
    [saveUpdateBtn setImage:[UIImage imageNamed:@"保存并立即上传数据高亮"] forState:UIControlStateHighlighted];
    [saveUpdateBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveUpdateBtn.tag = 10;
    [backSv addSubview:saveUpdateBtn];
    
    
    
    [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    collectionDate = [formatter stringFromDate:[NSDate date]];
    
    
    
    NSArray *lArr = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"locationArray"]];

    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if([contentStr isEqualToString:@"点状数据"])
    {
        
        UILabel *baseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, saveUpdateBtn.frame.origin.y+saveUpdateBtn.frame.size.height+5, self.view.frame.size.width, 20)];
        baseLabel.backgroundColor = [UIColor cyanColor];
        baseLabel.text = @"基本信息";
        [backSv addSubview:baseLabel];
        
        
        NSArray *array = [NSArray arrayWithObjects:
                          [NSString stringWithFormat:@"构造物类型：%@",[del.dropArray objectAtIndex:8]?[del.dropArray objectAtIndex:8]:(del.structureStyle?del.structureStyle:@"点击添加")],
                          [NSString stringWithFormat:@"点状编码："],
                          @"点状名称：",
                          @"中心桩号：",
                          [NSString stringWithFormat:@"当前经度：%@",[del.dropArray objectAtIndex:6]?[del.dropArray objectAtIndex:6]:[lArr objectAtIndex:0]],
                          [NSString stringWithFormat:@"当前纬度：%@",[del.dropArray objectAtIndex:7]?[del.dropArray objectAtIndex:7]:[lArr objectAtIndex:1]],
                          [NSString stringWithFormat:@"采集人员：%@",[del.dropArray objectAtIndex:5]?[del.dropArray objectAtIndex:5]:@"交通局"],
                          [NSString stringWithFormat:@"采集时间：%@",([del.dropArray objectAtIndex:3]?[del.dropArray objectAtIndex:3]:[[NSUserDefaults standardUserDefaults] valueForKey:@"cjsj"])
                           ?([del.dropArray objectAtIndex:3]?[del.dropArray objectAtIndex:3]:[[NSUserDefaults standardUserDefaults] valueForKey:@"cjsj"]):collectionDate], nil];
        
        
        for(int i=0;i<6;i++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, baseLabel.frame.origin.y+baseLabel.frame.size.height+20+40*i, 200, 30)];
            label.text = [array objectAtIndex:i];
            label.adjustsFontSizeToFitWidth = YES;
            [backSv addSubview:label];
            
            if(i == 1)
            {
                //点状编码
                label.userInteractionEnabled = YES;
                label.tag = 1000;
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.frame = CGRectMake(80, 0, 40, 30);
                [selectBtn setTitle:[del.dropArray objectAtIndex:9]?[del.dropArray objectAtIndex:9]:@"G" forState:UIControlStateNormal];
                [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                selectBtn.backgroundColor = [UIColor yellowColor];
                selectBtn.tag = 12;
                [label addSubview:selectBtn];
                
                //点状编码数字
                dropNumTf = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, 80, 30)];
                dropNumTf.keyboardType = UIKeyboardTypeNumberPad;
                dropNumTf.delegate = self;
                

                dropNumTf.text = ([del.dropArray objectAtIndex:10]?[del.dropArray objectAtIndex:10]:del.dropNumTf)?([del.dropArray objectAtIndex:10]?[del.dropArray objectAtIndex:10]:del.dropNumTf):@"点击添加";
                del.dropNumTf = dropNumTf.text;
                

                [label addSubview:dropNumTf];
                    

            }
        }
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(240, baseLabel.frame.origin.y+baseLabel.frame.size.height+20, 36, 36);
        [selectBtn setImage:[UIImage imageNamed:@"构造物类型"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"构造物类型高亮"] forState:UIControlStateHighlighted];
        [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = 11;
        [backSv addSubview:selectBtn];
        
        //点状名称
        nameTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+20+40*2, 100, 30)];
        nameTf.delegate = self;
        
        
        nameTf.text = ([del.dropArray objectAtIndex:1]?[del.dropArray objectAtIndex:1]:del.dropNameTf)?([del.dropArray objectAtIndex:1]?[del.dropArray objectAtIndex:1]:del.dropNameTf):@"点击添加";

        del.dropNameTf = nameTf.text;
        
        [backSv addSubview:nameTf];
        
        //中心桩号
        numTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+20+40*3, 100, 30)];
        numTf.delegate = self;
        numTf.placeholder = @"点击添加";
        [backSv addSubview:numTf];
        
        
        UILabel *aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, baseLabel.frame.origin.y+baseLabel.frame.size.height+20+40*6, self.view.frame.size.width, 20)];
        aboutLabel.backgroundColor = [UIColor cyanColor];
        aboutLabel.text = @"相关信息";
        [backSv addSubview:aboutLabel];
        
        
        for(int i=0;i<2;i++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, aboutLabel.frame.origin.y+aboutLabel.frame.size.height+10+35*i, 260, 30)];
            label.text = [array objectAtIndex:6+i];
            [backSv addSubview:label];
            
        }
        //拍照 显示  保存
        UIImageView *snapIv = [[UIImageView alloc]initWithFrame:CGRectMake(40, aboutLabel.frame.origin.y+aboutLabel.frame.size.height+10+35*2, 50, 50)];
        snapIv.tag = 1001;
        
        if([del.dropArray count]>11)
        {
            snapIv.image = [UIImage imageWithData:[del.dropArray objectAtIndex:11]];
        }
        snapIv.backgroundColor = [UIColor lightGrayColor];
        [backSv addSubview:snapIv];

        for(int i=0;i<2;i++)
        {
            
            NSArray *arr = [NSArray arrayWithObjects:@"拍照",@"保存", nil];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(40+140*i, snapIv.frame.origin.y+snapIv.frame.size.height+5, 100, 30);
            btn.tag = 13+i;
            [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backSv addSubview:btn];
            
        }
        
        
       backSv.contentSize = CGSizeMake(self.view.frame.size.width, snapIv.frame.origin.y+snapIv.frame.size.height+50);
        
        
        
    }
    if([contentStr isEqualToString:@"线状数据"])
    {
        
        UILabel *baseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, saveUpdateBtn.frame.origin.y+saveUpdateBtn.frame.size.height+5, self.view.frame.size.width, 20)];
        baseLabel.backgroundColor = [UIColor cyanColor];
        baseLabel.text = @"基本信息";
        [backSv addSubview:baseLabel];
        
        
        NSArray *array = [NSArray arrayWithObjects:
                          @"路线编码：",
                          @"路线名称：",
                          @"路线类型：",
                          @"路段类型：",
                          @"起点桩号：",
                          @"止点桩号：",
                          [NSString stringWithFormat:@"路线里程：%@",[del.lineArray objectAtIndex:9]?[del.lineArray objectAtIndex:9]:[lArr objectAtIndex:[lArr count]-1]],
                          [NSString stringWithFormat:@"起点经度：%@",[del.lineArray objectAtIndex:10]?[del.lineArray objectAtIndex:10]:[lArr objectAtIndex:0]],
                          [NSString stringWithFormat:@"起点纬度：%@",[del.lineArray objectAtIndex:11]?[del.lineArray objectAtIndex:11]:[lArr objectAtIndex:1]],
                          [NSString stringWithFormat:@"止点经度：%@",[del.lineArray objectAtIndex:12]?[del.lineArray objectAtIndex:12]:[lArr objectAtIndex:[lArr count]-3]],
                          [NSString stringWithFormat:@"止点纬度：%@",[del.lineArray objectAtIndex:13]?[del.lineArray objectAtIndex:13]:[lArr objectAtIndex:[lArr count]-2]],
                          [NSString stringWithFormat:@"采集人员：%@",[del.lineArray objectAtIndex:8]?[del.lineArray objectAtIndex:8]:@"交通局"],
                          [NSString stringWithFormat:@"采集时间：%@",([del.lineArray objectAtIndex:6]?[del.lineArray objectAtIndex:6]:[[NSUserDefaults standardUserDefaults] valueForKey:@"cjsj"])?([del.lineArray objectAtIndex:6]?[del.lineArray objectAtIndex:6]:[[NSUserDefaults standardUserDefaults] valueForKey:@"cjsj"]):collectionDate], nil];
        for(int i=0;i<11;i++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, baseLabel.frame.origin.y+baseLabel.frame.size.height+35*i, 200, 30)];
            label.text = [array objectAtIndex:i];
            [backSv addSubview:label];
            
            if(i == 0)
            {
                
                label.userInteractionEnabled = YES;
                label.tag = 1000;
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                selectBtn.frame = CGRectMake(80, 0, 40, 30);
                [selectBtn setTitle:[del.lineArray objectAtIndex:14]?[del.lineArray objectAtIndex:14]:@"G" forState:UIControlStateNormal];
                [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                selectBtn.backgroundColor = [UIColor yellowColor];
                selectBtn.tag = 12;
                [label addSubview:selectBtn];
                
                dropNumTf = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, 80, 30)];
                dropNumTf.keyboardType = UIKeyboardTypeNumberPad;
                dropNumTf.delegate = self;
                

                dropNumTf.text = ([del.lineArray objectAtIndex:15]?[del.lineArray objectAtIndex:15]:del.dropNumTf)?([del.lineArray objectAtIndex:15]?[del.lineArray objectAtIndex:15]:del.dropNumTf):@"点击添加";
                
                del.dropNumTf = dropNumTf.text;
                
                [label addSubview:dropNumTf];

                
            }
        }
        
        routeNameTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+35, 100, 30)];
        routeNameTf.delegate = self;
        
        routeNameTf.text = ([del.lineArray objectAtIndex:1]?[del.lineArray objectAtIndex:1]:del.dropNameTf)?([del.lineArray objectAtIndex:1]?[del.lineArray objectAtIndex:1]:del.dropNameTf):@"点击添加";
        
        del.dropNameTf = routeNameTf.text;
        
        [backSv addSubview:routeNameTf];
        
        routeStyleTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+70, 100, 30)];
        routeStyleTf.delegate = self;
        routeStyleTf.placeholder = @"点击添加";
        [backSv addSubview:routeStyleTf];
        
        rodeStyleTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+105, 100, 30)];
        rodeStyleTf.delegate = self;
        rodeStyleTf.placeholder = @"点击添加";
        [backSv addSubview:rodeStyleTf];
        
        beginTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+140, 100, 30)];
        beginTf.delegate = self;
        beginTf.placeholder = @"点击添加";
        [backSv addSubview:beginTf];
        
        endTf = [[UITextField alloc]initWithFrame:CGRectMake(120, baseLabel.frame.origin.y+baseLabel.frame.size.height+175, 100, 30)];
        endTf.delegate = self;
        endTf.placeholder = @"点击添加";
        [backSv addSubview:endTf];
        
        
        UILabel *aboutLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, baseLabel.frame.origin.y+baseLabel.frame.size.height+35*11, self.view.frame.size.width, 20)];
        aboutLabel.backgroundColor = [UIColor cyanColor];
        aboutLabel.text = @"相关信息";
        [backSv addSubview:aboutLabel];
        
        
        for(int i=0;i<2;i++)
        {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, aboutLabel.frame.origin.y+aboutLabel.frame.size.height+35*i, 260, 30)];
            label.text = [array objectAtIndex:11+i];
            [backSv addSubview:label];
            
        }
        
        backSv.contentSize = CGSizeMake(self.view.frame.size.width, aboutLabel.frame.origin.y+aboutLabel.frame.size.height+35*2);
        
    }
    
    
    
    control = [[UIControl alloc]initWithFrame:backSv.frame];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [backSv addSubview:control];
    [backSv sendSubviewToBack:control];
    
    
}
-(void)btnClick:(UIButton *)btn
{
    
    if(btn.tag == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if(btn.tag == 1)
    {
        //保存
        if([contentStr isEqualToString:@"点状数据"])
        {
            [self saveDropAction];
        }
        if([contentStr isEqualToString:@"线状数据"])
        {
            [self saveLineAction];
        }
        
        
    }
    if(btn.tag == 10)
    {
        //保存并立即上传数据
        [self saveAndUploadData];
        
    }
    if(btn.tag == 11)
    {
        //构造物类型选择
        CollectionItemPresetViewController *cipvc = [[CollectionItemPresetViewController alloc]init];
        cipvc.hidesBottomBarWhenPushed = YES;
        cipvc.titleStr = @"采集项";
        [self.navigationController pushViewController:cipvc animated:YES];
        cipvc.hidesBottomBarWhenPushed = NO;
        
    }
    if(btn.tag == 12)
    {
        //点状编码字母选择
        
        UIView *view = [[UIView alloc]initWithFrame:self.view.window.frame];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.view.window addSubview:view];
        
        UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(20, 40, 280, 400) style:UITableViewStylePlain];
        tv.delegate = self;
        tv.dataSource = self;
        [view addSubview:tv];
        [UIApplication sharedApplication].statusBarHidden = YES;
        
    }
    if(btn.tag == 13)
    {
        //拍照
        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
        pc.sourceType = UIImagePickerControllerSourceTypeCamera;
        pc.delegate = self;
        [self presentModalViewController:pc animated:YES];
        
        
    }
    if(btn.tag == 14)
    {
        //拍照后保存到相册
        UIImageView *tmpIv = (UIImageView *)[backSv viewWithTag:1001];
        UIImageWriteToSavedPhotosAlbum(tmpIv.image, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:
(NSError *)error contextInfo:(void *)contextInfo;
{
    
    UIAlertView *aview = nil;
    if (!error)
    {
        aview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"Image written to photo album" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aview show];
    }
    else
    {
        
        aview = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [aview show];

    }

}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *tmpIv = (UIImageView *)[backSv viewWithTag:1001];
    tmpIv.image = image;
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        
    }
    NSArray *array = [NSArray arrayWithObjects:@"G",@"S",@"H",@"T",@"X",@"Y",@"Z",@"C",@"D",@"W",@"L",@"V",@"FQ",@"P", nil];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array = [NSArray arrayWithObjects:@"G",@"S",@"H",@"T",@"X",@"Y",@"Z",@"C",@"D",@"W",@"L",@"V",@"FQ",@"P", nil];
    
    [[self.view.window.subviews objectAtIndex:[self.view.window.subviews count]-1] removeFromSuperview];
    
    UILabel *label = (UILabel *)[backSv viewWithTag:1000];
    UIButton *btn = (UIButton *)[label viewWithTag:12];
    [btn setTitle:[array objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    
}



-(void)saveDropAction
{
  
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(![dropNumTf.text isEqualToString:@""] && ![nameTf.text isEqualToString:@""] && ![numTf.text isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] objectForKey:@"name"])
    {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.path];
        if([db open])
        {
            
            UILabel *label = (UILabel *)[backSv viewWithTag:1000];
            UIButton *btn = (UIButton *)[label viewWithTag:12];
            
            //表字段值:编码,名称,中心桩号,采集时间,上传时间,采集人,经度,纬度,点状物类型,编码字母部分,编码数字部分,拍照照片
            BOOL res = [db executeUpdate:@"create table if not exists table_drop(code,name,pos,cjsj,scsj,scr,ptx,pty,type,codeAlpha,codeNum,snapPhoto)"];
            if(res)
            {
                
                dict = [[NSMutableDictionary alloc]initWithCapacity:0];
                UIImageView *tmpIv = (UIImageView *)[backSv viewWithTag:1001];
                NSData *data = nil;
                if (UIImagePNGRepresentation(tmpIv.image) == nil) {
                    
                    data = UIImageJPEGRepresentation(tmpIv.image, 1);
                    
                } else {
                    
                    data = UIImagePNGRepresentation(tmpIv.image);
                }

                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSArray *lArr = [NSArray arrayWithArray:[ud objectForKey:@"locationArray"]];
                
                FMResultSet *set = [db executeQuery:@"select *from table_drop where cjsj=?",[ud objectForKey:@"cjsj"]];
                if ([set next])
                {
                    [dict setValue:[NSString stringWithFormat:@"%@%@",btn.titleLabel.text,dropNumTf.text] forKey:@"code"];
                    [dict setValue:nameTf.text forKey:@"name"];
                    [dict setValue:numTf.text forKey:@"pos"];
                    [dict setValue:[ud objectForKey:@"cjsj"] forKey:@"cjsj"];
                    [dict setValue:dateStr forKey:@"scsj"];
                    [dict setValue:[ud objectForKey:@"name"] forKey:@"scr"];
                    [dict setValue:[lArr objectAtIndex:0] forKey:@"ptx"];
                    [dict setValue:[lArr objectAtIndex:1] forKey:@"pty"];
                    [dict setValue:del.structureStyle forKey:@"type"];
                    [dict setValue:btn.titleLabel.text forKey:@"codeAlpha"];
                    [dict setValue:dropNumTf.text forKey:@"codeNum"];
                    [dict setValue:data forKey:@"snapPhoto"];
                    
                    res = [db executeUpdate:@"update table_drop set code=?,name=?,pos=?,cjsj=?,scsj=?,scr=?,ptx=?,pty=?,type=?,codeAlpha=?,codeNum=?,snapPhoto=? where cjsj=?",
                           [dict objectForKey:@"code"],
                           [dict objectForKey:@"name"],
                           [dict objectForKey:@"pos"],
                           [dict objectForKey:@"cjsj"],
                           [dict objectForKey:@"scsj"],
                           [dict objectForKey:@"scr"],
                           [dict objectForKey:@"ptx"],
                           [dict objectForKey:@"pty"],
                           [dict objectForKey:@"type"],
                           [dict objectForKey:@"codeAlpha"],
                           [dict objectForKey:@"codeNum"],
                           [dict objectForKey:@"snapPhoto"],
                           [dict objectForKey:@"cjsj"]];
                        
                    }
                else
                {
                    
                    
                    [dict setValue:[NSString stringWithFormat:@"%@%@",btn.titleLabel.text,dropNumTf.text] forKey:@"code"];
                    [dict setValue:nameTf.text forKey:@"name"];
                    [dict setValue:numTf.text forKey:@"pos"];
                    [dict setValue:collectionDate forKey:@"cjsj"];
                    [dict setValue:dateStr forKey:@"scsj"];
                    [dict setValue:[ud objectForKey:@"name"] forKey:@"scr"];
                    [dict setValue:[lArr objectAtIndex:0] forKey:@"ptx"];
                    [dict setValue:[lArr objectAtIndex:1] forKey:@"pty"];
                    [dict setValue:del.structureStyle forKey:@"type"];
                    [dict setValue:btn.titleLabel.text forKey:@"codeAlpha"];
                    [dict setValue:dropNumTf.text forKey:@"codeNum"];
                    [dict setValue:data forKey:@"snapPhoto"];
                    
                    res = [db executeUpdate:@"insert into table_drop values(?,?,?,?,?,?,?,?,?,?,?,?)",
                           [dict objectForKey:@"code"],
                           [dict objectForKey:@"name"],
                           [dict objectForKey:@"pos"],
                           [dict objectForKey:@"cjsj"],
                           [dict objectForKey:@"scsj"],
                           [dict objectForKey:@"scr"],
                           [dict objectForKey:@"ptx"],
                           [dict objectForKey:@"pty"],
                           [dict objectForKey:@"type"],
                           [dict objectForKey:@"codeAlpha"],
                           [dict objectForKey:@"codeNum"],
                           [dict objectForKey:@"snapPhoto"]];
                    
                    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    del.dropSaveCount += 1;
                    
                }
                
                if(res)
                {
                    NSLog(@"insert success!");
                    
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    [db close];
                    
                }
                else
                {
                    NSLog(@"insert failed!");
                    [db close];
                    return;
                }

            }
            else
            {
                
                [db close];
                return;
            }
        }
    }
    
}
-(void)saveLineAction
{
    
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if(![dropNumTf.text isEqualToString:@""] && ![routeNameTf.text isEqualToString:@""] && ![routeStyleTf.text isEqualToString:@""] && ![rodeStyleTf.text isEqualToString:@""]&& ![beginTf.text isEqualToString:@""] && ![endTf.text isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] objectForKey:@"name"])
    {
        
        [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.path];
        if([db open])
        {
            
            UILabel *label = (UILabel *)[backSv viewWithTag:1000];
            UIButton *btn = (UIButton *)[label viewWithTag:12];
            
            BOOL res = [db executeUpdate:@"create table if not exists table_line(roadcode,roadname,ldxz,ldlx,qdzh,zdzh,cjsj,scsj,scr,lxlc,qdjd,qdwd,zdjd,zdwd,codeAlpha,codeNum)"];
            if(res)
            {
                
                
                dict = [[NSMutableDictionary alloc]initWithCapacity:0];
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSArray *lArr = [NSArray arrayWithArray:[ud objectForKey:@"locationArray"]];
                
                if([lArr count]<5)
                {
                    
                    lArr = [NSArray arrayWithArray:[ud objectForKey:@"relocationArray"]];
                    
                }
                
                FMResultSet *set = [db executeQuery:@"select *from table_line where cjsj=?",[ud objectForKey:@"cjsj"]];
                if ([set next])
                {
                    
                    [dict setValue:[NSString stringWithFormat:@"%@%@",btn.titleLabel.text,dropNumTf.text] forKey:@"roadcode"];
                    [dict setValue:routeNameTf.text forKey:@"roadname"];
                    [dict setValue:routeStyleTf.text forKey:@"ldxz"];
                    [dict setValue:rodeStyleTf.text forKey:@"ldlx"];
                    [dict setValue:beginTf.text forKey:@"qdzh"];
                    [dict setValue:endTf.text forKey:@"zdzh"];
                    [dict setValue:[ud objectForKey:@"cjsj"] forKey:@"cjsj"];
                    [dict setValue:dateStr forKey:@"scsj"];
                    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] forKey:@"scr"];
                    [dict setValue:[lArr objectAtIndex:[lArr count]-1] forKey:@"lxlc"];
                    [dict setValue:[lArr objectAtIndex:0] forKey:@"qdjd"];
                    [dict setValue:[lArr objectAtIndex:1] forKey:@"qdwd"];
                    [dict setValue:[lArr objectAtIndex:[lArr count]-3] forKey:@"zdjd"];
                    [dict setValue:[lArr objectAtIndex:[lArr count]-2] forKey:@"zdwd"];
                    [dict setValue:btn.titleLabel.text forKey:@"codeAlpha"];
                    [dict setValue:dropNumTf.text forKey:@"codeNum"];
                                        
                    
                    res = [db executeUpdate:@"update table_line set roadcode=?,roadname=?,ldxz=?,ldlx=?,qdzh=?,zdzh=?,cjsj=?,scsj=?,scr=?,lxlc=?,qdjd=?,qdwd=?,zdjd=?,zdwd=?,codeAlpha=?,codeNum=? where cjsj=?",
                           [dict objectForKey:@"roadcode"],
                           [dict objectForKey:@"roadname"],
                           [dict objectForKey:@"ldxz"],
                           [dict objectForKey:@"ldlx"],
                           [dict objectForKey:@"qdzh"],
                           [dict objectForKey:@"zdzh"],
                           [dict objectForKey:@"cjsj"],
                           [dict objectForKey:@"scsj"],
                           [dict objectForKey:@"scr"],
                           [dict objectForKey:@"lxlc"],
                           [dict objectForKey:@"qdjd"],
                           [dict objectForKey:@"qdwd"],
                           [dict objectForKey:@"zdjd"],
                           [dict objectForKey:@"zdwd"],
                           [dict objectForKey:@"codeAlpha"],
                           [dict objectForKey:@"codeNum"],
                           [dict objectForKey:@"cjsj"]];
                    
                    
                }
                else
                {
                    
                    [dict setValue:[NSString stringWithFormat:@"%@%@",btn.titleLabel.text,dropNumTf.text] forKey:@"roadcode"];
                    [dict setValue:routeNameTf.text forKey:@"roadname"];
                    [dict setValue:routeStyleTf.text forKey:@"ldxz"];
                    [dict setValue:rodeStyleTf.text forKey:@"ldlx"];
                    [dict setValue:beginTf.text forKey:@"qdzh"];
                    [dict setValue:endTf.text forKey:@"zdzh"];
                    [dict setValue:collectionDate forKey:@"cjsj"];
                    [dict setValue:dateStr forKey:@"scsj"];
                    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] forKey:@"scr"];
                    [dict setValue:[lArr objectAtIndex:[lArr count]-1] forKey:@"lxlc"];
                    [dict setValue:[lArr objectAtIndex:0] forKey:@"qdjd"];
                    [dict setValue:[lArr objectAtIndex:1] forKey:@"qdwd"];
                    [dict setValue:[lArr objectAtIndex:[lArr count]-3] forKey:@"zdjd"];
                    [dict setValue:[lArr objectAtIndex:[lArr count]-2] forKey:@"zdwd"];
                    [dict setValue:btn.titleLabel.text forKey:@"codeAlpha"];
                    [dict setValue:dropNumTf.text forKey:@"codeNum"];
                    
                    res = [db executeUpdate:@"insert into table_line values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                           [dict objectForKey:@"roadcode"],
                           [dict objectForKey:@"roadname"],
                           [dict objectForKey:@"ldxz"],
                           [dict objectForKey:@"ldlx"],
                           [dict objectForKey:@"qdzh"],
                           [dict objectForKey:@"zdzh"],
                           [dict objectForKey:@"cjsj"],
                           [dict objectForKey:@"scsj"],
                           [dict objectForKey:@"scr"],
                           [dict objectForKey:@"lxlc"],
                           [dict objectForKey:@"qdjd"],
                           [dict objectForKey:@"qdwd"],
                           [dict objectForKey:@"zdjd"],
                           [dict objectForKey:@"zdwd"],
                           [dict objectForKey:@"codeAlpha"],
                           [dict objectForKey:@"codeNum"]];
                    
                }
                
                if(res)
                {
                    NSLog(@"insert success!");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"insert failed!");
                    [db close];
                    return;
                }
            }
            else
            {
                
                [db close];
                return;
            }
            
        }

    }
    
    
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



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == dropNumTf)
    {
        
        dropNumTf.text = nil;
        
    }
    if(textField == routeNameTf)
    {
        
        routeNameTf.text = nil;
        
    }
    if(textField == nameTf)
    {
        
        nameTf.text = nil;
        
    }
    if(textField == numTf)
    {
        
        [numTf resignFirstResponder];
        StakeViewController *svc = [[StakeViewController alloc]init];
        svc.hidesBottomBarWhenPushed = YES;
        svc.contentStr = @"centerStake";
        [self.navigationController pushViewController:svc animated:YES];
        svc.hidesBottomBarWhenPushed = NO;
        
    }
    if(textField == rodeStyleTf)
    {
        
        [rodeStyleTf resignFirstResponder];
        RodeStyleViewController *rsvc = [[RodeStyleViewController alloc]init];
        rsvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rsvc animated:YES];
        rsvc.hidesBottomBarWhenPushed = NO;
        
    }
    if(textField == beginTf)
    {
        
        [beginTf resignFirstResponder];
        StakeViewController *svc = [[StakeViewController alloc]init];
        svc.hidesBottomBarWhenPushed = YES;
        svc.contentStr = @"beginStake";
        [self.navigationController pushViewController:svc animated:YES];
        svc.hidesBottomBarWhenPushed = NO;
        
    }
    if(textField == endTf)
    {

        [endTf resignFirstResponder];
        StakeViewController *svc = [[StakeViewController alloc]init];
        svc.hidesBottomBarWhenPushed = YES;
        svc.contentStr = @"endStake";
        [self.navigationController pushViewController:svc animated:YES];
        svc.hidesBottomBarWhenPushed = NO;
        
    }
    if(textField == routeStyleTf)
    {
        
        [routeStyleTf resignFirstResponder];
        CollectionItemPresetViewController *cipvc = [[CollectionItemPresetViewController alloc]init];
        cipvc.hidesBottomBarWhenPushed = YES;
        cipvc.titleStr = @"采集项";
        [self.navigationController pushViewController:cipvc animated:YES];
        cipvc.hidesBottomBarWhenPushed = NO;

    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(textField == dropNumTf)
    {
        
        del.dropNumTf = dropNumTf.text;
        
    }
    if(textField == nameTf)
    {

        del.dropNameTf = nameTf.text;
        
    }
    if(textField == routeNameTf)
    {
        
        del.dropNameTf = routeNameTf.text;
        
    }

}
-(void)controlAction
{
    
    [dropNumTf resignFirstResponder];
    [nameTf resignFirstResponder];
    [numTf resignFirstResponder];
    [routeNameTf resignFirstResponder];
    [routeStyleTf resignFirstResponder];
    [beginTf resignFirstResponder];
    [endTf resignFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    for(UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    
    
    [self initInterface];
    
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if(numTf)
    {
        numTf.text = [del.dropArray objectAtIndex:2]?[del.dropArray objectAtIndex:2]:del.centerStake;
        del.centerStake = numTf.text;
        
    }
    if(rodeStyleTf)
    {
        
        rodeStyleTf.text = [del.lineArray objectAtIndex:3]?[del.lineArray objectAtIndex:3]:del.rodeStyleTf;
        del.rodeStyleTf = rodeStyleTf.text;
        
    }
    if(beginTf)
    {
        beginTf.text = [del.lineArray objectAtIndex:4]?[del.lineArray objectAtIndex:4]:del.beginStake;
        del.beginStake = beginTf.text;
        
    }
    if(endTf)
    {
        endTf.text = [del.lineArray objectAtIndex:5]?[del.lineArray objectAtIndex:5]:del.endStake;
        del.endStake = endTf.text;
        
    }
    if(routeStyleTf)
    {
        routeStyleTf.text = [del.lineArray objectAtIndex:2]?[del.lineArray objectAtIndex:2]:del.structureStyle;
        del.structureStyle = routeStyleTf.text;
        
    }
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    del.dropArray = nil;
    del.lineArray = nil;
    
}

-(void)saveAndUploadData
{
    
    NSString *uploadStr = nil;
    ASIHTTPRequest *request = nil;
    
    if([contentStr isEqualToString:@"点状数据"])
    {
        [self saveDropAction];
        
        uploadStr = [NSString stringWithFormat:@"%@/gps/addPoint",requestHeader];
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:uploadStr]];
        [request setValuesForKeysWithDictionary:dict];
        
        
    }
    if([contentStr isEqualToString:@"线状数据"])
    {
        [self saveLineAction];
        
        uploadStr = [NSString stringWithFormat:@"%@/gps/addLine",requestHeader];
        [request setValuesForKeysWithDictionary:dict];
        
    }
    
    request.delegate = self;
    [request startAsynchronous];
    

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
