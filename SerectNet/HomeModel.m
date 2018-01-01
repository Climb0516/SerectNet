//
//  HomeModel.m
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/31.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import "HomeModel.h"

#import "NSString+Util.h"

@implementation HomeTabModel

+ (CGFloat)caluteHomeTabTextWidthWithText:(HomeTabModel *)model {
    return  [NSString caluteTextViewSizeWithText:model.Name textFont:[UIFont boldSystemFontOfSize:20] textViewWidth:9999 textViewHeight:44.0f lineSpacing:0].width +10;
}

@end

@implementation HomeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fileId"  : @"id"
             };
}
@end


@implementation HomeCycleScrollModel

@end
