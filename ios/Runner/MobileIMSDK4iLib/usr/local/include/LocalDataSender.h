//  ----------------------------------------------------------------------
//  Copyright (C) 2020  即时通讯网(52im.net) & Jack Jiang.
//  The MobileIMSDK_X (MobileIMSDK v4.x) Project.
//  All rights reserved.
//
//  > Github地址: https://github.com/JackJiang2011/MobileIMSDK
//  > 文档地址:    http://www.52im.net/forum-89-1.html
//  > 技术社区：   http://www.52im.net/
//  > 技术交流群： 320837163 (http://www.52im.net/topic-qqgroup.html)
//  > 作者公众号： “即时通讯技术圈】”，欢迎关注！
//  > 联系作者：   http://www.52im.net/thread-2792-1-1.html
//
//  "即时通讯网(52im.net) - 即时通讯开发者社区!" 推荐开源工程。
//  ----------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "Protocal.h"

@interface LocalDataSender : NSObject

+ (LocalDataSender *)sharedInstance;

- (int) sendLogin:(NSString *)loginUserId withToken:(NSString *)loginToken;
- (int) sendLogin:(NSString *)loginUserId withToken:(NSString *)loginToken andExtra:(NSString *)extra;
- (int) sendLoginout;
- (int) sendKeepAlive;
- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id;
- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id withTypeu:(int)typeu;
- (int) sendCommonDataWithStr:(NSString *)dataContentWidthStr toUserId:(NSString *)to_user_id qos:(BOOL)QoS fp:(NSString *)fingerPrint withTypeu:(int)typeu;
- (int) sendCommonData:(Protocal *)p;

@end
