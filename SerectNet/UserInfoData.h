//
//  UserInfoData.h
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/25.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

/***
   *  用户信息
   *
   */
@interface UserInfoData : NSObject


@property(nonatomic, copy) NSString *token;
@property(nonatomic, copy) NSString *MemberID;//用户id
@property(nonatomic, copy) NSString *LoginName;//用户姓名
@property(nonatomic, copy) NSString *pic;  //头像原图URL
@property(nonatomic, copy) NSString *thumb;//头像缩略图URL
@property(nonatomic, copy) NSString *account;//用户账号，同手机号
@property(nonatomic, copy) NSString *is_baopin;
@property(nonatomic, copy) NSString *is_top;
@property(nonatomic, copy) NSString *nick;

@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *number_of_times;
@property(nonatomic, copy) NSString *gender; //性别
@property(nonatomic, copy) NSString *Signature; //签名
@property(nonatomic, copy) NSString *invite_code; //用户邀请码
@property(nonatomic, copy) NSString *mobile_status;//手机认证状态，0未认证，1已认证
@property(nonatomic, assign) BOOL isLogin;

/**
 *  创建单例，并且从NSUserDefaults获取UserInfoData
 *
 *  @return UserInfoData
 */
+ (UserInfoData *)getUserDefault;

/**
 *  将userInfoData存入NSUserDefaults，会自动将isLogin状态重置为YES（会销毁并重建单例）
 */
- (void)setUserDefault;

/**
 *  清空NSUserDefaults里的UserInfoData（会销毁并重建单例）
 */
+ (void)resetUserDefault;

@end
