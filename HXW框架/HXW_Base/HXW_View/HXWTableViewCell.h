//
//  HXWTableViewCell.h
//  HXW框架
//
//  Created by hxw on 16/4/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
//继承这个cell可以更简便的去控制cell的分割线
@interface HXWTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bottomLine;
@property (nonatomic, strong) UIImageView *headLine;//默认hidden ＝ yes
@end
