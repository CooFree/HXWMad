//
//  HXWWenXinCell.m
//  HXW框架
//
//  Created by hxw on 16/4/6.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWWenXinCell.h"
#import "HXWWeiXinCommentView.h"
CGFloat contentStrHeight = 0;
CGFloat contentFontSize = normalFont;

@implementation HXWWenXinCell
{
    UILabel *nameLbl;
    UIImageView *headerImg;
    UILabel *contentLbl;
    UILabel *timeLbl;
    UIButton *commentBtn;
    UIButton *moreBtn;
    HXWWeiXinCommentView *commentView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialSet];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)initialSet
{
    nameLbl = [self createLblWithText:nil Multi:NO];
    contentLbl = [self createLblWithText:nil Multi:YES];
    timeLbl = [self createLblWithText:@"一分钟前" Multi:NO];
    //设置单数列行初次显示时上下有空隙，设置偶数列行则不会
    if (contentStrHeight == 0) {
        contentStrHeight = timeLbl.font.lineHeight * 4;
    }
    
    headerImg = [[UIImageView alloc]init];
    commentBtn = [[UIButton alloc]init];
    [commentBtn setImage:image(@"navigationbar_more") forState:UIControlStateNormal];
    [commentBtn setImage:image(@"navigationbar_more_highlighted") forState:UIControlStateHighlighted];
    moreBtn = [[UIButton alloc]init];
    [moreBtn setTitle:@"全文" forState:UIControlStateNormal];
    [moreBtn setTitleColor:HXWColor(92, 140, 193) forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:normalFont];
    [moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    commentView = [[HXWWeiXinCommentView alloc]init];
    
    NSArray *views = @[nameLbl,contentLbl,timeLbl,headerImg,commentBtn,moreBtn,commentView];
    [self.contentView sd_addSubViews:views];
    //加约束
    __weak typeof(self)HXW = self;
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(padding);
        make.top.mas_equalTo(padding);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(headerImg.mas_trailing).offset(padding);
        make.top.mas_equalTo(headerImg.mas_top);
        make.trailing.mas_equalTo(HXW.contentView.mas_trailing).offset(-padding);
        make.height.mas_equalTo(20);
    }];
    //contentLbl的约束不能设置高度，得有变化的空间
    [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLbl.mas_leading);
        make.top.mas_equalTo(nameLbl.mas_bottom).offset(padding);
        make.trailing.mas_equalTo(HXW.contentView.mas_trailing).offset(-padding);
        make.bottom.mas_equalTo(moreBtn.mas_top);
    }];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLbl.mas_leading);
        make.bottom.mas_equalTo(timeLbl.mas_top).offset(-padding);
        make.width.mas_equalTo(CalcTextWidth([UIFont systemFontOfSize:normalFont], @"全文"));
    }];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLbl.mas_leading);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.mas_equalTo(commentView.mas_top).offset(0);
    }];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(contentLbl.mas_trailing);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.mas_equalTo(timeLbl);
    }];
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(nameLbl.mas_leading);
        make.bottom.mas_equalTo(HXW.contentView.mas_bottom).offset(-padding);
        make.trailing.mas_equalTo(contentLbl.mas_trailing);
    }];
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
//    lbl.lineSpace = 0;
    lbl.textAlignment = NSTextAlignmentLeft;
//    lbl.layer.borderWidth = 1;
//    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}

-(void)setModel:(HXWWeiXinModel *)model
{
    _model = model;
    nameLbl.text = model.nameStr;
    headerImg.image = image(model.headerImg);
    contentLbl.text = model.contentStr;
    if (model.isShowMoreBtn) {
        //如果content高度>contentHeight则显示moreBtn
        moreBtn.hidden = NO;
        [moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        if (!model.isOpen) {
            [moreBtn setTitle:@"全文" forState:UIControlStateNormal];
            //当状态为全文时，此时只显示一部分，给contentLbl高度约束<=contentHeight
            [contentLbl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_lessThanOrEqualTo(contentStrHeight);
            }];
        }
        else
        {
            [moreBtn setTitle:@"收起" forState:UIControlStateNormal];
//            [contentLbl mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_lessThanOrEqualTo(contentHeight).priorityLow(0);
//            }];
            //当状态为收起时此时显示全部，需要重新设置约束，最好的方法是移除contentLbl的高度约束，但是masonry没这个方法
            __weak typeof(self)HXW = self;
            [contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(nameLbl.mas_leading);
                make.top.mas_equalTo(nameLbl.mas_bottom).offset(padding);
                make.trailing.mas_equalTo(HXW.contentView.mas_trailing).offset(-padding);
                make.bottom.mas_equalTo(moreBtn.mas_top);
            }];
        }
    }
    else
    {
        //如果content高度<contentHeight则不显示moreBtn
        moreBtn.hidden = YES;
        [moreBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    commentView.commentAry = model.commentAry;
}

-(void)showMore
{
    if (self.tapMoreBtnBlock) {
        self.tapMoreBtnBlock(_idx);
    }
}

@end
