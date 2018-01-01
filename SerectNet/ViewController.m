//
//  ViewController.m
//  SerectNet
//
//  Created by 王攀登 on 2018/1/1.
//  Copyright © 2018年 王攀登. All rights reserved.
//

#import "ViewController.h"

#import <YYModel.h>

#import "HomeModel.h"
#import "NetManager.h"
#import "UrlParamManager.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *todayNewArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //后台返回数据
//    {
//    "err_no": 0,
//    "err_msg": "success",
//    "results": {
//        "list": {
//            "0": {
//                "id": "1688",
//                "pic": "http://video.xinlingmingdeng.com/5a0993a96a0f4.mp4?vframe/jpg/offset/3",
//                "click": "78",
//                "title": "装睡的猫",
//                "video": "http://video.xinlingmingdeng.com/5a0993a96a0f4.mp4",
//                "video_width": 400,
//                "video_height": 400,
//                "seo_description": "事实再一次的证明了 你永远叫不醒一个正在装睡的生物 我都怀疑它是不是聋了或是带耳塞了 真的叫不动"
//            },
//            "1": {
//                "id": "1687",
//                "pic": "http://video.xinlingmingdeng.com/5a0992ee5c2a1.mp4?vframe/jpg/offset/3",
//                "click": "22",
//                "title": "剁手后吃土…",
//                "video": "http://video.xinlingmingdeng.com/5a0992ee5c2a1.mp4",
//                "video_width": 400,
//                "video_height": 400,
//                "seo_description": "双十一疯狂过后就只能吃土了 但最悲催的却是只能一个手吃土 看着剁掉的手心痛啊"
//            },
//            "2": {
//                "id": "1686",
//                "pic": "http://video.xinlingmingdeng.com/5a09921f3ada9.mp4?vframe/jpg/offset/3",
//                "click": "55",
//                "title": "广场舞",
//                "video": "http://video.xinlingmingdeng.com/5a09921f3ada9.mp4",
//                "video_width": 400,
//                "video_height": 400,
//                "seo_description": "这个就有点厉害了 老爷爷跳的很标准啊  比孙女的还好一点  一看就是平时多练的啊"
//            },
//            "3": {
//                "id": "1685",
//                "pic": "http://video.xinlingmingdeng.com/5a09911baba47.mp4?vframe/jpg/offset/3",
//                "click": "41",
//                "title": "不能护食",
//                "video": "http://video.xinlingmingdeng.com/5a09911baba47.mp4",
//                "video_width": 400,
//                "video_height": 400,
//                "seo_description": "猫怎么都可以惯着 就是不能惯着护食 不然他会越来越独的  不过你这表情 也有点假吧"
//            },
//            "4": {
//                "id": "1684",
//                "pic": "http://video.xinlingmingdeng.com/5a09902bd7b0b.mp4?vframe/jpg/offset/3",
//                "click": "93",
//                "title": "决斗",
//                "video": "http://video.xinlingmingdeng.com/5a09902bd7b0b.mp4",
//                "video_width": 400,
//                "video_height": 400,
//                "seo_description": "土拨鼠大战山羊 土拨鼠站起来的时候我特别怕它突然大叫一声 这个是不是看段子的后遗症啊"
//            },
//            "5": {
//                "id": "1683",
//                "pic": "http://video.xinlingmingdeng.com/5a084bcfa8b14.mp4?vframe/jpg/offset/3",
//                "click": "67",
//                "title": "跳跃式阅读",
//                "video": "http://video.xinlingmingdeng.com/5a084bcfa8b14.mp4",
//                "video_width": 400,
//                "video_height": 400,
//                "seo_description": "这孩子此后必成大器，学习的精神头还是蛮大的，继续加油"
//            }
//        },
//        "pager": {
//            "total": 1476,
//            "pages": 246,
//            "page": 22,
//            "size": 6,
//            "next": 23,
//            "prev": 21,
//            "pagesize": 6,
//            "pageArray": {
//                "0": 19,
//                "1": 20,
//                "2": 21,
//                "3": 22,
//                "4": 23,
//                "5": 24,
//                "6": 25
//            }
//        },
//        "pagers": "\t\t<a href=\"/?orderby=id&sortby=DESC&cid=&page=1\">首页</a>\r\n\t\t<a href=\"/?orderby=id&sortby=DESC&cid=&page=21\">上一页</a>\r\n\t\t<a href=\"/?orderby=id&sortby=DESC&cid=&page=19\" class=\"page_number\">19</a>\n\r<a href=\"/?orderby=id&sortby=DESC&cid=&page=20\" class=\"page_number\">20</a>\n\r<a href=\"/?orderby=id&sortby=DESC&cid=&page=21\" class=\"page_number\">21</a>\n\r<a href=\"/?orderby=id&sortby=DESC&cid=&page=22\" class=\"page_number cur\">22</a>\n\r<a href=\"/?orderby=id&sortby=DESC&cid=&page=23\" class=\"page_number\">23</a>\n\r<a href=\"/?orderby=id&sortby=DESC&cid=&page=24\" class=\"page_number\">24</a>\n\r<a href=\"/?orderby=id&sortby=DESC&cid=&page=25\" class=\"page_number\">25</a>\n\r\r\n\t\t<a href=\"/?orderby=id&sortby=DESC&cid=&page=23\">下一页</a>\r\n\t\t<a href=\"/?orderby=id&sortby=DESC&cid=&page=246\">末页</a>"
//    },
//    "runtime": 0.011618
//   }
    
    // 首页今日上新数据请求
    NSDictionary *urlParam = [UrlParamManager homeRecommendUrlWithType:@"news" size:6 page:1];
    [NetManager postSignRequestWithUrlParam:urlParam finished:^(id responseObj) {
        NSDictionary *resultDic = responseObj[@"results"];
        if (resultDic) {
            NSDictionary *listDic = resultDic[@"list"];
            //  排序是因为后台给的数据是自然数对应的内容
            NSArray *sortArray = [[listDic allKeys] sortedArrayUsingFunction:customSortKey context:nil];
            NSArray *array = [listDic objectsForKeys:sortArray notFoundMarker:@""];
            if (array.count > 0) {
                [_todayNewArray removeAllObjects];
                [array enumerateObjectsUsingBlock:^(NSDictionary *contentDic, NSUInteger idx, BOOL * _Nonnull stop) {
                    [_todayNewArray addObject:[HomeModel yy_modelWithDictionary:contentDic]];
                }];
//                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } failed:^(NSString *errorMsg) {
        NSLog(@"error:%@",errorMsg);
    }];

    
//    上传视频
//    NSData *pathData = [outputURL.path dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *urlParam = [UrlParamManager uploadFileWithType:1 fileData:pathData extraFormat:nil];
//    [SVProgressHUD show];
//    [NetManager postSignRequestWithUrlParam:urlParam progress:^(NSProgress * progress){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progress.fractionCompleted>=1) {
//                [SVProgressHUD showInfoWithStatus:@"即将上传完毕请稍等..."];
//            }else{
//                [SVProgressHUD showProgress:progress.fractionCompleted status:@"视频上传中..."];
//            }
//        });
//    } finished:^(id responseObj) {
//        if ([responseObj[@"err_no"] integerValue] == kResOK) {
//            [SVProgressHUD dismiss];
//            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObj options:0 error:nil];
//            NSString *videoJsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            FindEditDynamicController *findEditDynamicVC = [[FindEditDynamicController alloc] initWithVideoUrl:videoJsonStr coverImage:corverImage];
//            [self.navigationController pushViewController:findEditDynamicVC animated:YES];
//        }else {
//            [SVProgressHUD showErrorWithStatus:responseObj[@"err_msg"]];
//        }
//    } failed:^(NSString *errorMsg) {
//        RSLog(@"error:%@",errorMsg);
//        [SVProgressHUD showErrorWithStatus:errorMsg];
//    }];
}




@end
