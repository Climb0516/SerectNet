//
//  NetManager.h
//  SerectNet
//
//  Created by 王攀登 on 2018/1/1.
//  Copyright © 2018年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

//     封装网络请求的block
typedef void(^RequestFinishedBlock)(id responseObj);
typedef void(^RequestFailedBlock)(NSString *errorMsg);
typedef void (^ConstructingBodyBlock) (id formData);

@interface NetManager : NSObject

/**
 *  GET请求block，不加密，用于和其他第三方请求
 *
 *  @param urlString     get URL地址
 *  @param finishedBlock 成功后block
 *  @param failedBlock   失败后block
 */
+(void)getUnsignRequestWithURL:(NSString *)urlString finished :(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;

/**
 *  POST请求block，不带文件，且不加密，用于和其他第三方请求，例如苹果支付
 *
 *  @param urlParam     post URL地址  body带的参数
 *  @param finishedBlock 成功后block
 *  @param failedBlock   失败后block
 */
+ (void)postUnsignRequestWithUrlParam:(NSDictionary *)urlParam finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;



// 加密的
// 带进度接口
+ (void)postSignRequestWithUrlParam:(NSDictionary *)urlParam progress:( void (^)(NSProgress *progress))uploadProgress finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;

// 通用
+ (void)postSignRequestWithUrlParam:(NSDictionary *)urlParam finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock;


@end
