//
//  UrlManager.h
//  RepublicShare
//
//  Created by 王攀登 on 2017/8/24.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UrlType) {
    UrlTypeUser,  //user
    UrlTypeApi,   //api 视频相关
    UrlTypeUpload,//上传
};
// 返回结果 根据key排序 获取数组 （自然数排序）
NSInteger customSortKey(id obj1, id obj2,void* context);

@interface UrlParamManager : NSObject

//抱品网
//注册
+ (NSDictionary *)registerUserWithPhone:(NSString *)phone vCode:(NSString *)vCode password:(NSString *)password;
//验证码
+ (NSDictionary *)sendSMSCodeWithMobile:(NSString *)phone;
// 登陆
+ (NSDictionary *)loginInUserWithAccount:(NSString *)account password:(NSString *)password;
// 第三方登陆
+ (NSDictionary *)theThirdPartLoginWithOpenid:(NSString *)openid access_token:(NSString *)access_token;
// 用户详情
+ (NSDictionary *)getUserDetailWithMemberID:(NSString *)memberId mobile:(NSString *)mobile;
// 抱友秀title分类列表
+ (NSDictionary *)baoyouTabListUrl;

// 今日上新 / 抱友精选
+ (NSDictionary *)homeRecommendUrlWithType:(NSString *)type size:(NSInteger)size page:(NSInteger)page;

// 抱友秀video列表
+ (NSDictionary *)baoyouShowVideoListUrlWithTabId:(NSString *)tabId page:(NSInteger)page;
// 播放视频详情 -- 抱友的
+ (NSDictionary *)playViewVideoDetailInUserWithVideoId:(NSString *)videoId;
// 播放视频详情 -- 平台的
+ (NSDictionary *)playViewVideoDetailInPlatWithVideoId:(NSString *)videoId;
// 首页 - 轮播图
+ (NSDictionary *)HomeCycleScrollUrl;
// 个人详情 - 视频列表     看别人时 传uid ismyself为NO   看自己时 不用穿Uid ismyself为Yes
+ (NSDictionary *)UserVideoListUrlWithUid:(NSString *)uid page:(NSInteger)page isMyself:(BOOL)isMyself;
// 我的 - 关注列表
+ (NSDictionary *)MineFocusListWithPage:(NSInteger )page;
// 我的 - 修改 名字/个性签名
+ (NSDictionary *)changeMineInfoWithNickName:(NSString *)nick signature:(NSString *)signature;
// 我的 - 修改密码
+ (NSDictionary *)changeMineInfoWithPassWord:(NSString *)newPass oldPass:(NSString *)oldPass;
// 我的 - 忘记密码找回
+ (NSDictionary *)resetMineInfoWithPassWord:(NSString *)newPass mobile:(NSString *)mobile vCode:(NSString *)vCode;
// 上传文件 -图片
+ (NSDictionary *)uploadFileWithImageWithFileContent:(id)fileContent;
// 上传文件 -视频
+ (NSDictionary *)uploadFileWithVideoWithFileContent:(id)fileContent;
// 搜索 - 热门推荐
+ (NSDictionary *)searchHotDataList;
// 搜索 - 关键字内容搜索
+ (NSDictionary *)searchDataWithKey:(NSString *)key pageIndex:(NSNumber *)page;
// 视频 - 举报
+ (NSDictionary *)ReportVideoWithVideoId:(NSString *)vid content:(NSString *)content;
// 我的关注
+ (NSDictionary *)findHaveMomentsListWithPage:(NSInteger )page;
// 我的 - 我的视频删除接口
+ (NSDictionary *)deleteMyVideoWithVideoString:(NSString *)videoStr;
// 首页详情 - 添加关注 state:0； 取消关注 state:1
+ (NSDictionary *)UserAddOrRemoveFansFirendWithFollowID:(NSInteger )followID State:(NSInteger )state;
// 点赞 state:0； 取消点赞 state:1
+ (NSDictionary *)ZanOrCancleZanWithVideoId:(NSString *)videoID state:(NSInteger )state;

// 首页详情 - 是否关注
+ (NSDictionary *)isFansFirendWithFollowID:(NSInteger )followID;
// 视频 - 评论列表接口 -- 抱友的
+ (NSDictionary *)PlayUserVideoCommentListWithVideoId:(NSString *)vid page:(NSInteger )page;
// 视频 - 评论列表接口 -- 平台的
+ (NSDictionary *)PlayPlatVideoCommentListWithVideoId:(NSString *)vid page:(NSInteger )page;
// 视频 - 添加评论接口
+ (NSDictionary *)PlayVideoAddCommentWithVideoId:(NSString *)vid content:(NSString *)content sourceType:(NSInteger)sourceType;
// 关注 - 我的朋友圈
+ (NSDictionary *)userFriendsCircleWithPage:(NSInteger)page;

