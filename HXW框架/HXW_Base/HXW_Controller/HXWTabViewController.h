//
//  HXWPageViewController.h
//  HXW微博
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWViewController.h"
typedef void (^changeCrlCompletedBlock)();
@interface HXWTabViewController : HXWViewController
@property (nonatomic, strong) NSArray *titleAry;//tab名称
@property (nonatomic, strong) NSArray *crlAry;//控制器名称
@property (nonatomic, strong) UIView *contentView;
-(void)changeCrlCompleted:(changeCrlCompletedBlock)block;
@end
