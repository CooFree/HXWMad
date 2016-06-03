//
//  HXWViewController.h
//  HXW框架
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXWViewController : UIViewController
@property (nonatomic, strong, readonly) NSString *msgKey;//发送通知的key
@property (nonatomic, strong) UIViewController *rootViewController;//window的跟控制器
-(id)initWithMsgKey:(NSString *)msgKey;//初始化时注册通知

@end
