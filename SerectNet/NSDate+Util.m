//
//  NSData+Util.m
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/23.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

-( NSString*)secondSince1970 {
    NSTimeInterval a =[self timeIntervalSince1970]*1000;
    NSString *second = [NSString stringWithFormat:@"%.lf", a];//转为字符型
    return second;
}

- (NSString*)getShowTimeStringWithDate{
    NSTimeInterval before = [self timeIntervalSince1970];
    NSTimeInterval now    = [[NSDate date] timeIntervalSince1970];
    NSString *showString  = @"";
    NSTimeInterval seconds = now-before;
    
    if(seconds<=DA_MINUTE){
        showString=[NSString stringWithFormat:@"刚刚"];
    }else if(seconds>DA_MINUTE && seconds/DA_HOUR<=1) {
        showString = [NSString stringWithFormat:@"%f", seconds/DA_MINUTE];
        showString = [showString substringToIndex:showString.length-7];
        showString = [NSString stringWithFormat:@"%@分钟前", showString];
        
    }else if(seconds/DA_HOUR>1&&seconds/DA_DAY<=1) {
        // 显示 小时 前
        showString = [NSString stringWithFormat:@"%f", seconds/DA_HOUR];
        showString = [showString substringToIndex:showString.length-7];
        showString = [NSString stringWithFormat:@"%@小时前", showString];
        
    }else if(seconds/DA_DAY>1 && seconds/DA_Month<=1)
    {
        // 显示 天 前
        showString = [NSString stringWithFormat:@"%f", seconds/DA_DAY];
        showString = [showString substringToIndex:showString.length-7];
        showString = [NSString stringWithFormat:@"%@天前", showString];
    }else if(seconds/DA_Month>1 && seconds/DA_Month<=3)
    {
        // 显示 月 前  （3个月）
        showString = [NSString stringWithFormat:@"%f", seconds/DA_Month];
        showString = [showString substringToIndex:showString.length-7];
        showString = [NSString stringWithFormat:@"%@月前", showString];
    }
    else {
        // 显示真实的日期
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        showString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:self]];
    }
    return showString;
}

+ (NSString *)getUserAgeWithBirthDay:(NSString *)birthDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthDayDate = [dateFormatter dateFromString:birthDay];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:birthDayDate];
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

@end
