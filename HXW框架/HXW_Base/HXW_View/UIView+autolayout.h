//
//  UIView+autolayout.h
//  HXW框架
//
//  Created by hxw on 16/5/25.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(autolayout)
/*
 此为UIView的autolayout类别，给UIView增加自动布局的自定义方法，可以把横向和竖向的约束都写在一起
 */
+ (id)newAutolayoutView;
- (void)layoutConstraintWithVisualFormat:(NSString *)visualFormat
                                 options:(NSLayoutFormatOptions)options
                                 metrics:(NSDictionary *)metrics
                                   views:(NSDictionary *)autolayoutViews;


@end
