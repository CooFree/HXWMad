//
//  UIView+autolayout.m
//  HXW框架
//
//  Created by hxw on 16/5/25.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "UIView+autolayout.h"

@implementation UIView(autolayout)

+ (id)newAutolayoutView
{
    id newObject = [[(Class)self alloc]init];
    [newObject setTranslatesAutoresizingMaskIntoConstraints:NO];//此处必须设置与AutoresizingMask不冲突
    return newObject;
}

- (void)layoutConstraintWithVisualFormat:(NSString *)visualFormat
                                 options:(NSLayoutFormatOptions)options
                                 metrics:(NSDictionary *)metrics
                                   views:(NSDictionary *)autolayoutViews
{
    NSMutableArray *stringAry = [[NSMutableArray alloc]init];
    NSMutableString *str = [NSMutableString string];
    if (visualFormat.length > 0) {
        for (int i = 0; i < [visualFormat length]; i ++) {
            if (i == ([visualFormat length] - 1)) {
                [str appendString:[NSString stringWithFormat:@"%@",[visualFormat substringWithRange:NSMakeRange(i, 1)]]];
                [stringAry addObject:[NSString stringWithFormat:@"%@",str]];
                break;
            }
            
            NSString *checkStr = [visualFormat substringWithRange:NSMakeRange(i, 2)];
            if ([checkStr isEqualToString:@"H:"]||[checkStr isEqualToString:@"V:"]) {
                if ([str length] > 0) {
                    [stringAry addObject:[NSString stringWithFormat:@"%@",str]];
                    [str deleteCharactersInRange:NSMakeRange(0, [str length])];
                }
            }
            [str appendString:[NSString stringWithFormat:@"%@",[visualFormat substringWithRange:NSMakeRange(i, 1)]]];
        }
    }
    
    [stringAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableString *visual = [NSMutableString stringWithFormat:@"%@",stringAry[idx]];
        if (idx != stringAry.count - 1) {
            [visual deleteCharactersInRange:NSMakeRange([visual length] - 1, 1)];
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visual options:options metrics:metrics views:autolayoutViews]];
    }];
}

@end
