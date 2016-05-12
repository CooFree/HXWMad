//
//  HXWWenXinCell.h
//  HXW框架
//
//  Created by hxw on 16/4/6.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTableViewCell.h"
#import "HXWWeiXinModel.h"
static NSString * const HXWWeiXinCellIdentifier = @"HXWWeiXinCellIdentifier";
@interface HXWWenXinCell : HXWTableViewCell
@property (nonatomic, strong) HXWWeiXinModel *model;
@property (nonatomic, assign) NSInteger idx;
@property (nonatomic, copy) void(^tapMoreBtnBlock)(NSInteger idx);
-(void)setModel:(HXWWeiXinModel *)model;
@end
