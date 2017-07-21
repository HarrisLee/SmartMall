//
//  GlobalMarcro.h
//  SmartMall
//
//  Created by JianRongCao on 24/05/2017.
//  Copyright © 2017 SmartHome. All rights reserved.
//

#ifndef GlobalMarcro_h
#define GlobalMarcro_h

#define WS(weakSelf)   __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

//角度转弧度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
//弧度转角度
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

//当前系统版本
#define IOS10_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >=  9.0)
#define IOS8_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >=  8.0)

//日志打印
#ifdef DEBUG
#define LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define DATE [NSDate stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]
#define DLog(FORMAT, ...) fprintf(stderr,"\n%s %s:%s 第%d行:%s\n\n",[DATE UTF8String],[LRString UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#endif

//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//屏幕的宽和高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define RMUserDefaults  [NSUserDefaults standardUserDefaults]

//跳转系统隐私
#define RM_GO_SYSTEM_PRIVACY \
{\
NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Privacy"];\
if ([[UIApplication sharedApplication] canOpenURL:url]) {\
[[UIApplication sharedApplication] openURL:url];\
}\
}

//跳转app隐私
#define RM_GO_APP_PRIVACY \
{\
NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];\
if ([[UIApplication sharedApplication] canOpenURL:url]) {\
[[UIApplication sharedApplication] openURL:url];\
}\
}

#endif /* GlobalMarcro_h */
