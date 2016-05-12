//
//  HXWProfileCell.m
//  HXW框架
//
//  Created by hxw on 16/4/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWProfileCell.h"
#define codeLength 20

@interface HXWProfileCell()

@end


@implementation HXWProfileCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _picView = [[UIImageView alloc]init];
        _titleLbl = [self createLblWithText:nil Multi:YES];
        _codeView = [[UIImageView alloc]init];
        
        [self.contentView addSubview:_picView];
        [self.contentView addSubview:_titleLbl];
        [self.contentView addSubview:_codeView];
//        [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(padding);
//            make.top.mas_equalTo(padding);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
//        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(_picView.mas_trailing).offset(padding);
//            make.top.mas_equalTo(_picView.mas_top).offset(0);
//            make.trailing.mas_equalTo(-40);
//            make.bottom.mas_equalTo(-padding);
//        }];

    }
    return self;
}

-(void)updateTitle:(NSString *)title
{
    self.titleLbl.text = title;
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.layer.borderWidth = 2;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _picView.frame = CGRectMake(padding, padding, self.height - 2*padding, self.height - 2*padding);
    _titleLbl.frame = CGRectMake(CGRectGetMaxX(_picView.frame) + padding, CGRectGetMinY(_picView.frame) + padding, CalcTextWidth([UIFont systemFontOfSize:14], _titleLbl.text), CalcTextHeight([UIFont systemFontOfSize:14], _titleLbl.text));
    _codeView.frame = CGRectMake(self.width - codeLength - 40, (self.height - codeLength)/2, codeLength, codeLength);
}
@end
