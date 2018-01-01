//
//  APINetMacro.h
//  SerectNet
//
//  Created by 王攀登 on 2018/1/1.
//  Copyright © 2018年 王攀登. All rights reserved.
//

#ifndef APINetMacro_h
#define APINetMacro_h


/**
 *  _APP_ENVIRMENT_为后台环境参数
 *  0为用外网进行测试/用内网测试, 1为阿里云正式服务器, 2为连接后台机器测试
 */
#define _APP_ENVIRMENT_ 0

// 0为测试环境 （内网／外网 咱不区分）
#if ((_APP_ENVIRMENT_) == 0)

#define kHostAddr       @"http://59.110.48.164:9001/api"
#define kHuanXinCerName @"develop"
#define kUserProtocol   @"http://baopin.wanmpserver.com:803/Register/agreementApp"
#define kUserConvention @"http://baopin.wanmpserver.com:803/Register/specificationApp"

#define APP_KEY         @"WblmxxxBjc1ggL"
#define APP_Sign        @"TczAFlw@SyhYEyh*"
#define kBaoPinUserHostAddr   @"http://baopin.wanmpserver.com:8001/v1" //user
#define kBaoPinApiHostAddr    @"http://baopin.wanmpserver.com:8011/v1" //api
#define kBaoPinUploadHostAddr @"http://baopin.wanmpserver.com:8005" //upload

// 1为正式服务器，用于发布
#elif ((_APP_ENVIRMENT_) == 1)

#define kHostAddr       @"http://59.110.48.164:9001/api"
#define kHuanXinCerName @"production"
#define kUserProtocol   @"http://mobile.baopinnet.com/Register/agreementApp"
#define kUserConvention @"http://mobile.baopinnet.com/Register/specificationApp"

#define APP_KEY         @"WblmxxxBjc3ggL"
#define APP_Sign        @"TczAFlw@SyhYEyh*"
#define kBaoPinUserHostAddr   @"http://user.baopinnet.com/v1" //user
#define kBaoPinApiHostAddr    @"http://api.baopinnet.com/v1" //api
#define kBaoPinUploadHostAddr @"http://upload.baopinnet.com" //upload

#endif


#endif /* APINetMacro_h */
