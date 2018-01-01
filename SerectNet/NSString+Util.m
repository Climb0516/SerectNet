//
//  NSString+Util.m
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/23.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import "NSString+Util.h"

#import <CommonCrypto/CommonDigest.h>

#import "NSDate+Util.h"

@implementation NSString (Util)

+ (NSMutableAttributedString *)mutableAttributedStringWithText:(NSString *)text
                                                          font:(UIFont *)font
                                                         color:(UIColor *)color
                                                 rangeOfString:(NSString *)string {
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange stringRange = NSMakeRange([[mutableString string] rangeOfString:string].location, [[mutableString string] rangeOfString:string].length);
    [mutableString addAttribute:NSForegroundColorAttributeName value:color range:stringRange];
    [mutableString addAttribute:NSFontAttributeName value:font range:stringRange];
    return mutableString;
}

- (NSString *)encodeingByUTF8String {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSArray *)skillsTagComponentArray {
    NSArray *array;
    if (![self hasText]) {
        return array;
    }
    array = [self componentsSeparatedByString:@","]; //字符串按照","分隔成数组
    return array;
}

+ (NSString *)encodingbyBase64StringWithData:(NSData *)data {
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}

+ (BOOL) isBlankString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if (string == nil || string == NULL||[string isEqualToString:@"(null)"])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

+ (NSString *)userNameSecretyWithNameString:(NSString *)name {
    if ([name hasText]) {
        NSString *doneString = [name stringByReplacingCharactersInRange:NSMakeRange(1, name.length-1)  withString:@"*"];
        return doneString;
    }
    return nil;
}

+ (NSString *)judgePasswordStrength:(NSString *)password {
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:password]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    NSString* resultString = [[NSString alloc] init];
    if (intResult <2)
    {
        resultString = @"低";
    }
    else if (intResult == 2&&[password length]>=6)
    {
        resultString = @"中";
    }
    if (intResult >= 2&&[password length]>=8)
    {
        resultString = @"高";
    }
    return resultString;
}

+ (BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password {
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

- (BOOL)hasText {
    if (![self isKindOfClass:[NSString class]]) {
        return NO;
    }
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0;
}

- (NSString *)MD5Hash {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

- (BOOL) isValidMobile {
    if (self.length != 11)
    {
        return NO;
    }
    // 移动号段正则表达式
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    // 联通号段正则表达式
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    // 电信号段正则表达式
    NSString *CT_NUM = @"^((133)|(153)|(177)|(173)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:self];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:self];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:self];

    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isValidEmail {
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:self];
}


-(NSString *)toUpper {
    NSString *str;
    for (NSInteger i=0; i<self.length; i++) {
        if ([self characterAtIndex:i]>='a'&[self characterAtIndex:i]<='z') {
            //A  65  a  97
            char  temp=[self characterAtIndex:i]-32;
            NSRange range=NSMakeRange(i, 1);
            str=[self stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

-(BOOL)isRangeOfString:(NSString *)string {
    if([self rangeOfString:string].location !=NSNotFound){
        return YES;
    }else{
        return NO;
    }
}

+ (CGSize)caluteTextViewSizeWithText:(NSString *)text textFont:(UIFont *)font textViewWidth:(CGFloat)textViewWidth textViewHeight:(CGFloat)textViewHeight lineSpacing:(CGFloat)lineSpace  {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    if (lineSpace > 0) {
       paragraphStyle.lineSpacing = lineSpace; //设置行间距
    }
    NSDictionary *attributes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(textViewWidth, textViewHeight)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:attributes context:nil].size;
    return size;
}

- (NSString *)getShowTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [dateFormatter dateFromString:self];
    NSString *timeStr = [inputDate getShowTimeStringWithDate];
    return timeStr;
}

- (NSString *)dealWithEmpty {
    if ([self hasText]) {
        return self;
    }
    return @"抱品网";
}
+ (NSString *)generateTradeNumberString{
    static int kNumber = 6;
    NSString *sourceStr = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}


@end
