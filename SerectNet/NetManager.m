//
//  NetManager.m
//  SerectNet
//
//  Created by 王攀登 on 2018/1/1.
//  Copyright © 2018年 王攀登. All rights reserved.
//

#import "NetManager.h"

#import <AFNetworking.h>

@implementation NetManager

+(void)getUnsignRequestWithURL:(NSString *)urlString finished :(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //[operation.responseData writeToFile:newpath atomically:YES];
        finishedBlock(responseObject);
    }
         failure:^(NSURLSessionTask *task, NSError *error)
     {
         failedBlock(error.localizedDescription);
     }];
}

+ (void)postUnsignRequestWithUrlParam:(NSDictionary *)urlParam finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock {
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.f;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    NSString *urlString = urlParam[@"url"];
    NSDictionary *param = urlParam[@"param"];
    [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        finishedBlock(responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error) {
        failedBlock(error.localizedDescription);
    }];
    
}

// 带进度接口
+ (void)postSignRequestWithUrlParam:(NSDictionary *)urlParam progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock {
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    NSString *urlString = urlParam[@"url"];
    NSDictionary *param = urlParam[@"param"];
    NSString *fileName  = urlParam[@"fileName"];
    NSString *formName  = urlParam[@"formName"];
    NSData *fileData    = urlParam[@"fileData"];
    NSString *mediaType = urlParam[@"mediaType"];
    [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (fileData && fileName && mediaType && formName ) {
            if ([mediaType isEqualToString:@"image/jpeg"]) {
                [formData appendPartWithFileData:fileData name:formName fileName:fileName mimeType:mediaType];
            }else{
                NSString *filePath = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL fileURLWithPath:filePath];
                [formData appendPartWithFileURL:url name:formName error:nil];
            }
        }
    } progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(error.localizedDescription);
    }];
}

// 通用接口
+ (void)postSignRequestWithUrlParam:(NSDictionary *)urlParam finished:(RequestFinishedBlock)finishedBlock failed:(RequestFailedBlock)failedBlock {
    
    [self postSignRequestWithUrlParam:urlParam progress:nil finished:finishedBlock failed:failedBlock];
}

@end
