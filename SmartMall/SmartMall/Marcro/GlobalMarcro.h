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

//当前系统版本
#define IOS10_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER	([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

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
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

#define NSUserDefaultsManager  [NSUserDefaults standardUserDefaults]

#endif /* GlobalMarcro_h */
