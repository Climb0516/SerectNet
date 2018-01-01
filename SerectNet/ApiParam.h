//
//  ApiParam.h
//  BaoPinNet
//
//  Created by 王攀登 on 2017/12/6.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiParam : NSObject

/**
 *  公用参数Param
 */
+ (NSDictionary *)apiDictionaryWithParam:(NSDictionary *)param;

@end
