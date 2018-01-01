//
//  UrlManager.m
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/24.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import "UrlParamManager.h"

#import <CommonCrypto/CommonDigest.h>

#import "ApiParam.h"
#import "APINetMacro.h"
#import "UserInfoData.h"
#import "NSString+Util.h"

NSInteger customSortKey(id obj1, id obj2,void* context) {
    if ([obj1 integerValue] > [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] < [obj2 integerValue]) {
        return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
}

#define kDefaultRequestPageSize 20

@implementation UrlParamManager

#pragma mark ============= 公共方法 ==============

/**
 *  获取url地址
 *
 *  @param methodName 方法名
 *  @param param  上传的参数, 如果param为空，则传 @{}
 *
 *  @return url地址
 */
+ (NSDictionary *)GetURLWithMethodName:(NSString *)methodName param:(NSDictionary *)param urlType:(UrlType )urlType {
    NSString *hostAddress;
    if (urlType == UrlTypeUser) {
        hostAddress = kBaoPinUserHostAddr;
    }else if (urlType == UrlTypeApi) {
        hostAddress = kBaoPinApiHostAddr;
    }else {
        hostAddress = kBaoPinUploadHostAddr;
    }
    NSString *urlStr =[NSString stringWithFormat:@"%@/%@",hostAddress,methodName];
    NSDictionary *urlDic = @{@"url":urlStr,@"param":param};
    return urlDic;
}

+ (NSDictionary *)GetUploadParamWithFileName:(NSString *)fileName formDataName:(NSString *)formName fileData:(NSData *)fileData mediaType:(NSString *)mediaType{
    if (!mediaType) mediaType = @"multipart/form-data";
    return NSDictionaryOfVariableBindings(fileName,formName,fileData,mediaType);
}

+ (NSDictionary *)GetURLWithMethodName:(NSString *)methodName param:(NSDictionary *)param {
    NSString *urlStr =[NSString stringWithFormat:@"%@/%@",kHostAddr,methodName];
    NSDictionary *urlDic = @{@"url":urlStr,@"param":param};
    return urlDic;
}

+ (NSString *)getUserIdWithLoginStatus {
    UserInfoData *userInfoData=[UserInfoData getUserDefault];
    if (userInfoData.isLogin) {
        return userInfoData.MemberID;
    }
    return @"0";
}

#pragma mark ============= private 方法 ==============

// 抱品网

// 注册
+ (NSDictionary *)registerUserWithPhone:(NSString *)phone vCode:(NSString *)vCode password:(NSString *)password {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:phone    forKey:@"mobile"];
    [needParam setValue:password forKey:@"pass"];
    [needParam setValue:password forKey:@"repass"];
    [needParam setValue:vCode    forKey:@"verifys"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"Users/reg" param:param urlType:UrlTypeUser];
}
// 验证码
+ (NSDictionary *)sendSMSCodeWithMobile:(NSString *)phone  {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:phone    forKey:@"mobile"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"SendSms" param:param urlType:UrlTypeUser];
}
// 登陆
+ (NSDictionary *)loginInUserWithAccount:(NSString *)account password:(NSString *)password {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:account  forKey:@"account"];
    [needParam setValue:password forKey:@"pass"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"Users/login" param:param  urlType:UrlTypeUser];
}
// 第三方登陆
+ (NSDictionary *)theThirdPartLoginWithOpenid:(NSString *)openid access_token:(NSString *)access_token {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:openid  forKey:@"openid"];
    [needParam setValue:access_token forKey:@"access_token"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"Users/OAuthLogin" param:param  urlType:UrlTypeUser];
}
// 用户详情
+ (NSDictionary *)getUserDetailWithMemberID:(NSString *)memberId mobile:(NSString *)mobile {
//    NSMutableDictionary *needParam = [NSMutableDictionary new];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    if (![NSString isBlankString:memberId]) {
        [param setValue:memberId forKey:@"id"]; //用户id ，不传显示当前用户信息
    }
    if (![NSString isBlankString:mobile]) {
        [param setValue:mobile forKey:@"mobile"];//用户手机号，不传显示当前用户信息
    }
    return [self GetURLWithMethodName:@"Users/detail" param:param urlType:UrlTypeUser];
}
// 抱友秀title分类列表
+ (NSDictionary *)baoyouTabListUrl {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:@"false" forKey:@"is_cache"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_category" param:param urlType:UrlTypeApi];
}
// 抱友秀视频列表 users/Users_video
+ (NSDictionary *)baoyouShowVideoListUrlWithTabId:(NSString *)tabId  page:(NSInteger)page {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    [param setValue:@"1" forKey:@"is_baoyou_list"];
    if ([tabId hasText]) {
        [param setValue:tabId   forKey:@"ucid"];
    }else {
        [param setValue:@(1)    forKey:@"is_top"];
    }
    [param setValue:@(page) forKey:@"page"];
    [param setValue:@(10)   forKey:@"size"];
    return [self GetURLWithMethodName:@"users/Users_video" param:param urlType:UrlTypeApi];
}
// 今日上新 / 抱友精选
+ (NSDictionary *)homeRecommendUrlWithType:(NSString *)type size:(NSInteger)size page:(NSInteger)page{
    NSMutableDictionary *needParam = [NSMutableDictionary dictionary];
    [needParam setValue:type forKey:@"create_time"];
    [needParam setValue:@(size) forKey:@"size"];
    [needParam setValue:@(page) forKey:@"page"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"video/Video" param:param urlType:UrlTypeApi];
}
// 播放视频详情 -- 抱友的
+ (NSDictionary *)playViewVideoDetailInUserWithVideoId:(NSString *)videoId {
    NSMutableDictionary *needParam = [NSMutableDictionary dictionary];
    [needParam setValue:videoId forKey:@"id"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_video/detail" param:param urlType:UrlTypeApi];
}
// 播放视频详情 -- 平台的
+ (NSDictionary *)playViewVideoDetailInPlatWithVideoId:(NSString *)videoId {
    NSMutableDictionary *needParam = [NSMutableDictionary dictionary];
    [needParam setValue:videoId forKey:@"id"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"video/Video/detail" param:param urlType:UrlTypeApi];
}
// 个人详情 - 视频列表
+ (NSDictionary *)UserVideoListUrlWithUid:(NSString *)uid page:(NSInteger)page isMyself:(BOOL)isMyself {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    //    [needParam setValue:@"1" forKey:@"is_baoyou_list"];
    //    [needParam setValue:@"1" forKey:@"is_my"];
    //    [needParam setValue:@"false" forKey:@"is_cache"];
    //    [needParam setValue:@"1" forKey:@"is_sale"];
    
    [param setValue:@(page) forKey:@"page"];
    [param setValue:@(100)  forKey:@"size"];
    if (isMyself) {
        [param setValue:@(1)  forKey:@"is_my"];
    }else {
        [param setValue:uid     forKey:@"uid"];
    }
    return [self GetURLWithMethodName:@"users/Users_video" param:param urlType:UrlTypeApi];
}
// 首页 - 轮播图
+ (NSDictionary *)HomeCycleScrollUrl {
    NSMutableDictionary *needParam = [NSMutableDictionary dictionary];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"system/Banner" param:param urlType:UrlTypeApi];
}
// 我的关注
+ (NSDictionary *)findHaveMomentsListWithPage:(NSInteger )page {
    
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [needParam setValue:userInfoData.MemberID        forKey:@"uid"];
    [needParam setValue:@(page)                      forKey:@"page"];
    [needParam setValue:@(kDefaultRequestPageSize)   forKey:@"size"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_follow" param:param urlType:UrlTypeApi];
}

// 首页详情 - 添加关注 state:0； 取消关注 state:1
+ (NSDictionary *)UserAddOrRemoveFansFirendWithFollowID:(NSInteger )followID State:(NSInteger )state{
    if (state == 0) {
        NSMutableDictionary *needParam = [NSMutableDictionary new];
        [needParam setValue:@(followID) forKey:@"the_uid"];
        NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
        return [self GetURLWithMethodName:@"users/Users_follow/add" param:param urlType:UrlTypeApi];
    }else{
        NSMutableDictionary *needParam = [NSMutableDictionary new];
        [needParam setValue:@(followID) forKey:@"the_uid"];
        NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
        return [self GetURLWithMethodName:@"users/Users_follow/delete" param:param urlType:UrlTypeApi];
    }
}
// 点赞 state:0； 取消点赞 state:1
+ (NSDictionary *)ZanOrCancleZanWithVideoId:(NSString *)videoID state:(NSInteger )state {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    if (state == 0) {
        [needParam setValue:videoID forKey:@"vid"];
        NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
        return [self GetURLWithMethodName:@"users/Users_video/setTop" param:param urlType:UrlTypeApi];
    }
    [needParam setValue:videoID forKey:@"vid"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_video/setTopDel" param:param urlType:UrlTypeApi];
}
// 我的 - 关注列表
+ (NSDictionary *)MineFocusListWithPage:(NSInteger )page {
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    if (userInfoData.MemberID){
        
        [needParam setValue:userInfoData.MemberID forKey:@"uid"];
    }
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    [param setValue:@(page)                      forKey:@"page"];
    [param setValue:@(kDefaultRequestPageSize)   forKey:@"size"];
    return [self GetURLWithMethodName:@"users/Users_follow" param:param urlType:UrlTypeApi];
}
// 我的 - 我的视频删除接口
+ (NSDictionary *)deleteMyVideoWithVideoString:(NSString *)videoStr {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:videoStr forKey:@"ids"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_video/batchDelete" param:param urlType:UrlTypeApi];
}

// 首页详情 - 是否关注
+ (NSDictionary *)isFansFirendWithFollowID:(NSInteger )followID{

    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:@(followID) forKey:@"the_uid"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_follow/isFollow" param:param urlType:UrlTypeApi];
}
// 我的 - 修改 名字/个性签名
+ (NSDictionary *)changeMineInfoWithNickName:(NSString *)nick signature:(NSString *)signature {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    if (![NSString isBlankString:nick]) {
        [param setValue:nick forKey:@"nick"];
    }
    if (![NSString isBlankString:signature]) {
        [param setValue:signature forKey:@"signs"];
    }
    return [self GetURLWithMethodName:@"Users/update" param:param urlType:UrlTypeUser];
}
// 我的 - 修改密码
+ (NSDictionary *)changeMineInfoWithPassWord:(NSString *)newPass oldPass:(NSString *)oldPass {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:oldPass forKey:@"oldpass"];
    [needParam setValue:newPass forKey:@"pass"];
    [needParam setValue:newPass forKey:@"repass"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"Users/updatePass" param:param urlType:UrlTypeUser];
}
// 我的 - 忘记密码找回
+ (NSDictionary *)resetMineInfoWithPassWord:(NSString *)newPass mobile:(NSString *)mobile vCode:(NSString *)vCode {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:mobile  forKey:@"mobile"];
    [needParam setValue:newPass forKey:@"pass"];
    [needParam setValue:newPass forKey:@"repass"];
    [needParam setValue:vCode   forKey:@"verifys"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"Users/findPass" param:param urlType:UrlTypeUser];
}
// 上传图片
+ (NSDictionary *)uploadFileWithImageWithFileContent:(id)fileContent {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    [param setValue:@(1) forKey:@"is_thumb"];
    [param setValue:@"img" forKey:@"filename"];
    [param setValue:fileContent forKey:@"img"];
    return [self GetURLWithMethodName:@"upload" param:param urlType:UrlTypeUpload];
}
// 上传视频
+ (NSDictionary *)uploadFileWithVideoWithFileContent:(id)fileContent {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    [param setValue:@"img" forKey:@"filename"];
    [param setValue:fileContent forKey:@"img"];
    return [self GetURLWithMethodName:@"Qiniu" param:param urlType:UrlTypeUpload];
}
// 搜索 - 热门推荐
+ (NSDictionary *)searchHotDataList {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    return [self GetURLWithMethodName:@"Hot_search" param:param urlType:UrlTypeApi];
}
// 搜索 - 关键字内容搜索
+ (NSDictionary *)searchDataWithKey:(NSString *)key pageIndex:(NSNumber *)page {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    [param setValue:key  forKey:@"keywords"];
    [param setValue:page forKey:@"page"];
    [param setValue:@(50)   forKey:@"size"];
    return [self GetURLWithMethodName:@"Search" param:param urlType:UrlTypeApi];
}
// 视频 - 举报
+ (NSDictionary *)ReportVideoWithVideoId:(NSString *)vid content:(NSString *)content {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:vid  forKey:@"vid"];
    [needParam setValue:content forKey:@"content"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_report/add" param:param urlType:UrlTypeApi];
}
// 视频 - 评论列表接口 -- 抱友的
+ (NSDictionary *)PlayUserVideoCommentListWithVideoId:(NSString *)vid page:(NSInteger )page {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:vid  forKey:@"vid"];
    [needParam setValue:@"no"  forKey:@"the"];
    [needParam setValue:@(page) forKey:@"PageIndex"];
    [needParam setValue:@(30) forKey:@"PageSize"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_video_comment" param:param urlType:UrlTypeApi];
}
// 视频 - 评论列表接口 -- 平台的
+ (NSDictionary *)PlayPlatVideoCommentListWithVideoId:(NSString *)vid page:(NSInteger )page {
    NSDictionary *param = [ApiParam apiDictionaryWithParam:nil];
    [param setValue:vid  forKey:@"vid"];
    [param setValue:@(page) forKey:@"PageIndex"];
    [param setValue:@(30) forKey:@"PageSize"];
    return [self GetURLWithMethodName:@"video/Video_comment" param:param urlType:UrlTypeApi];
}
// 视频 - 添加评论接口
+ (NSDictionary *)PlayVideoAddCommentWithVideoId:(NSString *)vid content:(NSString *)content sourceType:(NSInteger)sourceType {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:content  forKey:@"content"];
    NSString *method;
    if (sourceType == 1) {
        [needParam setValue:vid  forKey:@"vid"];
        method = @"users/Users_video_comment/add";
    }else {
        [needParam setValue:vid  forKey:@"id"];
        method = @"video/Video_comment/add";
    }
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:method param:param urlType:UrlTypeApi];
}





