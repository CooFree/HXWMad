//
//  HXWWindow.m
//  HXW框架
//
//  Created by hxw on 16/5/25.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWWindow.h"
#import "HXWLoginViewController.h"

@interface HXWWindow()<UIAlertViewDelegate>
{
    NSDate *lastTouchTime;
    NSTimer *eventMonitorTimer;
    UIAlertView *alertView;
}
@end

@implementation HXWWindow

-(instancetype)init
{
    if (self = [super init]) {
        eventMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(onEventMonitorTimeout) userInfo:nil repeats:YES];
        [eventMonitorTimer fire];
    }
    return self;
}

//iOS系统检测到手指触摸(Touch)操作时会将其放入当前活动Application的事件队列，UIApplication会从事件队列中取出触摸事件并传递给key window(当前接收用户事件的窗口)处理,window对象首先会使用hitTest:withEvent:方法寻找此次Touch操作初始点所在的视图(View),即需要将触摸事件传递给其处理的视图,称之为hit-test view。
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    lastTouchTime = [NSDate date];
    return [super hitTest:point withEvent:event];
}

-(void)onEventMonitorTimeout
{
    if ([HXWUserDefaults instance].userName.length == 0) {
        return;
    }
    else if (([[NSDate date] timeIntervalSince1970] - [lastTouchTime timeIntervalSince1970]) < TouchEventMonitorTime) {
        return;
    } else {
        NSString* msg = @"由于您长时间未操作，为保障您的帐户安全，请重新登陆";
        alertView = [[UIAlertView alloc] initWithTitle:@"消息提示"
                                               message:msg
                                              delegate:self
                                     cancelButtonTitle:@"确定"
                                     otherButtonTitles:nil];
        [alertView show];
        //弹出提示框时定时器暂停，不然后会有多个提示框重叠
        [eventMonitorTimer pause];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //提示框小时候，定时器开始
        [HXWUserDefaults instance].userName = nil;
        [HXWUserDefaults instance].userPwd = nil;
        [eventMonitorTimer resume];
        HXWLoginViewController *loginVc = [[HXWLoginViewController alloc]init];
        self.rootViewController = loginVc;
    }
}

-(void)dealloc
{
    [eventMonitorTimer invalidate];
}

@end
