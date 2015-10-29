//
//  DateFormmter.m
//  路网采集
//
//  Created by Charles Leo on 14/10/22.
//  Copyright (c) 2014年 Cecilia. All rights reserved.
//

#import "DateFormmter.h"

@implementation DateFormmter
+(NSString *)intervalToDateString:(NSString *)internalString andFormaterString:(NSString *)formaterStirng{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[internalString longLongValue]/1000];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formaterStirng];
    NSString *dateStr = [dateFormat stringFromDate: date];
    return dateStr;
}
@end
