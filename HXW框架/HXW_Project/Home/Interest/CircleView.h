//
//  circleView.h
//  HXW框架
//
//  Created by hxw on 16/6/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
@property (nonatomic, assign) int radius;//半径
@property (nonatomic, assign) int lineWidth;//宽度
@property (nonatomic, assign) CGFloat duration;//动画时间
@property (nonatomic, strong) NSString *centerTitle;
@property (nonatomic, strong) NSArray *itemAry;
@property (nonatomic, strong) NSArray *colorAry;
@property (nonatomic, strong) NSArray *pecentAry;
@end
