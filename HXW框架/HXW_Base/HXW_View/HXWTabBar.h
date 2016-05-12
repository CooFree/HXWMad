//
//  HXWTabBar.h
//  HXW微博
//
//  Created by hxw on 16/3/14.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
// 因为HXWTabBar继承自UITabBar，所以称为HXWTabBar的代理，也必须实现UITabBar的代理协议

@class HXWTabBar;
@protocol clickCenterBtnDelegate <NSObject>

-(void)clickCenterBtn:(HXWTabBar *)tabBar;

@end

@interface HXWTabBar : UITabBar
@property (nonatomic, assign) id<clickCenterBtnDelegate> delegate;
@end
