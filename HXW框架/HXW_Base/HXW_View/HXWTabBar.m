//
//  HXWTabBar.m
//  HXW微博
//
//  Created by hxw on 16/3/14.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTabBar.h"
@interface HXWTabBar()
@property (nonatomic, strong) UIButton *PlusBtn;
@end

@implementation HXWTabBar
@synthesize delegate;

-(UIButton *)PlusBtn
{
    if (!_PlusBtn) {
        _PlusBtn = [[UIButton alloc]init];
        [_PlusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [_PlusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [_PlusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [_PlusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        _PlusBtn.size = _PlusBtn.currentBackgroundImage.size;
        [_PlusBtn addTarget:self action:@selector(clickPlusBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_PlusBtn];
    }
    return _PlusBtn;
}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)clickPlusBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(clickCenterBtn:)]||[self.delegate conformsToProtocol:@protocol(clickCenterBtnDelegate)] ) {
        [self.delegate  clickCenterBtn:self];
    }
}

-(void)layoutSubviews
{
    //不调用[super layoutSubviews]tabbar的背景是空的
    [super layoutSubviews];
    CGFloat width = self.width/5;
    self.PlusBtn.center = CGPointMake(self.width / 2, self.height / 2);
    __block int index = 0;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([NSStringFromClass([obj class]) isEqualToString:@"UITabBarButton"]) {
            if (index == 2) {
                index++;
            }
            obj.x = width * index;
            index++;
            obj.width = width;
        }
    }];
}

@end
