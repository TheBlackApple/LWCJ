//
//  NSString+JSONDictionary.m
//  MyTaxiDriver
//
//  Created by Charles Leo  on 14-5-7.
//  Copyright (c) 2014年 Grace Leo. All rights reserved.
//

#import "NSString+JSONDictionary.h"

@implementation NSString (JSONDictionary)
-(id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
@end
