//
//  ApiParam.m
//  BaoPinNet
//
//  Created by 王攀登 on 2017/12/6.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import "ApiParam.h"

#import "UtilsMacro.h"
#import "APINetMacro.h"
#import "GetIpAdress.h"
#import "UserInfoData.h"
#import "NSString+Util.h"

@interface ApiParam ()

@property(nonatomic, strong) NSMutableDictionary *fieldParam;

@end

@implementation ApiParam

/**
 *  加密方式：：：：：：
 *  签名值（sign）为所有必传参数除去（sign）之外按照键值升序排列，将其值拼接为字符串计算其MD5，然后在其后加上一个公共SKEY再计算MD5后获取。
 *  例如：某个接口除了必传参数之外，还需要传递a、b、c和d这4个参数，那么sign值的计算方式如下：
 *  sign = md5(md5(a+b+c+channel+d+loc+key+net+timestamp)+SKEY)
 *  SKEY值根据不同版本会有所不用，当前版本SKEY：【TczAFlw@SyhYEyh*】
 *  注意：部分接口无需计算签名，均有标示，此时sign可以为任意非空字符串。
 */


+ (NSDictionary *)apiDictionaryWithParam:(NSDictionary *)needParam {
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if (needParam) [param setDictionary:needParam];
    [param setValue:[GetIpAdress getIPAddress] forKey:@"cip"];
    [param setValue:@"0,1"                     forKey:@"loc"];
    [param setValue:kCURRENT_APP_VERSION       forKey:@"sv"];
    [param setValue:[@"iOS" stringByAppendingString:kCURRENT_SYS_VERSION] forKey:@"sys"];
    [param setValue:APP_KEY          forKey:@"key"];
    [param setValue:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    
    UserInfoData *userSession = [UserInfoData getUserDefault];
    if (userSession.isLogin) {
        [param setValue:userSession.token forKey:@"token"];
    }else {
        [param setValue:@"null"           forKey:@"token"];
    }
    [param setValue:[self creatSignWithParam:param] forKey:@"sign"];
    return param;
}

// 创建Sign
+ (NSString *)creatSignWithParam:(NSDictionary *)param {
    NSString *soredString = [self soredStringWithParam:param];
    NSString *firstMD5Str = [soredString MD5Hash].lowercaseString;
    NSString *secondMD5String =  [[NSString stringWithFormat:@"%@%@",firstMD5Str,APP_Sign] MD5Hash].lowercaseString;
    return secondMD5String;
}

// 参数排序
+ (NSString *)soredStringWithParam:(NSDictionary *)param {
    NSArray *sortedArray = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *strContent = [[NSMutableString alloc] init];
    for (NSString *key in sortedArray) {
        NSString *keyValue = [NSString stringWithFormat:@"%@",param[key]];
        [strContent appendString:keyValue];
    }
    return strContent;
}

@end
