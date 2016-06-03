//
//  NSTimer+Extension.m
//  HXW框架
//
//  Created by hxw on 16/3/24.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer(Extension)

-(void)pause
{
    //定时器是否被释放了
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

-(void)resume
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

@end