// 关注 - 我的朋友圈
+ (NSDictionary *)userFriendsCircleWithPage:(NSInteger)page{
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:@(page)  forKey:@"page"];
    [needParam setValue:@(kDefaultRequestPageSize) forKey:@"size"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Users_follow/friendsCircle" param:param urlType:UrlTypeApi];
}

// 文件上传 type: 0(image) / 1(video)
+ (NSDictionary *)uploadFileWithType:(NSInteger )type fileData:(NSData *)fileData extraFormat:(void(^)(void(^)(BOOL is_thumb,NSInteger thumb_width,NSInteger thumb_height,NSInteger is_resize,NSInteger resize_width,NSInteger resize_height)))extraFormat{
    
    NSString *fileName =  type ? @"video"       : @"pic.jpg";
    NSString *formName =  type ? @"upload_file" : @"img";
    NSString *methName =  type ? @"Qiniu/"      : @"upload/";
    NSString *mediaType = type ? nil   : @"image/jpeg";
    
    NSDictionary *signParam = [ApiParam apiDictionaryWithParam:nil];
    
    if (type == 0 && extraFormat) {
        void(^extraHandle)(BOOL,NSInteger,NSInteger ,NSInteger ,NSInteger ,NSInteger ) = ^(BOOL is_thumb,NSInteger thumb_width,NSInteger thumb_height,NSInteger is_resize,NSInteger resize_width,NSInteger resize_height){
            
            NSDictionary *dic =
            @{@"is_thumb":@((int)is_thumb),
              @"thumb_width":@(thumb_width),
              @"thumb_height":@(thumb_height),
              @"is_resize":@((int)is_resize),
              @"resize_width":@(resize_width),
              @"resize_height":@(resize_height)};
            [signParam setValuesForKeysWithDictionary:dic];
        };
        extraFormat(extraHandle);
    }
    [signParam setValue:formName forKey:@"filename"];
    
    NSDictionary *requestParam = [self GetURLWithMethodName:methName param:signParam urlType:UrlTypeUpload];
    NSDictionary *uploadParam = [self GetUploadParamWithFileName:fileName formDataName:formName fileData:fileData mediaType:mediaType];
    
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setValuesForKeysWithDictionary:requestParam];
    [param setValuesForKeysWithDictionary:uploadParam];
    return param;
}
// 我的 - 更新用户头像
+ (NSDictionary *)UserUpDateHeaderImaegWithPicJson:(NSDictionary *)picJson {
    NSData *data = [NSJSONSerialization dataWithJSONObject:picJson options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:jsonStr forKey:@"pic_json"];
    NSDictionary *signParam = [ApiParam apiDictionaryWithParam:param];
    return [self GetURLWithMethodName:@"Users/updatePic" param:signParam urlType:UrlTypeUser];
}

