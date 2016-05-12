//
//  HXWProfileCell.h
//  HXW框架
//
//  Created by hxw on 16/4/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTableViewCell.h"
static NSString * const HXWTestHeightCellIdentifier = @"HXWTestHeightCellIdentifier";

@interface HXWProfileCell : HXWTableViewCell
@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *codeView;

-(void)updateTitle:(NSString *)title;
@end
