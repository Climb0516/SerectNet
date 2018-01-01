//
//  NSString+Util.h
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/23.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Util)


// 返回 NSMutableAttributedString
+ (NSMutableAttributedString *)mutableAttributedStringWithText:(NSString *)text
                                                          font:(UIFont *)font
                                                         color:(UIColor *)color
                                                 rangeOfString:(NSString *)string;
// 判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;
// 名字 * 显示
+ (NSString *)userNameSecretyWithNameString:(NSString *)name;
// 密码强度判断
+ (NSString *)judgePasswordStrength:(NSString *)password;
// 转base64
+ (NSString *)encodingbyBase64StringWithData:(NSData *)data;
// 图片，视频等url有汉字的处理
- (NSString *)encodeingByUTF8String;
// 字符串切割成数组
- (NSArray *)skillsTagComponentArray;

- (BOOL)hasText; // 判断字符串是否有值 ，yes 有  no 为空
- (NSString *)MD5Hash; // MD5加密
- (NSString *)toUpper; // 转大写
- (BOOL)isValidMobile; // 验证是否为可用手机号
- (BOOL)isValidEmail;  // 验证是否为可用邮箱
- (BOOL)isRangeOfString:(NSString *)string; // 验证是否为子字符串
- (NSString *)getShowTimeString; // 获得显示时间 （刚刚，几分钟前等格式）
- (NSString *)dealWithEmpty;

/**
 *  计算显示文字控件 高度／宽度 ， 
 *  font 字体    textViewWidth／textViewHeight 控件已知范围，用来确定是高度还是宽度
 *               lineSpacing 行间距 
 */
+ (CGSize)caluteTextViewSizeWithText:(NSString *)text textFont:(UIFont *)font textViewWidth:(CGFloat)textViewWidth textViewHeight:(CGFloat)textViewHeight lineSpacing:(CGFloat)lineSpace;
/**
 *  随机生成字符串
 */
+ (NSString *)generateTradeNumberString;
@end
