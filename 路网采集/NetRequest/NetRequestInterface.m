//
//  NetRequestInterface.m
//  MyTaxi-V1.0.1
//
//  Created by Grace Leo on 13-10-31.
//  Copyright (c) 2013年 YaHuiLiu. All rights reserved.
//

#import "NetRequestInterface.h"

@implementation NetRequestInterface
/*
 关于选择cachePolicy
 1、NSURLRequestUseProtocolCachePolicy NSURLRequest默认的cache policy，使用Protocol协议定义。
 2、NSURLRequestReloadIgnoringCacheData 忽略缓存直接从原始地址下载。
 3、NSURLRequestReturnCacheDataElseLoad 只有在cache中不存在data时才从原始地址下载。
 4、NSURLRequestReturnCacheDataDontLoad 只使用cache数据，如果不存在cache，请求失败；用于没有建立网络连接离线模式；
 5、NSURLRequestReloadIgnoringLocalAndRemoteCacheData：忽略本地和远程的缓存数据，直接从原始地址下载，与NSURLRequestReloadIgnoringCacheData类似。
 6、NSURLRequestReloadRevalidatingCacheData:验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据。
 */
-(void)basicRequest:(NSString *)strURL
{
    
    url = [NSURL URLWithString:strURL];
    /*
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    //设置缓存的大小
    [urlCache setMemoryCapacity:1*1024*1024];
    //创建一个请求
    urlRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    //从请求中获取缓存输出
    NSCachedURLResponse * response = [urlCache cachedResponseForRequest:urlRequest];
    //判断是否有缓存
    if (response !=Nil)
    {
        NSLog(@"如果有缓存输出,从缓存中取数据");
        [urlRequest setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    */
    
    //忽略缓存
    urlRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [urlRequest setHTTPMethod:@"GET"];
    conn = [[NSURLConnection alloc]initWithRequest:urlRequest delegate:self startImmediately:YES];
    if (muData)
    {
//        [muData release];
        muData = nil;
    }
    muData = [[NSMutableData alloc]init];
    self.receiveData = nil;
   
}
-(void)cancelBasicRequest
{
    NSLog(@"取消请求!");
    [conn cancel];
}
#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"将接收输出");
}
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    NSLog(@"即将发送请求");
    return request;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [muData appendData:data];
    NSLog(@"接收数据");
    NSLog(@"数据长度为 = %lu",(unsigned long)[data length]);
}
-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    NSLog(@"将缓存输出");
    return cachedResponse;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * strData = [[NSString alloc]initWithBytes:[muData bytes] length:[muData length] encoding:NSUTF8StringEncoding];
    self.receiveData = strData;
//    [strData release];
    completeBlock();
    NSLog(@"请求完成");
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    failBlock();
    NSLog(@"请求失败!");
}

-(void)setCompleteBlock:(BasicBlock)cBlock
{
//    [completeBlock release];
    completeBlock = nil;
    completeBlock = [cBlock copy];
}
-(void)setFailBlock:(BasicBlock)fBlock
{
//    [failBlock release];
    failBlock = nil;
    failBlock = [fBlock copy];
}
-(void)dealloc
{
//    [urlRequest release];
//    [conn release];
    
//    [completeBlock release];
//    [failBlock release];
    urlRequest = nil;
    conn = nil;
    completeBlock = nil;
    failBlock = nil;
    self.receiveData = nil;
//    [super dealloc];
}
@end