// 朋友圈 - 发布视频
+ (NSDictionary *)findPublishDynamicWithTitle:(NSString *)title publishType:(NSInteger )type video_json:(NSString *)video_json desContent:(NSString *)desContent extraFormat:(void(^)(void(^)(NSString *goods_url,NSString * goods_title,NSString * goods_json,NSString * goods_price)))extraFormat{
    
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:title  forKey:@"title"];
    [needParam setValue:@(type) forKey:@"type"];
    [needParam setValue:video_json forKey:@"video_json"];
    [needParam setValue:desContent forKey:@"description"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    
    if (extraFormat) {
        void(^extraHandle)(NSString *,NSString * ,NSString * goods_json,NSString *) = ^(NSString *goods_url,NSString * goods_title,NSString * goods_json,NSString * goods_price){
            
            if (type == 0) {
                [param setValue:goods_url forKey:@"goods_url"];
                [param setValue:goods_title forKey:@"goods_title"];
                [param setValue:goods_json forKey:@"goods_json"];
                [param setValue:goods_price forKey:@"goods_price"];
            }else if (type == 1) {
                [param setValue:goods_url forKey:@"goods_url"];
                [param setValue:goods_title forKey:@"goods_title"];
                [param setValue:goods_json forKey:@"goods_json"];
            }else {
                [param setValue:goods_title forKey:@"content"];
                [param setValue:goods_json forKey:@"goods_json"];
            }
        };
        extraFormat(extraHandle);
    }
    return [self GetURLWithMethodName:@"users/Users_video/add" param:param urlType:UrlTypeApi];
}

