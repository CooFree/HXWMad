//
//  UIImage+ThemeKit.m
//  HXWProjectNotes
//
//  Created by hxw on 15/8/20.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "UIImage+ThemeKit.h"

@implementation UIImage(ThemeKit)
-(UIImage*)stretch
{
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
/**
    *UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
    *UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
    *UIEdgeInsets通过设置UIEdgeInsets的left、right、top、bottom来分别指定左端盖宽度、右端盖宽度、顶端盖高度、底端盖高度来指定拉伸范围
*/
    UIImage *image = [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return image;
}
@end
