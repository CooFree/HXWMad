//
//  HXWWeiXinModel.m
//  HXW框架
//
//  Created by hxw on 16/4/6.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWWeiXinModel.h"

@implementation HXWWeiXinModel
@synthesize contentStr = _contentStr;
extern CGFloat contentFontSize;
extern CGFloat contentStrHeight;

-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
}

-(NSString *)contentStr
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 80;
    CGFloat height = CalcArticleHeight([UIFont systemFontOfSize:contentFontSize], _contentStr, width);
    if (height > contentStrHeight) {
        _isShowMoreBtn = YES;
    }
    else
    {
        _isShowMoreBtn = NO;
    }
    return _contentStr;
}

-(void)setIsOpen:(BOOL)isOpen
{
    if (!_isShowMoreBtn) {
        _isOpen = NO;
    }
    else
    {
        _isOpen = isOpen;
    }
}

@end


@implementation HXWWeiXinCommentModel


@end