// 文件上传 type: 0(image) / 1(video)
+ (NSDictionary *)uploadFileWithType:(NSInteger )type fileData:(NSData *)fileData extraFormat:(void(^)(void(^)(BOOL is_thumb,NSInteger thumb_width,NSInteger thumb_height,NSInteger is_resize,NSInteger resize_width,NSInteger resize_height)))extraFormat;

// 我的 - 更新用户头像
+ (NSDictionary *)UserUpDateHeaderImaegWithPicJson:(NSDictionary *)picJson;

// 朋友圈 - 发布视频
+ (NSDictionary *)findPublishDynamicWithTitle:(NSString *)title publishType:(NSInteger )type video_json:(NSString *)video_json desContent:(NSString *)desContent extraFormat:(void(^)(void(^extraHandle)(NSString *goods_url,NSString * goods_title,NSString * goods_json,NSString * goods_price)))extraFormat;

// 金山云短视频鉴权
+ (NSDictionary *)KsAuthenUrlParamWithBundleId:(NSString *)boundleid;



// 老项目
#pragma mark ============= 老项目  ==============
/**
 *  首页 -  标签
 */
+ (NSDictionary *)homeTabUrl;

/**
 *  首页 -  除推荐外 其他标签的视频列表
 */
+(NSDictionary *)homeHaveTabVideosWithTabID:(NSString *)TabID TabName:(NSString *)TabName OrderType:(NSString *)OrderType PageIndex:(NSNumber *)page;

/**
 *  首页 -  轮播图接口
 */
+ (NSDictionary *)recommendCycleScrollUrl;

/**
 *  首页 -  附近的人接口
 */
+ (NSDictionary *)recommendNearbyUrlWithPosionX:(NSNumber *)posionX posionY:(NSNumber *)posionY pageIndex:(NSNumber *)page;

/**
 *  搜索 -  热门标签
 *  获取技能标签接口
 *  类型(1:视频技能 2:个人技能 3:搜索标签)
 */
+ (NSDictionary *)skillTabListWithTypeId:(NSString *)typeId;

///**
// *  搜索 -  关键字搜索
// */
//+ (NSDictionary *)searchDataWithKey:(NSString *)key pageIndex:(NSNumber *)page;

/**
 *  播放界面 - 视频播放详情
 */
+ (NSDictionary *)playViewDetailDataWithVedioId:(NSString *)vedioId;

/**
 *  播放界面 - 视频评论列表
 */
+ (NSDictionary *)playViewVideoCommendDataWithVedioId:(NSString *)vedioId pageIndex:(NSNumber *)page ;

/**
 *  播放界面 - 增加播放量
 */
+ (NSDictionary *)playViewAddPlayAcountWithVideoId:(NSString *)videoId;

/**
 *  播放界面 - 上传评论视频
 */

+ (NSDictionary *)playViewPublishVideoCommentWithVideoID:(NSString *)videoId Comments:(NSString *)comments ImageUrl:(NSString *)imageUrl VideoUrlStand:(NSString *)videoUrlStand;


/**
 *  播放界面 - 视频评论 删除
 */
+ (NSDictionary *)videoCommentRemoveVedioCommentWithVideoId:(NSString *)videoId commentId:(NSString *)commentId;

/**
 *  主播详情 - 基本信息
 */
+ (NSDictionary *)anchorDetailBaseDataWithMembeId:(NSString *)memberId;

/**
 *  主播详情 - 视频列表
 */
+ (NSDictionary *)anchorDetailVideoDataWithMembeId:(NSString *)memberId pageIndex:(NSNumber *)page;

/**
 *  金山云短视频鉴权
 */
+ (NSDictionary *)KsAuthenticWithPackageName:(NSString *)packageName;

/**
 *  视频点赞
 */
+ (NSDictionary *)videoClickZanWithVideoId:(NSString *)videoID state:(NSInteger )state;

/**
 *  视频评论 ——功能按钮操作
 *  type   操作行为(1:点赞 2:踩 3:举报)
 *  state  点赞状态 （0：取消 1:确认）
 */
+ (NSDictionary *)videoCommentFunctionBtnActionWithVideoId:(NSString *)videoID type:(NSInteger )type state:(NSInteger )state;

/**
 *  发现 - 发布朋友圈
 */
+ (NSDictionary *)findPublishDynamicWithTitle:(NSString *)title ImageUrl:(NSString *)imageUrl VideoUrlStand:(NSString *)videoUrlStand  desContent:(NSString *)desContent;

/**
 *  屏蔽好友朋友圈
 *  state  是否屏蔽(0:否 1:是)
 */
+ (NSDictionary *)dealBlockTrendsWithFollowID:(NSString *)followID state:(NSInteger )state;

