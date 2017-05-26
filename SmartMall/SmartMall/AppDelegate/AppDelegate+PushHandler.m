//
//  AppDelegate+PushHandler.m
//  SmartMall
//
//  Created by JianRongCao on 26/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#import "AppDelegate+PushHandler.h"
#import <UserNotifications/UserNotifications.h>


@implementation AppDelegate (PushHandler)

//本地推送通知
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //成功注册registerUserNotificationSettings:后，回调的方法
    NSLog(@"%@",notificationSettings);
}

#pragma mark -
#pragma mark APNS
//获取DeviceToken成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //向APNS注册成功，收到返回的deviceToken
    NSString *token=[NSString stringWithFormat:@"%@",deviceToken];
    token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [NSUserDefaultsManager setValue:token forKey:kLastAPNSToken];
    //注册成功后，注册服务器推送
    DLog(@"apns token:%@",token);
}

//向APNS注册失败，返回错误信息error
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

//iOS 10之前收到通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications] ;
    //收到远程推送通知消息
    if ( application.applicationState == UIApplicationStateActive )// app was already in the foreground
    {
        [self manageForegroundPushUserinfo:userInfo];
    }
    else {
        // app was just brought from background to foreground
        [self managePushUserinfo:userInfo];
    }
}

//foreground ios10 push
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        DLog(@"iOS10 收到远程通知:%@",userInfo);
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [self manageForegroundPushUserinfo:userInfo];
        }
        else {
            [self managePushUserinfo:userInfo];
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{////nbody:%@，////ntitle:%@,////nsubtitle:%@,////nbadge：%@，////nsound：%@，////nuserInfo：%@////n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            [self manageForegroundPushUserinfo:userInfo];
        }
        else {
            [self managePushUserinfo:userInfo];
        }
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{////nbody:%@，////ntitle:%@,////nsubtitle:%@,////nbadge：%@，////nsound：%@，////nuserInfo：%@////n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(); // 系统要求执行这个方法
}

//处理APNS推送消息
-(void)managePushUserinfo:(NSDictionary *)userInfo
{
    NSString *d = stringFromDic(userInfo, @"d");
    if ([RMUtils isValidString:d]) {
        NSArray *darray = [d componentsSeparatedByString:@"|"];
        if (darray && darray.count >= 2) {
            NSString *type = [darray objectAtIndex:0];
            if ([@"13" isEqualToString:type]) {
                NSString *serviceId = [darray objectAtIndex:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationDidReciveAPNSPush"
                                                                   object:@{@"pushType":@"pushType",@"serviceId":serviceId}];
            }
        }
    }
}

-(void)manageForegroundPushUserinfo:(NSDictionary *)userInfo
{
    NSString *d = stringFromDic(userInfo, @"d");
    if ([RMUtils isValidString:d]) {
        NSArray *darray = [d componentsSeparatedByString:@"|"];
        if (darray && darray.count >= 2) {
            NSString *type = [darray objectAtIndex:0];
            if ([@"13" isEqualToString:type]) {
                NSString *serviceId = [darray objectAtIndex:1];
                if ([RMUtils isValidString:serviceId]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationDidReciveAPNSPush"
                                                                        object:@{@"pushType":@"pushType",@"serviceId":serviceId}];
                }
            }
        }
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
}

@end
