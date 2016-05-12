//
//  HXWHomeCell.m
//  HXW框架
//
//  Created by hxw on 16/4/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWHomeCell.h"

@implementation HXWHomeCell
{
    UILabel *contentLbl;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self inital];
        self.backgroundColor = HXWRandomColor;
        __weak typeof(self)Self = self;
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(Self).insets(UIEdgeInsetsZero);//这样是不会显示cell的
            make.edges.mas_equalTo(Self.contentView).insets(UIEdgeInsetsZero);
        }];

    }
    return self;
}

-(void)inital
{
    contentLbl = [self createLblWithText:nil Multi:YES];
    [self.contentView addSubview:contentLbl];
}

-(void)setContentStr:(NSString *)content
{
    _content = content;
    contentLbl.text = content;
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.layer.borderWidth = 1;
    lbl.layer.cornerRadius = 4;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}

@end
