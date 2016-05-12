//
//  UIView+Extension.h
//  HXW
//
//  Created by hxw on 16/3/15.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
-(void)sd_addSubViews:(NSArray *)subviews;
@end
