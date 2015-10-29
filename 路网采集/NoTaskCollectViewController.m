//
//  NoTaskCollectViewController.m
//  路网采集
//
//  Created by Charles Leo on 14/10/30.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "NoTaskCollectViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

#import "TaskEvent.h"
#import "Geometry.h"

@interface NoTaskCollectViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
     NSMutableDictionary *dict;
    MBProgressHUD * HUD;
}
@property (strong,nonatomic) UITextField * mRouteText;
@property (strong,nonatomic) UITextField * mYaoSuText;
@property (strong,nonatomic) UITextField * mCenterText;
@property (strong,nonatomic) UIImageView * mImageView;
@end

@implementation NoTaskCollectViewController
@synthesize mModel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)btnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.leftBtn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.text = @"数据采集";
    [self initView];
}
//收回键盘的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.mRouteText resignFirstResponder];
    [self.mYaoSuText resignFirstResponder];
    [self.mCenterText resignFirstResponder];
}
-(void)initView
{
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 80, 64)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"路线名称:";
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:nameLabel];
    
    self.mRouteText = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, 27, WIDTH - nameLabel.frame.size.width - 20, 50)];
    self.mRouteText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.mRouteText];
    
    UILabel * lineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, nameLabel.frame.origin.y + nameLabel.frame.size.height, WIDTH, 1)];
    lineOne.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineOne];
    
    UILabel * yaosuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineOne.frame.origin.y + 1, 80, 64)];
    yaosuLabel.backgroundColor = [UIColor clearColor];
    yaosuLabel.text = @"要素名称:";
    yaosuLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:yaosuLabel];
    
    self.mYaoSuText = [[UITextField alloc]initWithFrame:CGRectMake(yaosuLabel.frame.origin.x + yaosuLabel.frame.size.width, lineOne.frame.origin.y + 1+7, WIDTH - nameLabel.frame.size.width - 20, 50)];
    self.mYaoSuText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.mYaoSuText];
    
    UILabel * lineTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, yaosuLabel.frame.origin.y + yaosuLabel.frame.size.height, WIDTH, 1)];
    lineTwo.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineTwo];
    
    UILabel * centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, lineTwo.frame.origin.y + 1, 80, 64)];
    centerLabel.backgroundColor = [UIColor clearColor];
    centerLabel.text = @"中心桩号:";
    centerLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:centerLabel];
    self.mCenterText = [[UITextField alloc]initWithFrame:CGRectMake(yaosuLabel.frame.origin.x + yaosuLabel.frame.size.width, lineTwo.frame.origin.y + 1+7, WIDTH - nameLabel.frame.size.width - 20, 50)];
    self.mCenterText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.mCenterText];
    
    
    //中间文本
    UILabel * text =[[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 55)/2, centerLabel.frame.origin.y +centerLabel.frame.size.height, 55, 20)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:12.0f];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"图片信息";
    [self.view addSubview:text];
    
    //左边分割线
    UILabel * lineLeft =[[UILabel alloc]initWithFrame:CGRectMake(0,centerLabel.frame.origin.y + centerLabel.frame.size.height + 10, (WIDTH-55)/2, 1)];
    lineLeft.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineLeft];
    //右边分割线
    UILabel * lineRight =[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-55)/2 + 55,centerLabel.frame.origin.y+ centerLabel.frame.size.height + 10, WIDTH, 1)];
    lineRight.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineRight];
    
    //    //路线代码
    //    UILabel * lineCode = [[UILabel alloc]initWithFrame:CGRectMake(50, 60 + 112/2 + 120, WIDTH - 50, 112/2)];
    //    lineCode.text =[NSString stringWithFormat:@"路线代码:%@", self.mModel.mLineCode];
    //    lineCode.backgroundColor = [UIColor clearColor];
    //    lineCode.font = [UIFont systemFontOfSize:12.0f];
    //    [self.view addSubview:lineCode];
    //
    //    //路线名称
    UILabel * lineName = [[UILabel alloc]initWithFrame:CGRectMake(0, 60 + 112/2 + 150 , WIDTH , 112/2)];
    lineName.text =[NSString stringWithFormat:@"暂无"];
    lineName.backgroundColor = [UIColor clearColor];
    lineName.textAlignment = NSTextAlignmentCenter;
    lineName.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:lineName];
    
    
    self.mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, centerLabel.frame.origin.y+ centerLabel.frame.size.height + 30, 80, 100)];
    self.mImageView.backgroundColor = [UIColor grayColor];
    self.mImageView.hidden = YES;
    [self.view addSubview:self.mImageView];
