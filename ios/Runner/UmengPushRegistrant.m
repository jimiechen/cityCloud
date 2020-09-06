//
//  UmengPushRegistrant.m
//  Runner
//
//  Created by liboxiang on 2020/9/6.
//
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "UmengPushRegistrant.h"

@interface UmengPushRegistrant()
@property NSString *deviceToken;
@end

@implementation UmengPushRegistrant
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
                                   methodChannelWithName:@"umeng_push"
                                   binaryMessenger:[registrar messenger]];
 UmengPushRegistrant* instance = [[UmengPushRegistrant alloc] init];
 instance.channel = channel;
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"handleMethodCall:%@",call.method);

    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if([@"setBadge" isEqualToString:call.method]) {
        [self setBadge:call result:result];
    } else if([@"stopPush" isEqualToString:call.method]) {
        [self stopPush:call result:result];
    } else if([@"resumePush" isEqualToString:call.method]) {
        NSLog(@"ios platform not support resume push.");
        //[self applyPushAuthority:call result:result];
    } else if([@"clearAllNotifications" isEqualToString:call.method]) {
        [self clearAllNotifications:call result:result];
    } else if([@"getRegistrationID" isEqualToString:call.method]) {
        [self getRegistrationID:call result:result];
//    } else if([@"sendLocalNotification"isEqualToString:call.method]) {
//        [self sendLocalNotification:call result:result];
    } else{
        result(FlutterMethodNotImplemented);
    }
}


- (void)setBadge:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"setBadge:%@",call.arguments);
    NSInteger badge = [call.arguments[@"badge"] integerValue];
    if (badge < 0) {
        badge = 0;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badge];
}

- (void)stopPush:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"stopPush:");
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (void)resumePush:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"stopPush:");
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)clearAllNotifications:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"clearAllNotifications:");
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)getRegistrationID:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"getRegistrationID:");
    result(_deviceToken);
}

//- (void)sendLocalNotification:(FlutterMethodCall*)call result:(FlutterResult)result {
//    JPLog(@"sendLocalNotification:%@",call.arguments);
//    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
//    NSDictionary *params = call.arguments;
//    if (params[@"title"]) {
//        content.title = params[@"title"];
//    }
//    
//    if (params[@"subtitle"] && ![params[@"subtitle"] isEqualToString:@"<null>"]) {
//        content.subtitle = params[@"subtitle"];
//    }
//    
//    if (params[@"content"]) {
//        content.body = params[@"content"];
//    }
//    
//    if (params[@"badge"]) {
//        content.badge = params[@"badge"];
//    }
//    
//    if (params[@"action"] && ![params[@"action"] isEqualToString:@"<null>"]) {
//        content.action = params[@"action"];
//    }
//    
//    if ([params[@"extra"] isKindOfClass:[NSDictionary class]]) {
//        content.userInfo = params[@"extra"];
//    }
//    
//    if (params[@"sound"] && ![params[@"sound"] isEqualToString:@"<null>"]) {
//        content.sound = params[@"sound"];
//    }
//    
//    JPushNotificationTrigger *trigger = [[JPushNotificationTrigger alloc] init];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
//        if (params[@"fireTime"]) {
//            NSNumber *date = params[@"fireTime"];
//            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
//            NSTimeInterval interval = [date doubleValue]/1000 - currentInterval;
//            interval = interval>0?interval:0;
//            trigger.timeInterval = interval;
//        }
//    }
//    
//    else {
//        if (params[@"fireTime"]) {
//            NSNumber *date = params[@"fireTime"];
//            trigger.fireDate = [NSDate dateWithTimeIntervalSince1970: [date doubleValue]/1000];
//        }
//    }
//    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
//    request.content = content;
//    request.trigger = trigger;
//    
//    if (params[@"id"]) {
//        NSNumber *identify = params[@"id"];
//        request.requestIdentifier = [identify stringValue];
//    }
//    request.completionHandler = ^(id result) {
//        NSLog(@"result");
//    };
//    
//    [JPUSHService addNotification:request];
//    
//    result(@[@[]]);
//}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.获取推送通知的权限
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
           }];
        } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){// iOS8-iOS9
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
            [application registerUserNotificationSettings:settings];
        }
    // 2.注册远程推送
    [application registerForRemoteNotifications];
            
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
//    [application registerUserNotificationSettings:settings];
//    
//    
//    [application registerForRemoteNotifications];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //  _resumingFromBackground = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //  application.applicationIconBadgeNumber = 1;
    //  application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSMutableString * token = [NSMutableString stringWithFormat:@"%@",deviceToken];
//    token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
//    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    _deviceToken = token;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSDictionary *settingsDictionary = @{
        @"sound" : [NSNumber numberWithBool:notificationSettings.types & UIUserNotificationTypeSound],
        @"badge" : [NSNumber numberWithBool:notificationSettings.types & UIUserNotificationTypeBadge],
        @"alert" : [NSNumber numberWithBool:notificationSettings.types & UIUserNotificationTypeAlert],
    };
    [_channel invokeMethod:@"onIosSettingsRegistered" arguments:settingsDictionary];
}

- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@", userInfo);
    [_channel invokeMethod:@"onReceiveNotification" arguments:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    return YES;
}

// iOS 10 以下点击本地通知
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"application:didReceiveLocalNotification:");
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *title = @"";
    if (@available(iOS 8.2, *)) {
        title = notification.alertTitle;
    } else {
        // Fallback on earlier versions
    }
    
    NSString *body = notification.alertBody;
    NSString *action = notification.alertAction;
    
    [dic setValue:title?:@"" forKey:@"title"];
    [dic setValue:body?:@"" forKey:@"body"];
    [dic setValue:action?:@"" forKey:@"action"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:@"onOpenNotification" arguments:dic];
    });
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registfail，注册推送失败原因%@",error);
}

@end

