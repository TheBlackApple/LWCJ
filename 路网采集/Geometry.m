//
//  Geometry.m
//  路网采集
//
//  Created by Charles Leo on 14/10/28.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "Geometry.h"
#import "BMapKit.h"

/* 转换8字节整型：*/
typedef unsigned long long UINT64;
#define ntohll(x) ( ((UINT64)x & 0xff00000000000000LL)>>56 | ((UINT64)x & 0x00ff000000000000LL)>>40 | ((UINT64)x & 0x0000ff0000000000LL)>>24 | ((UINT64)x & 0x000000ff00000000LL)>>8 | ((UINT64)x & 0x00000000ff000000LL)<<8 | ((UINT64)x & 0x0000000000ff0000LL)<<24 | ((UINT64)x & 0x000000000000ff00LL)<<40 | ((UINT64)x & 0x00000000000000ffLL)<<56 )
/* 为了使问题清晰，先定义个函数 */
double SwapDoubleEndian(double* pdVal)
{
    UINT64 llVal = ntohll(*((UINT64*)pdVal));
    
    return *((double*)&llVal);
}
/* 转换double数据的宏 */
#define ntohd(x) (SwapDoubleEndian(&(x)))

@implementation Geometry
//int 类型大小端转换
int EndianIntConvertLToB(int InputNum) {
    int k = InputNum;
    char *p = (char*)&k;
    for (int i = 0; i<sizeof(k); i++) {
        NSLog(@"%d",p[i]);
    }
    unsigned int num,num1,num2,num3,num4;
    num1=(unsigned int)(*p)<<24;
    num2=((unsigned int)*(p+1))<<16;
    num3=((unsigned int)*(p+2))<<8;
    num4=((unsigned int)*(p+3));
    num=num1+num2+num3+num4;
    NSLog(@"num is %d",num);
    char * q = (char *)&num;
    for (int i = 0; i<sizeof(num); i++) {
        NSLog(@"%d",q[i]);
    }
    return num;
}
//将point 转换成空间数据
+(NSArray *)getShapDataWithPtx:(double)x Pty:(double)y
{
    MPoint point;
    point.x = SwapDoubleEndian(&x);//逆序double类型字节序
    point.y = SwapDoubleEndian(&y);
    NSLog(@"point ptx is %lf pty is %lf",x,y);

    WKBPoint shape;
    shape.byteOrder = EndianIntConvertLToB(wkbNDR);//int 类型字节逆序
    shape.wkbType = EndianIntConvertLToB(wkbPoint);
    shape.point = point;
    
    char * byte = (char *)&shape;
    NSMutableArray * array = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * stringArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<sizeof(shape);i++) {
        NSString * string = [NSString stringWithFormat:@"%02x",byte[i]];
        [stringArray addObject:string];
        [array addObject:[NSNumber numberWithInt:byte[i]]];
        
    }
    NSMutableString * resultString = [[NSMutableString alloc]initWithCapacity:0];
    for ( NSInteger i = 0; i<array.count  ; i++) {
        NSString * string = [stringArray objectAtIndex:i];
        if (string.length == 2) {
            [resultString appendString:string];
        }
        else
        {
            NSString * subString = [string substringFromIndex:string.length - 2];
            [resultString appendString:subString];
        }
    }
    NSLog(@"array is %@",array);
    NSLog(@"result string is %@ %d",resultString,resultString.length);
    return array;
}
//将line 转换为空间数据
+(NSArray *)getShapeListDataWithArray:(NSArray *)array andLength:(int) length
{
    NSMutableArray * pointArray = [[NSMutableArray alloc]initWithCapacity:0];
    NSMutableArray * stringArray = [[NSMutableArray alloc]initWithCapacity:0];
    Byte byteOrder = EndianIntConvertLToB(wkbNDR);
    UInt32 wkbType = EndianIntConvertLToB(wkbLine);
    int pointsNum = EndianIntConvertLToB(length);
    //取出byteOrder字节序
    char * b = (char *)&byteOrder;
    for (int i =0; i<sizeof(byteOrder); i++) {
        NSString * string = [NSString stringWithFormat:@"%02x",b[i]];
        [stringArray addObject:string];
        [pointArray addObject:[NSNumber numberWithInt:b[i]]];
    }
    //取出wkbType字节序
    char * w = (char *)&wkbType;
    for (int i =0; i<sizeof(wkbType); i++) {
        NSString * string = [NSString stringWithFormat:@"%02x",w[i]];
        [stringArray addObject:string];
        [pointArray addObject:[NSNumber numberWithInt:w[i]]];
    }
    //取出pintsNum字节序
    char * n = (char *)&pointsNum;
    for (int i =0; i<sizeof(pointsNum); i++) {
        NSString * string = [NSString stringWithFormat:@"%02x",n[i]];
        [stringArray addObject:string];
        [pointArray addObject:[NSNumber numberWithInt:n[i]]];
    }
    
    NSArray * dataArray = [[NSArray alloc]initWithArray:array];
    for (int j = 0; j< length; j++)
    {
        NSString * location = (NSString *)[dataArray objectAtIndex:j];
        NSArray * coordinate = [location componentsSeparatedByString:@","];
        double ptx = [[coordinate objectAtIndex:0] doubleValue];
        double pty = [[coordinate objectAtIndex:1] doubleValue];
        double bx = SwapDoubleEndian(&ptx);
        double by = SwapDoubleEndian(&pty);
        char * x = (char *)&bx;
        char * y = (char *)&by;
        //取出ptx字节序
        for (int i =0; i<sizeof(double); i++) {
            NSString * xString = [NSString stringWithFormat:@"%02x",x[i]];
            [stringArray addObject:xString];
            [pointArray addObject:[NSNumber numberWithInt:x[i]]];
        }
        //取出pty字节序
        for (int i =0; i<sizeof(double); i++) {
            NSString * yString = [NSString stringWithFormat:@"%02x",y[i]];
            [stringArray addObject:yString];
            [pointArray addObject:[NSNumber numberWithInt:y[i]]];
        }
    }
    NSLog(@"pointArrray is %@",pointArray);
    NSMutableString * resultString = [[NSMutableString alloc]initWithCapacity:0];
    for ( NSInteger i = 0; i<stringArray.count  ; i++) {
        NSString * string = [stringArray objectAtIndex:i];
        if (string.length == 2) {
            [resultString appendString:string];
        }
        else
        {
            NSString * subString = [string substringFromIndex:string.length - 2];
            [resultString appendString:subString];
        }
    }
    NSLog(@"resultString is %@",resultString);
    NSArray * lineArray = [NSArray arrayWithArray:pointArray];
    return lineArray;
}

+ (void)abc:(NSArray * )array andLength:(NSInteger)length
{
     NSArray * dataArray = [[NSArray alloc]initWithArray:array];
    int k = array.count;
    length = k;
    WKBLineString myLine;
    myLine.byteOrder = wkbNDR;
    myLine.numPoints = length;
    myLine.wkbType = wkbLine;
    MPoint * myP;
    myP = malloc(10*sizeof(myP));
    
    for ( int i = 0; i<dataArray.count; i++) {
        NSString * location = [dataArray objectAtIndex:i];
        NSArray * coordinate = [location componentsSeparatedByString:@","];
        double ptx = [[coordinate objectAtIndex:0] doubleValue];
        double pty = [[coordinate objectAtIndex:1] doubleValue];
        MPoint point = {ptx,pty};
        myP[i] = point;
    }
    for (int i=0; i<dataArray.count; i++) {
        MPoint point = myP[i];
        NSLog(@"x is %lf y is %lf",point.x,point.y);
        
    }
    NSLog(@"myLine is %p",myP);
}
@end
