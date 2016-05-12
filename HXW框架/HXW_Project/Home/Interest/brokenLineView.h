//
//  brokenLineView.h
//  HXW框架
//
//  Created by hxw on 16/4/19.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface brokenLineView : UIView
@property (nonatomic, strong) NSArray *lineAry;//折线数据
@property (nonatomic, strong) NSArray *lineColorAry;//折线对应的颜色
@property (nonatomic, strong) NSArray *detailAry;//说明内容
@property (nonatomic, strong) NSArray *xAry;//x轴
@property (nonatomic, strong) NSArray *yAry;//y轴
@property (nonatomic, assign) CGFloat duration;//动画时间
@end
