//
//  DataCollectViewController.m
//  路网采集
//
//  Created by Charles Leo on 14/10/24.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "DataCollectViewController.h"
#import "DateFormmter.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "Geometry.h"
#import "TaskModel.h"
#import "NSString+JSONDictionary.h"


//struct MPoint{
//    double x;
//    double y;
//};
//enum wkbByteOrder
//{
//    wkbXDR = 0,             // Big Endian
//    wkbNDR = 1           // Little Endian
//};
//typedef struct {
//    unsigned char  byteOrder;
//    UInt32 wkbType;
//    struct MPoint point;
//}WKBPoint;




@interface DataCollectViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate>
{
        NSMutableDictionary *dict;
        MBProgressHUD * HUD;
}
@property (strong,nonatomic) UIImageView * mImageView;
//@property (strong,nonatomic) NSString * path;
@end

@implementation DataCollectViewController

@synthesize mModel,mImageView;
-(id)initWithData:(TaskModel *)model
{
    if (self = [super init]) {
        self.mModel = model;
    }
    return self;
}
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
//    self.path = NSHomeDirectory();
//    self.path = [path stringByAppendingPathComponent:@"/Documents/data.db"];
//    NSLog(@"self.path:%@",self.path);
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self.leftBtn addTarget:self action:@selector(btnBack) forControlEvents:UIControlEventTouchUpInside];
    [self makeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)btnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeView
{
    //图标
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 112/2, 112/2)];
    imageView.image =[UIImage imageNamed:self.mModel.mLayer];
    [self.view addSubview:imageView];
    
    //标题
    UILabel * title =[[UILabel alloc]initWithFrame:CGRectMake(76, 10, 60, 112/2)];
    title.text = @"当前采集";
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:title];
    
    //分割线
    UILabel * lineOne = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height + 20, WIDTH, 1)];
    lineOne.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineOne];
    
    //截止日期
    UILabel * deadline = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x + title.frame.size.width + 10, 10, 120, 112/2)];
    NSLog(@"date is %@",self.mModel.mDeadLine);
    deadline.text =[NSString stringWithFormat:@"完成时间:%@",[DateFormmter intervalToDateString:self.mModel.mDeadLine andFormaterString:@"MM-dd-yyyy"]];
    deadline.backgroundColor = [UIColor clearColor];
    deadline.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:deadline];
    
    //要素名称
    UILabel * ysName = [[UILabel alloc]initWithFrame:CGRectMake(50, 40 + 112/2, WIDTH - 50, 30)];
    ysName.text =[NSString stringWithFormat:@"要素名称:%@" ,self.mModel.mName];
    ysName.backgroundColor = [UIColor clearColor];
    ysName.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:ysName];
    
    //要素代码
    UILabel * ysCode = [[UILabel alloc]initWithFrame:CGRectMake(50, 30 + 112/2 + 30, WIDTH - 50, 112/2)];
    ysCode.text =[NSString stringWithFormat:@"要素代码:%@", self.mModel.mCode];
    ysCode.backgroundColor = [UIColor clearColor];
    ysCode.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:ysCode];
    
    //中心桩号
    UILabel * zxCode = [[UILabel alloc]initWithFrame:CGRectMake(50, 30 +112/2 + 60, WIDTH - 50, 112/2)];
    zxCode.text =[NSString stringWithFormat:@"中心桩号:%@", self.mModel.mPos];
    zxCode.backgroundColor = [UIColor clearColor];
    zxCode.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:zxCode];
    
    //采集类型
    UILabel * cjType = [[UILabel alloc]initWithFrame:CGRectMake(50, 30 +112/2 + 90, WIDTH - 50, 112/2)];
    cjType.text =[NSString stringWithFormat:@"采集类型:%@", self.mModel.mLayer];
    cjType.backgroundColor = [UIColor clearColor];
    cjType.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:cjType];
    //中间文本
    UILabel * text =[[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 55)/2, cjType.frame.origin.y +cjType.frame.size.height, 55, 20)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:12.0f];
    text.textAlignment = NSTextAlignmentCenter;
    text.text = @"图片信息";
    [self.view addSubview:text];
    
    //左边分割线
    UILabel * lineLeft =[[UILabel alloc]initWithFrame:CGRectMake(0,cjType.frame.origin.y + cjType.frame.size.height + 10, (WIDTH-55)/2, 1)];
    lineLeft.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineLeft];
    //右边分割线
    UILabel * lineRight =[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-55)/2 + 55,cjType.frame.origin.y+ cjType.frame.size.height + 10, WIDTH, 1)];
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
    
    
    self.mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, cjType.frame.origin.y+ cjType.frame.size.height + 30, 80, 100)];
    self.mImageView.backgroundColor = [UIColor grayColor];
    self.mImageView.hidden = YES;
    [self.view addSubview:self.mImageView];
    if (self.mModel.mImageData !=nil) {
        NSLog(@"data is not null");
        UIImage * image = [UIImage imageWithData:self.mModel.mImageData];
        self.mImageView.image = image;
        self.mImageView.hidden = NO;
    }
    
    
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
        /*
         这段代码有问题,虽然实现了空间数据,但是会造成系统崩溃
         */
       
        NSDate * collectDate = [NSDate date];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString * dateString = [dateFormatter stringFromDate:collectDate];
        NSLog(@"dateSting is %@",dateString);
        self.mModel.mState = @"2";
        self.mModel.mGatherTime = dateString;
        AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDel.currentTask = nil;
        appDel.isSelect = NO;
        NSArray * byteArray = nil;
        if ([appDel.collectType isEqualToString:@"line"]) {
            NSArray * localPoint =[[NSArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"locationArray"]];
            byteArray = [Geometry getShapeListDataWithArray:localPoint andLength:localPoint.count];
//            NSLog(@"byteArray 1 is %@",[byteArray objectAtIndex:0]);
        }
        else
        {
            byteArray = [Geometry getShapDataWithPtx:self.mModel.mPtx Pty:self.mModel.mPty];
            [dict setValue:[NSNumber numberWithFloat:self.mModel.mPtx] forKey:@"ptx"];
            [dict setValue:[NSNumber numberWithFloat: self.mModel.mPty] forKey:@"pty"];
        }
        appDel.collectType = @"";
        
        NSString * uuid = [self uuid];
        NSLog(@"uuid is %@",uuid);
       
        [dict setValue:self.mModel.mAuditState forKey:@"auditState"];
        [dict setValue:self.mModel.mCode forKey:@"code"];
        [dict setValue:self.mModel.mDeadLine forKey:@"deadLine"];
        [dict setValue:self.mModel.mType forKey:@"type"];
        [dict setValue:self.mModel.mGatherTime forKey:@"gatherTime"];
        [dict setValue:self.mModel.mGather forKey:@"gatherer"];
        [dict setValue:self.mModel.mId forKey:@"id"];
        [dict setValue:self.mModel.mLayer forKey:@"layer"];
        [dict setValue:self.mModel.mLineCode forKey:@"lineCode"];
        [dict setValue:self.mModel.mLineName forKey:@"lineName"];
        [dict setValue:self.mModel.mName forKey:@"name"];
        [dict setValue:self.mModel.mState forKey:@"state"];
        [dict setValue:byteArray forKey:@"shape"];
        [dict setValue:self.mModel.mPos forKey:@"pos"];
        [dict setValue:[NSNumber numberWithDouble:0.0] forKey:@"startPos"];
        [dict setValue:[NSNumber numberWithDouble:0.0] forKey:@"endPos"];
        
        //将二进制数据转换为数组
        Byte * imageArray = (Byte *)[self.mModel.mImageData bytes];
        NSMutableArray * imageData = [[NSMutableArray alloc]initWithCapacity:0];
        dispatch_async(dispatch_get_current_queue(), ^{
            for ( int i = 0; i<[self.mModel.mImageData length]; i++) {
                [imageData addObject:[NSNumber numberWithInteger:imageArray[i]]];
            }
            if (imageData.count > 0) {
                [dict setValue:imageData forKey:@"image"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray * array = [NSArray arrayWithObject:dict];
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
                NSString * jsonString  = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                NSLog(@"jsonString is %@",jsonString);
                NSString * urlString = [NSString stringWithFormat:@"%@plan/upload",requestHeader];
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
    NSLog(@"OK");
    NSString * data = [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"data is %@",data);
    NSDictionary * dictData = [data JSONValue];
   // NSLog(@"dictData is %@",dictData);
    if ([dictData isKindOfClass:[NSDictionary class]])
    {
        AppDelegate * appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (appDel.isLinePoint == YES)
        {
            appDel.dropSaveCount+=1;
        }
        [HUD hide:YES];
        [[iToast makeText:@"上传成功"]show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [HUD hide:YES];
        [[iToast makeText:@"上传失败"]show];
    }
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

@end
