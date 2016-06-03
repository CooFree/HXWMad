//
//  HXWConstantDefind.h
//  HXW框架
//
//  Created by hxw on 16/5/11.
//  Copyright © 2016年 hxw. All rights reserved.
//


//根控制器
#define RootViewController [UIApplication sharedApplication].keyWindow.rootViewController

#ifdef DEBUG // 处于开发阶段
#define HXWLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define HXWLog(...)
#endif
//字体大小
#define normalFont 14
//间距
#define padding 10

//对象归档存储路径
#define HXWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

// 通知中心
#define HXWNotificationCenter [NSNotificationCenter defaultCenter]

// RGB颜色
#define HXWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define HXWRandomColor HXWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
//监控屏幕周期
#define TouchEventMonitorTime 10000000