//
//  NetRequestInterface.h
//  MyTaxi-V1.0.1
//
//  Created by Grace Leo on 13-10-31.
//  Copyright (c) 2013年 YaHuiLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
typedef void(^BasicBlock) (void);
@interface NetRequestInterface : UIView <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSURL * url;                        //url地址
    NSMutableURLRequest * urlRequest;   //url请求
    NSURLConnection * conn;             //url连接
    NSMutableData * muData;             //接收的二进制数据
    
    BasicBlock completeBlock;           //完成块
    BasicBlock failBlock;               //失败块
}
@property (copy,nonatomic) NSString * receiveData;//把接收的数据转化为字符串
@property (strong,nonatomic) MBProgressHUD * HUD;
//设置完成的block和失败的
-(void)setCompleteBlock:(BasicBlock)cBlock;
-(void)setFailBlock:(BasicBlock)fBlock;
//一个简单的请求例子
-(void)basicRequest:(NSString *)strURL;
//取消请求
-(void)cancelBasicRequest;
@end
