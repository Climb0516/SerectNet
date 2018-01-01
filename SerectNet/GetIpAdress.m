//
//  GetIpAdress.m
//  BaoPinNet
//
//  Created by 王攀登 on 2017/12/6.
//  Copyright © 2017年 王攀登. All rights reserved.
//

#import "GetIpAdress.h"

#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

@implementation GetIpAdress

//获取ip地址
+(NSString *)getIPAddress {
    //    NSString *address = @"error";
    //    struct ifaddrs *interfaces = NULL;
    //    struct ifaddrs *temp_addr = NULL;
    //    int success = 0;
    //    // retrieve the current interfaces - returns 0 on success
    //    success = getifaddrs(&interfaces);
    //    if (success == 0) {
    //        // Loop through linked list of interfaces
    //        temp_addr = interfaces;
    //        while(temp_addr != NULL) {
    //            if(temp_addr->ifa_addr->sa_family == AF_INET) {
    //                // Check if interface is en0 which is the wifi connection on the iPhone
    //                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
    //                    // Get NSString from C String
    //                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
    //                }
    //            }
    //            temp_addr = temp_addr->ifa_next;
    //        }
    //    }
    //    // Free memory
    //    freeifaddrs(interfaces);
    //    return address;
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    //    if (sockfd <<sockfd>>0){
    //        return nil;
    //    }
    NSMutableArray *ips = [NSMutableArray array];
    int BUFFERSIZE = 4096;
    struct ifconf ifc;
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ],*cptr;
    struct ifreq *ifr, ifrcopy;
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        for (ptr = buffer; ptr < buffer + ifc.ifc_len;
             ){
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
                
            }            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
                continue;
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            if ((ifrcopy.ifr_flags & IFF_UP) == 0)         continue;
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    NSString *deviceIP = @"";
    for (int i=0; i < ips.count; i++)    {
        if (ips.count > 0)   {
        deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
//    NSArray *firstArray = [deviceIP componentsSeparatedByString:@"."];
//    return [firstArray componentsJoinedByString:@""];
    struct in_addr addr;
    if (inet_aton([deviceIP UTF8String], &addr) != 0) {
        uint32_t numIp = ntohl(addr.s_addr);
        NSLog(@"ip地址：%08x", numIp);
        return [NSString stringWithFormat:@"%u",numIp];
    } else {
        return NULL;
    }

}

@end