// 金山云短视频鉴权
+ (NSDictionary *)KsAuthenUrlParamWithBundleId:(NSString *)boundleid {
    NSMutableDictionary *needParam = [NSMutableDictionary new];
    [needParam setValue:boundleid  forKey:@"PackageName"];
    NSDictionary *param = [ApiParam apiDictionaryWithParam:needParam];
    return [self GetURLWithMethodName:@"users/Kingsofts/KsAuthentic" param:param urlType:UrlTypeApi];
}








// 老项目
#pragma mark ============= by Climb ==============

+ (NSDictionary *)UserUpDateFileWithImageORVedioWithType:(NSInteger )type FolderName:(NSString *)folderName FileName:(NSString *)fileName FileContent:(NSString *)fileContent{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    [param setValue:@(type) forKey:@"Type"];
    [param setValue:folderName forKey:@"FolderName"];
    [param setValue:fileName forKey:@"FileName"];
    [param setValue:fileContent forKey:@"FileContent"];
    return [self GetURLWithMethodName:@"Accounts/FileUpload" param:param];
}
+ (NSDictionary *)homeTabUrl {
    return [self GetURLWithMethodName:@"MyCenter/HaveTabSkill" param:@{}];
}

+ (NSDictionary *)homeHaveTabVideosWithTabID:(NSString *)TabID TabName:(NSString *)TabName OrderType:(NSString *)OrderType PageIndex:(NSNumber *)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:TabID     forKey:@"TabID"];
    [param setValue:TabName   forKey:@"TabName"];
    [param setValue:OrderType forKey:@"OrderType"];
    [param setValue:page      forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"Videos/HaveTabVideosList" param:param];
}