/**
 *  加入黑名单
 *  状态(0:加入黑名单 1:取消黑名单)
 */
+ (NSDictionary *)dealBlackListWithBurnMemberId:(NSString *)burnMemberID state:(NSInteger )state;

/**
 *  检查更新
 *  searchCode 版本号
 */
+ (NSDictionary *)updateExamineWithCurrentVesion:(NSString *)vesion;

#pragma mark ============= by 鸥人  ==============

///**
// *  注册
// */
//+ (NSDictionary *)registerUserWithPhone:(NSString *)phone vCode:(NSString *)vCode password:(NSString *)password;

///**
// *  登陆
// */
//+ (NSDictionary *)loginInUserWithPhone:(NSString *)phone password:(NSString *)password;

/**
 *  忘记密码
 */

+ (NSDictionary *)UserUpDataPassWordWithPhone:(NSString *)phone vCode:(NSString *)vCode newPassword:(NSString *)newPassword;

/**
 *  修改昵称
 */
+ (NSDictionary *)ModifyTheNicknameWith:(NSString *)nick;

/**
 *  修改性别
 */
+ (NSDictionary *)ModifyTheSexWith:(NSInteger )sex;

/**
 *  修改密码
 */
+ (NSDictionary *)UserUpDataPassWordWithOldPassWord:(NSString *)oldPassWord newPassword:(NSString *)newPassword sessionKey:(NSString *)sessionKey MemberID:(NSInteger )MemberID;

/**
 *  第三方登陆
 */
+ (NSDictionary *)ThethirdPartyLandedWithOpenId:(NSString *)openID AccessToken:(NSString *)accessToken nickName:(NSString *)nickname Gender:(NSString *)gender IconUrl:(NSString*)iconUrl Type:(NSInteger )type;

/**
 *  关注数量
 */
+ (NSDictionary *)MineConcernNumberWithSessionKeyAndMenberIDWithPage:(NSInteger )page;

/**
 *  粉丝数量
 */
+ (NSDictionary *)MineFansNumberWithSessionKeyAndMenberIDWithPage:(NSInteger )page;

/**
// *  用户中心
// */
//+ (NSDictionary *)getUserCenterMessageWithMemberID:(NSInteger)memberid sessionKey:(NSString *)sessionKey;
/**
 *  首次注册完善信息
 */
+ (NSDictionary *)FirstRegisteredWithUserInformationWithHeaderImageURL:(NSString *)headerURL loginName:(NSString *)name Birthday:(NSString *)birthDay Gender:(NSInteger )gender;

/**
 *  上传图片或者视频
 */
+ (NSDictionary *)UserUpDateFileWithImageORVedioWithType:(NSInteger )type FolderName:(NSString *)folderName FileName:(NSString *)fileName FileContent:(NSString *)fileContent;

/**
 *  修改头像
 */
+ (NSDictionary *)UserUpDateHeaderImaegWith:(NSString *)imageUrl;

/**
 *  谁看过我
 */
+ (NSDictionary *)UserCenterWithHaveBrowseListWithPage:(NSInteger )page;

/**
 *  个性签名
 */
+ (NSDictionary *)UpdaUserCenterModifySignatureWith:(NSString *)textString;

/**
 *  设置邀请码
 */
+ (NSDictionary *)UserSetInviteCodeWithNumber:(NSString *)code;

/**
 *  获取用户视频
 */
+ (NSDictionary *)GetUserVedioListWithPage:(NSInteger)page;

/**
 *  删除用户视频
 */
+ (NSDictionary *)RemoveUserVedioListWithVideoIdStr:(NSString *)idStr;

/**
 *  支付宝支付
 */
+ (NSDictionary *)UserTupUpGoldWithAliPayWithGoldNumber:(NSString *)number Subject:(NSString *)subject;

/**
 *  微信支付
 */
+ (NSDictionary *)UserTupUpGoldWithWXPayWithGoldNumber :(NSString *)number Subject:(NSString *)subject;

/**
 *  给名单
 */
+ (NSDictionary *)UserGetBlockListWithPageIndex:(NSInteger )page;

/**
 *  不看谁的动态
 */
+ (NSDictionary *)DontLookWhoDynamicWithPageIndex:(NSInteger )page;

/**
 *  修改家庭住址
 */
+ (NSDictionary *)ModifyTheHomeAddressWith:(NSString *)address;

/**
 *  修改生日
 */
+ (NSDictionary *)ModifyTheBirthDayWith:(NSString *)birthDay;

/**
 *  修改个人标签
 */
+ (NSDictionary *)ModifyIndividualLabelWith:(NSString *)type;
/**
 *  绑定手机号
 */
+ (NSDictionary *)BindingMobilePhoneNumber:(NSString *)phoneNumber Code:(NSString *)code LoginPwd:(NSString *)loginPwd;
@end
