//
//  Geometry.h
//  路网采集
//
//  Created by Charles Leo on 14/10/28.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma pack(1)

typedef struct{
    double x;
    double y;
}MPoint;
enum wkbByteOrder
{
    wkbXDR = 0,          // Big Endian
    wkbNDR = 1           // Little Endian
};
enum wkbGeometryType {
    wkbPoint = 1,
    wkbLine = 2,
    wkbPolygon = 3,
    wkbMultiPoint = 4,
    wkbMultiLineString = 5,
    wkbMultiPolygon = 6,
    wkbGeometryCollection = 7
};

typedef struct {
    Byte  byteOrder;
    UInt32   wkbType;      //2
    int   numPoints;
    MPoint pointArray[];
} WKBLineString;



typedef struct {
    Byte byteOrder;
    UInt32 wkbType;
    MPoint point;
}WKBPoint;

@interface Geometry : NSObject

+(NSArray *)getShapDataWithPtx:(double)x Pty:(double) y;
+(NSArray *)getShapeListDataWithArray:(NSArray *)array andLength:(int) length;

@end