+ (NSDictionary *)recommendCycleScrollUrl {
    return [self GetURLWithMethodName:@"Accounts/HaveBannerList" param:@{}];
}

+ (NSDictionary *)recommendNearbyUrlWithPosionX:(NSNumber *)posionX posionY:(NSNumber *)posionY pageIndex:(NSNumber *)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:posionX forKey:@"X"];
    [param setValue:posionY forKey:@"Y"];
    [param setValue:page    forKey:@"PageIndex"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    return [self GetURLWithMethodName:@"Videos/HaveNearbyList" param:param];
}

+ (NSDictionary *)skillTabListWithTypeId:(NSString *)typeId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:typeId  forKey:@"TypeID"];
    return [self GetURLWithMethodName:@"Accounts/HaveSkillTabList" param:param];
}

//+ (NSDictionary *)searchDataWithKey:(NSString *)key pageIndex:(NSNumber *)page {
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setValue:key  forKey:@"SearchCode"];
//    [param setValue:page forKey:@"PageIndex"];
//    return [self GetURLWithMethodName:@"Videos/HaveSearchList" param:param];
//}

+ (NSDictionary *)playViewDetailDataWithVedioId:(NSString *)vedioId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:vedioId    forKey:@"ID"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    return [self GetURLWithMethodName:@"Videos/HavePlayDetail" param:param];
}

+ (NSDictionary *)playViewVideoCommendDataWithVedioId:(NSString *)vedioId pageIndex:(NSNumber *)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:vedioId forKey:@"ID"];
    [param setValue:page    forKey:@"PageIndex"];
    [param setValue:@(kDefaultRequestPageSize)      forKey:@"PageSize"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    return [self GetURLWithMethodName:@"Videos/HaveCommentList" param:param];
}

+ (NSDictionary *)playViewAddPlayAcountWithVideoId:(NSString *)videoId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:videoId forKey:@"VideoID"];
    return [self GetURLWithMethodName:@"Videos/AddPlayAmount" param:param];
}

+ (NSDictionary *)playViewPublishVideoCommentWithVideoID:(NSString *)videoId Comments:(NSString *)comments ImageUrl:(NSString *)imageUrl VideoUrlStand:(NSString *)videoUrlStand {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [param setValue:userInfoData.MemberID   forKey:@"MemberID"];
    [param setValue:userInfoData.token  forKey:@"token"];
    [param setValue:videoId  forKey:@"VideoID"];
    [param setValue:comments forKey:@"Comments"];
    [param setValue:imageUrl forKey:@"ImageUrl"];
    [param setValue:videoUrlStand forKey:@"VideoUrlStand"];
    return [self GetURLWithMethodName:@"Videos/AudioComments" param:param];
}

