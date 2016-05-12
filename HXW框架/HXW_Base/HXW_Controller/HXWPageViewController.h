//
//  HXWPageViewController.h
//  HXW框架
//
//  Created by hxw on 16/3/30.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWViewController.h"

@interface HXWPageViewController : HXWViewController
@property (nonatomic, strong) NSArray *titleAry;//tab名称
@property (nonatomic, strong) NSArray *crlAry;//控制器名称
@property (nonatomic, strong) UIView *contentView;
@end