//    if (self.mModel.mImageData !=nil) {
//        NSLog(@"data is not null");
//        UIImage * image = [UIImage imageWithData:self.mModel.mImageData];
//        self.mImageView.image = image;
//        self.mImageView.hidden = NO;
//    }
//    
    
    UIButton * btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTakePhoto.frame = CGRectMake(20, self.mImageView.frame.origin.y + self.mImageView.frame.size.height + 20, 230/2, 75/2);
    [btnTakePhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [btnTakePhoto setBackgroundImage:[UIImage imageNamed:@"btn_public"] forState:UIControlStateNormal];
    [btnTakePhoto setBackgroundImage:[UIImage imageNamed:@"btn_public_down"] forState:UIControlStateHighlighted];
    [btnTakePhoto addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnTakePhoto.tag = 300;
    [self.view addSubview:btnTakePhoto];
    
    UIButton * btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCollect.frame = CGRectMake((WIDTH - 20 -230/2), self.mImageView.frame.origin.y + self.mImageView.frame.size.height + 20, 230/2, 75/2);
    [btnCollect setTitle:@"保存并上传" forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:[UIImage imageNamed:@"btn_public"] forState:UIControlStateNormal];
    [btnCollect setBackgroundImage:[UIImage imageNamed:@"btn_public_down"] forState:UIControlStateHighlighted];
    [btnCollect addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnCollect.tag = 301;
    [self.view addSubview:btnCollect];
    self.mModel = [[TaskModel alloc]init];
    
}
-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 300)
    {
        UIImagePickerController *pc = [[UIImagePickerController alloc]init];
        pc.sourceType = UIImagePickerControllerSourceTypeCamera;
        pc.delegate = self;
        [self presentModalViewController:pc animated:YES];
    }
    else if(sender.tag == 301)
    {
        dict = [[NSMutableDictionary alloc]initWithCapacity:0];
        NSLog(@"%@",self.mModel.mAuditState);
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"正在上传...";
        self.mModel.mPtx = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ptx"] doubleValue];
        self.mModel.mPty = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pty"] doubleValue];
        
        NSLog(@"task ptx is %lf pty is %lf",self.mModel.mPtx,self.mModel.mPty);
        
        NSArray * byteArray = [Geometry getShapDataWithPtx:self.mModel.mPtx Pty:self.mModel.mPty];
        NSDate * collectDate = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString * dateString = [dateFormatter stringFromDate:collectDate];
        NSLog(@"dateSting is %@",dateString);
        self.mModel.mGatherTime = dateString;
        self.mModel.mState = @"2";
        NSString * uuid = [self uuid];
        NSLog(@"uuid is %@",uuid);
        self.mModel.mId = uuid;
        AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDel.currentTask = nil;
        appDel.isSelect = NO;
        [dict setValue:@"0" forKey:@"auditState"];
        [dict setValue:self.mModel.mCode forKey:@"code"];
        [dict setValue:self.mModel.mDeadLine forKey:@"deadLine"];
        [dict setValue:self.mModel.mType forKey:@"type"];
        [dict setValue:dateString forKey:@"gatherTime"];
        [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] forKey:@"gather"];
        [dict setValue:self.mModel.mId forKey:@"id"];
        [dict setValue:self.mModel.mLineCode forKey:@"lineCode"];
        [dict setValue:self.mRouteText.text forKey:@"lineName"];
        [dict setValue:self.mYaoSuText.text forKey:@"name"];
        [dict setValue:@"2" forKey:@"state"];
        [dict setValue:byteArray forKey:@"shape"];
        [dict setValue:[NSNumber numberWithDouble:self.mModel.mPtx] forKey:@"ptx"];
        [dict setValue:[NSNumber numberWithDouble:self.mModel.mPty] forKey:@"pty"];
        [dict setValue:self.mModel.mPos forKey:@"pos"];
        [dict setValue:self.mModel.mStartPos forKey:@"startPos"];
        //将二进制数据转换为数组
        Byte * imageArray = (Byte *)[self.mModel.mImageData bytes];
        NSMutableArray * imageData = [[NSMutableArray alloc]initWithCapacity:0];
        dispatch_async(dispatch_get_current_queue(), ^{
            
            for ( int i = 0; i<[self.mModel.mImageData length]; i++) {
                [imageData addObject:[NSNumber numberWithInteger:imageArray[i]]];
            }
            [dict setValue:imageData forKey:@"image"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray * array = [NSArray arrayWithObject:dict];
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
                NSString * jsonString  = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"jsonString is %@",jsonString);
                NSString * urlString = [NSString stringWithFormat:@"%@/plan/upload",requestHeader];
//                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
//                //设置表单提交项
//                [request setPostValue:jsonString forKey:@"json"];
//                [request setDelegate:self];
//                [request setDidFinishSelector:@selector(GetResult:)];
//                [request setDidFailSelector:@selector(GetErr:)];
//                [request startAsynchronous];
//                
                
                NSMutableData * tempJsonData = [NSMutableData dataWithData:jsonData];
                NSURL * url = [NSURL URLWithString:urlString];
                NSLog(@"url is %@",url);
                //上传json
                ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
                [request addRequestHeader:@"Accept" value:@"application/json"];
                [request setRequestMethod:@"POST"];
                [request setPostBody:tempJsonData];
                [request startSynchronous];
                NSError *error1 = [request error];
                if (!error1) {
                    NSString *response = [request responseString];
                    NSLog(@"Test：%@",response);
                    [HUD hide:YES];
                    [[iToast makeText:@"上传成功"]show];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }

            });
        });
    }
}
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result ;
}