+ (NSDictionary *)videoClickZanWithVideoId:(NSString *)videoID state:(NSInteger )state {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [param setValue:userInfoData.MemberID forKey:@"MemberID"];
    [param setValue:userInfoData.token forKey:@"token"];
    [param setValue:videoID forKey:@"VideoID"];
    [param setValue:@(state)    forKey:@"State"];
    return [self GetURLWithMethodName:@"Videos/UserVideoBueno" param:param];
}

+ (NSDictionary *)videoCommentFunctionBtnActionWithVideoId:(NSString *)videoID type:(NSInteger)type state:(NSInteger)state {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [param setValue:userInfoData.MemberID forKey:@"MemberID"];
    [param setValue:userInfoData.token forKey:@"token"];
    [param setValue:videoID forKey:@"CommentID"];
    [param setValue:@(state)   forKey:@"State"];
    [param setValue:@(type)    forKey:@"Type"]; // 操作行为(1:点赞 2:踩 3:举报)
    return [self GetURLWithMethodName:@"Videos/DiscussAction" param:param];
}

+ (NSDictionary *)videoCommentRemoveVedioCommentWithVideoId:(NSString *)videoId commentId:(NSString *)commentId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:commentId forKey:@"ID"];
    [param setValue:videoId forKey:@"VideoID"];
    return [self GetURLWithMethodName:@"Videos/DelAudioComments" param:param];
}

+ (NSDictionary *)anchorDetailBaseDataWithMembeId:(NSString *)memberId {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:memberId forKey:@"PersonID"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    return [self GetURLWithMethodName:@"MyCenter/HavePersonHome" param:param];
}

+ (NSDictionary *)anchorDetailVideoDataWithMembeId:(NSString *)memberId pageIndex:(NSNumber *)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:memberId forKey:@"MemberID"];
    [param setValue:page     forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"Videos/HaveVideosList" param:param];
}

+ (NSDictionary *)KsAuthenticWithPackageName:(NSString *)packageName {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:packageName forKey:@"PackageName"];
    return [self GetURLWithMethodName:@"Kingsoft/KsAuthentic" param:param];
}

+ (NSDictionary *)findPublishDynamicWithTitle:(NSString *)title ImageUrl:(NSString *)imageUrl VideoUrlStand:(NSString *)videoUrlStand desContent:(NSString *)desContent {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [param setValue:[NSNumber numberWithInteger:userInfoData.MemberID] forKey:@"MemberID"];
    [param setValue:userInfoData.token forKey:@"token"];
    [param setValue:title forKey:@"Title"];
    [param setValue:imageUrl forKey:@"ImageUrl"];
    [param setValue:videoUrlStand forKey:@"VideoUrlStand"];
    [param setValue:desContent forKey:@"Description"];
    return [self GetURLWithMethodName:@"Videos/UploadAudio" param:param];
}

+ (NSDictionary *)dealBlockTrendsWithFollowID:(NSString *)followID state:(NSInteger )state {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [param setValue:[NSNumber numberWithInteger:userInfoData.MemberID] forKey:@"MemberID"];
    [param setValue:userInfoData.token forKey:@"token"];
    [param setValue:followID forKey:@"FollowID"];
    [param setValue:@(state) forKey:@"State"]; //是否屏蔽(0:否 1:是)
    return [self GetURLWithMethodName:@"MyCenter/BlockTrends" param:param];
}

+ (NSDictionary *)dealBlackListWithBurnMemberId:(NSString *)burnMemberID state:(NSInteger )state {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfoData = [UserInfoData getUserDefault];
    [param setValue:[NSNumber numberWithInteger:userInfoData.MemberID] forKey:@"MemberID"];
    [param setValue:userInfoData.token forKey:@"token"];
    [param setValue:burnMemberID forKey:@"BurnMemberID"];
    [param setValue:@(state) forKey:@"State"]; //状态(0:加入黑名单 1:取消黑名单)
    return [self GetURLWithMethodName:@"MyCenter/AddBurnNotice" param:param];
}

+ (NSDictionary *)updateExamineWithCurrentVesion:(NSString *)vesion {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:vesion forKey:@"SearchCode"];
    return [self GetURLWithMethodName:@"Accounts/ExamineRenewal" param:param];
}

#pragma mark ============= by 欧人 ==============

