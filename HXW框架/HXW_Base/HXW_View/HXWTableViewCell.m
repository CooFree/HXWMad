//
//  HXWTableViewCell.m
//  HXW框架
//
//  Created by hxw on 16/4/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTableViewCell.h"

@implementation HXWTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _bottomLine = [[UIImageView alloc]init];
        _bottomLine.backgroundColor = HXWColor(237, 237, 237);
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(padding);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        _headLine = [[UIImageView alloc]init];
        _headLine.backgroundColor = HXWColor(237, 237, 237);
        [self addSubview:_headLine];
        [_headLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        _headLine.hidden = YES;
    }
    return self;
}

@end
