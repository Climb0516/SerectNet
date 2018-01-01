//
//  HomeModel.h
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/31.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

/**
 *  tab的model
 */
@interface HomeTabModel : NSObject

@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *ID;

+ (CGFloat)caluteHomeTabTextWidthWithText:(HomeTabModel *)model;

@end

@interface HomeModel : NSObject

@property (nonatomic, copy) NSString *VideoID;//视频ID
@property (nonatomic, strong) NSNumber *click;//观看次数
@property (nonatomic, strong) NSNumber *fileId;
@property (nonatomic, copy) NSString *title;//视频标题
@property (nonatomic, copy) NSString *pic;//视频图片
@property (nonatomic, copy) NSString *seo_description;//视频详情
@property (nonatomic, copy) NSString *video;
@property (nonatomic, assign) NSInteger video_height;//视频尺寸
@property (nonatomic, assign) NSInteger video_width;

@end

/**
 *  轮播图Model
 */
@interface HomeCycleScrollModel : NSObject

@property (nonatomic, copy) NSString *title;//碎片文本
@property (nonatomic, copy) NSString *name; //碎片名称
@property (nonatomic, copy) NSString *img;  //视频截图URL
@property (nonatomic, copy) NSString *url;  //视频Id     根据type 掉不同接口
@property (nonatomic, copy) NSString *extend;//视频URL
@property (nonatomic, copy) NSString *type; //1:平台视频详情链接;2:抱友视频详情链接

@end