//+ (NSDictionary *)registerUserWithPhone:(NSString *)phone vCode:(NSString *)vCode password:(NSString *)password {
//    ApiParam *param = [ApiParam baseParam];
//    [param setValue:phone    forKey:@"Mobile"];
//    [param setValue:vCode    forKey:@"LoginPwd"];
//    [param setValue:password forKey:@"VerifyCode"];
//    return [self GetURLWithMethodName:@"Accounts/UserRegister" param:param];
//}

//+ (NSDictionary *)loginInUserWithPhone:(NSString *)phone password:(NSString *)password{
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setValue:phone    forKey:@"Mobile"];
//    [param setValue:password forKey:@"LoginPwd"];
//    return [self GetURLWithMethodName:@"Accounts/UserLogin" param:param];
//}

+ (NSDictionary *)ModifyTheNicknameWith:(NSString *)nick{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[UserInfoData getUserDefault].token forKey:@"token"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    [param setValue:nick forKey:@"Nickname"];
    return [self GetURLWithMethodName:@"Accounts/ModifyNickname" param:param];
}

+ (NSDictionary *)ModifyTheSexWith:(NSInteger )sex{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[UserInfoData getUserDefault].token forKey:@"token"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    [param setValue:@(sex) forKey:@"Gender"];
    return [self GetURLWithMethodName:@"MyCenter/ModifyGender" param:param];
}

+ (NSDictionary *)UserUpDataPassWordWithPhone:(NSString *)phone vCode:(NSString *)vCode newPassword:(NSString *)newPassword {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:phone    forKey:@"Mobile"];
    [param setValue:vCode    forKey:@"VerifyCode"];
    [param setValue:newPassword forKey:@"NewPassWord"];
    return [self GetURLWithMethodName:@"Accounts/ForgetPassword" param:param];
}

+ (NSDictionary *)UserUpDataPassWordWithOldPassWord:(NSString *)oldPassWord newPassword:(NSString *)newPassword token:(NSString *)token MemberID:(NSInteger )MemberID{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:oldPassWord    forKey:@"PassWord"];
    [param setValue:newPassword    forKey:@"NewPassWord"];
    [param setValue:token forKey:@"token"];
    [param setValue:@(MemberID) forKey:@"MemberID"];
    return [self GetURLWithMethodName:@"Accounts/ModifyPassWord" param:param];
}

+ (NSDictionary *)ThethirdPartyLandedWithOpenId:(NSString *)openID AccessToken:(NSString *)accessToken nickName:(NSString *)nickname Gender:(NSString *)gender IconUrl:(NSString*)iconUrl Type:(NSInteger )type{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:openID      forKey:@"OpenID"];
    [param setValue:accessToken forKey:@"Access_token"];
    [param setValue:@(type)     forKey:@"Type"];
    [param setValue:nickname forKey:@"Nickname"];
    [param setValue:iconUrl forKey:@"IconUrl"];
    [param setValue:gender forKey:@"Gender"];
    return [self GetURLWithMethodName:@"Accounts/OAuthLogin" param:param];
}

+ (NSDictionary *)MineConcernNumberWithtokenAndMenberIDWithPage:(NSInteger )page{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[UserInfoData getUserDefault].token forKey:@"token"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    [param setValue:@(page) forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"MyCenter/HaveMyAttention" param:param];
}

+ (NSDictionary *)MineFansNumberWithtokenAndMenberIDWithPage:(NSInteger )page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[UserInfoData getUserDefault].token forKey:@"token"];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    [param setValue:@(page) forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"MyCenter/HaveMyFans" param:param];
}

+ (NSDictionary *)getUserCenterMessageWithMemberID:(NSInteger)memberid token:(NSString *)token {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:memberid] forKey:@"MemberID"];
    return [self GetURLWithMethodName:@"MyCenter/HaveMyCenterDetail" param:param];
}



+ (NSDictionary *)UserUpDateHeaderImaegWith:(NSString *)imageUrl{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:userInfo.MemberID forKey:@"MemberID"];
    [param setValue:imageUrl forKey:@"HeadImgUrl"];
    return [self GetURLWithMethodName:@"Accounts/ModifyHeadImg" param:param];
}

+ (NSDictionary *)FirstRegisteredWithUserInformationWithHeaderImageURL:(NSString *)headerURL loginName:(NSString *)name Birthday:(NSString *)birthDay Gender:(NSInteger )gender{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:headerURL forKey:@"HeadImgUrl"];
    [param setValue:name forKey:@"LoginName"];
    [param setValue:birthDay forKey:@"Birthday"];
    [param setValue:@(gender) forKey:@"Gender"];
    return [self GetURLWithMethodName:@"MyCenter/ModifyMaturityInfo" param:param];
}


