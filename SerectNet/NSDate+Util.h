//
//  NSData+Util.h
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/23.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DA_MINUTE	60
#define DA_HOUR		3600
#define DA_DAY		86400
#define DA_Month    2592000

@interface NSDate (Util)

- (NSString*)secondSince1970;

/** 根据日期显示文字，例如几天前、几小时前 */
- (NSString*)getShowTimeStringWithDate;
/**
 *  计算年龄
 */
+ (NSString *)getUserAgeWithBirthDay:(NSString *)birthDay;

@end
