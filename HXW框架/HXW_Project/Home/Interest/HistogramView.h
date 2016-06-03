//
//  HistogramView.h
//  HXW框架
//
//  Created by hxw on 16/6/2.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistogramView : UIView
@property (nonatomic, assign) CGFloat duration;//动画时间
@property (nonatomic, strong) NSArray *itemAry;//所有对象合集，元素为数组
@property (nonatomic, strong) NSArray *xAry;//x轴
@property (nonatomic, strong) NSArray *yAry;//y轴
@property (nonatomic, strong) NSArray *colorAry;
@end