+ (NSDictionary *)UserCenterWithHaveBrowseListWithPage:(NSInteger )page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:@(page) forKey:@"PageIndex"];
    [param setValue:@(kDefaultRequestPageSize) forKey:@"PageSize"];
    return [self GetURLWithMethodName:@"MyCenter/HaveBrowseList" param:param];
}

+ (NSDictionary *)UpdaUserCenterModifySignatureWith:(NSString *)textString{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:userInfo.MemberID forKey:@"MemberID"];
    [param setValue:textString forKey:@"Signature"];
    return [self GetURLWithMethodName:@"MyCenter/ModifySignature" param:param];
}

+ (NSDictionary *)UserSetInviteCodeWithNumber:(NSString *)code{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:userInfo.MemberID forKey:@"MemberID"];
    [param setValue:code forKey:@"InviteCode"];
    return [self GetURLWithMethodName:@"Accounts/SetInvite" param:param];
}


+ (NSDictionary *)GetUserVedioListWithPage:(NSInteger)page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[self getUserIdWithLoginStatus] forKey:@"MemberID"];
    [param setValue:@(page) forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"Videos/HaveVideosList" param:param];
}

+ (NSDictionary *)RemoveUserVedioListWithVideoIdStr:(NSString *)idStr{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:userInfo.MemberID forKey:@"MemberID"];
    [param setValue:idStr forKey:@"IdStr"];
    return [self GetURLWithMethodName:@"Videos/DelAudio" param:param];
}

+ (NSDictionary *)UserTupUpGoldWithAliPayWithGoldNumber:(NSString *)number Subject:(NSString *)subject{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:userInfo.MemberID forKey:@"MemberID"];
    [param setValue:subject forKey:@"Subject"];
    [param setObject:number forKey:@"TotalAmount"];
    [param setObject:@"充值理想币" forKey:@"Body"];
    [param setObject:@(0) forKey:@"ProductId"];
    [param setObject:@(0) forKey:@"Goods_type"];
    return [self GetURLWithMethodName:@"Payments/AlipayPayments" param:param];
}

+ (NSDictionary *)UserTupUpGoldWithWXPayWithGoldNumber :(NSString *)number Subject:(NSString *)subject{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setObject:number forKey:@"TotalAmount"];
    [param setObject:@"充值理想币" forKey:@"Subject"];
   [param setValue:[NSString stringWithFormat:@"理想币详情,充值%@,个",number] forKey:@"Body"];
    return [self GetURLWithMethodName:@"Payments/WXAlipayPayments" param:param];
}

+ (NSDictionary *)UserGetBlockListWithPageIndex:(NSInteger )page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:@(page) forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"MyCenter/HaveBurnNoticeList" param:param];
}

+ (NSDictionary *)DontLookWhoDynamicWithPageIndex:(NSInteger )page {
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:@(page) forKey:@"PageIndex"];
    return [self GetURLWithMethodName:@"MyCenter/HaveBlockTrendsList" param:param];
}

+ (NSDictionary *)ModifyTheHomeAddressWith:(NSString *)address{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:address forKey:@"Hometown"];
    return [self GetURLWithMethodName:@"MyCenter/ModifyHometown" param:param];
}

+ (NSDictionary *)ModifyTheBirthDayWith:(NSString *)birthDay{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:birthDay forKey:@"Birthday"];
    return [self GetURLWithMethodName:@"MyCenter/ModifyBirthday" param:param];
}

+ (NSDictionary *)ModifyIndividualLabelWith:(NSString *)type{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:type forKey:@"SkillsTag"];
    return [self GetURLWithMethodName:@"MyCenter/ModifySkillsTag" param:param];
}
+ (NSDictionary *)BindingMobilePhoneNumber:(NSString *)phoneNumber Code:(NSString *)code LoginPwd:(NSString *)loginPwd{
    NSMutableDictionary *param = [NSMutableDictionary new];
    UserInfoData *userInfo = [UserInfoData getUserDefault];
    [param setValue:userInfo.token forKey:@"token"];
    [param setValue:[NSNumber numberWithInteger:userInfo.MemberID] forKey:@"MemberID"];
    [param setValue:phoneNumber forKey:@"Mobile"];
    [param setValue:code forKey:@"VerifyCode"];
    [param setValue:loginPwd forKey:@"LoginPwd"];
    return [self GetURLWithMethodName:@"Accounts/BindMobile" param:param];
}
@end
