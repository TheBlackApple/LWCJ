//
//  DateFormmter.h
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormmter : NSObject
+(NSString *)intervalToDateString:(NSString *)internalString andFormaterString:(NSString *)formaterStirng;
@end
