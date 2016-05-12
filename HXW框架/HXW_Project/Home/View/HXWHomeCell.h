//
//  HXWHomeCell.h
//  HXW框架
//
//  Created by hxw on 16/4/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const HXWHomeCellIdentification = @"HXWHomeCellIdentification";

@interface HXWHomeCell : UITableViewCell
@property (nonatomic, strong) NSString *content;
-(void)setContentStr:(NSString *)content;
@end
