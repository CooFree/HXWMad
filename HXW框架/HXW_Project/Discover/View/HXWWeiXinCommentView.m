//
//  HXWWeiXinCommentView.m
//  HXW框架
//
//  Created by hxw on 16/4/7.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWWeiXinCommentView.h"
#import "HXWWeiXinModel.h"

@implementation HXWWeiXinCommentView
{
    UIImageView *bgView;
    NSMutableArray *itemAry;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self initialSet];
    }
    return self;
}

-(void)setCommentAry:(NSArray *)commentAry
{
    //去除原来的label（重用时）
    [itemAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UILabel *)itemAry[idx] removeFromSuperview];
    }];
    [itemAry removeAllObjects];
    _commentAry = commentAry;

    
    //此段处理当没有评论时bgview仍然显示一部分的情况
    if (commentAry.count == 0) {
        [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    else
    {
        __weak typeof(self)HXW = self;
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(HXW).insets(UIEdgeInsetsZero);
        }];
    }
    
    [_commentAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lbl = [[UILabel alloc]init];
        lbl.attributedText = [self getAttributedString:commentAry[idx]];
        lbl.font = [UIFont systemFontOfSize:normalFont];
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
        [itemAry addObject:lbl];
    }];
    [self sd_addSubViews:(NSArray *)itemAry];
    UILabel *lbl;
    for (int i = 0; i < itemAry.count; i ++) {
        UILabel *item = itemAry[i];
        if (i ==0) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(padding);
                make.trailing.mas_equalTo(-padding);
                make.top.mas_equalTo(padding);
            }];
            //如果只有一个评论
            if (itemAry.count == 1) {
                [item mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-padding/2);
                }];
            }
        }
        else if (i == itemAry.count - 1)
        {
            //这个最后一个的约束要加，不然背景view没有高度，这里通过第一个和最后一个约束确定背景view的大小
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(padding);
                make.trailing.mas_equalTo(-padding);
                make.top.mas_equalTo(lbl.mas_bottom).offset(padding/2);
                make.bottom.mas_equalTo(-padding/2);
            }];
        }
        else
        {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(padding);
                make.trailing.mas_equalTo(-padding);
                make.top.mas_equalTo(lbl.mas_bottom).offset(padding/2);
            }];
        }
        lbl = item;
    }
}

-(NSMutableAttributedString *)getAttributedString:(HXWWeiXinCommentModel *)model
{
    NSString *str = model.firstName;
    if (model.secondName.length) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"回复%@",model.secondName]];
    }
    str = [str stringByAppendingString:[NSString stringWithFormat:@"：%@",model.comment]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedStr setAttributes:@{NSForegroundColorAttributeName:HXWColor(92, 140, 193)} range:[str rangeOfString:model.firstName]];
    if (model.secondName.length) {
        [attributedStr setAttributes:@{NSForegroundColorAttributeName:HXWColor(92, 140, 193)} range:[str rangeOfString:model.secondName]];
    }
    return attributedStr;
}

-(void)initialSet
{
    //一开始初始化背景和label数组
    bgView = [[UIImageView alloc]init];
    bgView.image = [Image(@"LikeCmtBg") stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    [self addSubview:bgView];
    __weak typeof(self)HXW = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(HXW).insets(UIEdgeInsetsZero);
    }];
    itemAry = [NSMutableArray new];
}

@end