- (void)GetResult:(ASIHTTPRequest *)request
{
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appDel.isLinePoint == YES) {
        appDel.dropSaveCount+=1;
    }
    NSLog(@"OK");
    [HUD hide:YES];
    [[iToast makeText:@"上传成功"]show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//连接错误调用这个函数
- (void) GetErr:(ASIHTTPRequest *)request
{
    NSLog(@"Failed");
    [HUD hide:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //设置image的尺寸
    CGSize imagesize = image.size;
    imagesize.height =self.mImageView.frame.size.height;
    imagesize.width =self.mImageView.frame.size.width;
    //对图片大小进行压缩--
    image = [self imageWithImage:image scaledToSize:imagesize];
    //    NSData *imageData = UIImageJPEGRepresentation(image,0.00001);
    NSData  *data  = UIImageJPEGRepresentation(image, 0.00001);
    /*
     更新本地数据库
     */
    AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    dispatch_async(dispatch_get_current_queue(), ^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSManagedObjectContext * context = appDel.managedObjetContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskEvent" inManagedObjectContext:context];
        [request setEntity:entity];
        //[request setReturnsObjectsAsFaults:NO];
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"mId = %@", self.mModel.mId];
        [request setPredicate:predicate];
        NSError * error;
        NSArray *dataArray = [context executeFetchRequest:request error:&error];
        if (error!=nil) {
            NSLog(@"error is %@",error);
        }
        if ([dataArray count] > 0) {
            TaskEvent  * model = [dataArray objectAtIndex:0];
            model.mImageData = data;
            BOOL result = [appDel.managedObjetContext save:nil];
            if (result)
            {
                NSLog(@"编辑gg 成功");
            }
            else
            {
                NSLog(@"编辑失败");
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //上传服务器用
            self.mModel.mImageData = data;
            self.mImageView.image = nil;
            self.mImageView.image = image;
            self.mImageView.hidden = NO;
        });
    });
    self.mImageView.image = image;
    self.mImageView.hidden = NO;
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
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
