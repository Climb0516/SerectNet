//
//  UtilsMacro.h
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/23.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h


// 系统参数
#define kCURRENT_UUID        [[UIDevice currentDevice].identifierForVendor UUIDString]
#define kCURRENT_SYS_VERSION [[UIDevice currentDevice] systemVersion] 
#define kCURRENT_APP_VERSION [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

// 全局打印方法 & 全局显示方法
#define RSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#define SDShow(FORMAT, ...) UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:FORMAT,##__VA_ARGS__] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];

// 默认pageSize
#define kDefaultRequestPageSize 10

// json返回结果正确
#define kResOK    0

// 默认图片
#define kImageDefault   [UIImage imageNamed:@"default"]

// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// 消息通知
#define RegisterNotify(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];

#define RemoveNofify            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define SendNotify(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];

#define NETWORKSTATUSCHANGE @"NetworkStatusChange"

//环信相关参数
#define kHuanXinAppKey @"1167170810115978#lxgapp"
#define KHuanXinUnreadMessageCount @"setupUnreadMessageCount"
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define kMsgExtNickNameKey @"nickName"
#define kMsgExtAvatarKey @"headPic"
#define kMsgExtAnchorIDKey @"anchorID"
#define kMsgExtUIDKey @"UID"
//环信聊天室kuozhan参数
#define kMsgExtMsgType @"msgType"
#define kMsgExtMsgGiftId @"msgGiftId"
#define kMsgExtMsgGiftNum @"msgGiftNum"
#define kMsgExtMsgGiftPrice @"msgGiftPrice"
#define kMsgExtHeadPic @"headPic"
#define kMsgExtMsgGiftImg @"msgGiftImg"
#define kMsgExtMsgGiftName @"msgGiftName"

#endif /* UtilsMacro_h */
