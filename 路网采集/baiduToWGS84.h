//
//  baiduToWGS84.h
//  路网采集
//
//  Created by Cecilia on 14-4-18.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface baiduToWGS84 : NSObject


-(NSArray *)BD09ToGCJ02With:(double)bd_lat and:(double)bd_lon;
-(NSArray *)BD09ToWGS84With:(long double)bd_lat and:(long double)bd_lon;
-(NSArray *)GCJ02ToWGS84With:(double)clon and:(double)clat;
-(NSArray *)GCJ02ToBD09With:(double)gg_lat and:(double)gg_lon;
-(NSArray *)WGS84ToBD09With:(double)wgs_lat and:(double)wgs_lon;
-(NSArray *)WGS84ToGCJ02With:(double)wgLon and:(double)wgLat;


//static double* BD09ToGCJ02(double bd_lat, double bd_lon);
//static double* BD09ToWGS84(double bd_lat, double bd_lon);
//static double* GCJ02ToWGS84(double clon, double clat);
//static double* GCJ02ToBD09(double gg_lat, double gg_lon);
//static double* WGS84ToBD09(double wgs_lat, double wgs_lon);
//static double* WGS84ToGCJ02(double wgLon, double wgLat);



@end
