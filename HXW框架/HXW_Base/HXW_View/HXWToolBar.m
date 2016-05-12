//
//  HXWToolBar.m
//  HXWTieBATest
//
//  Created by hxw on 15/6/4.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "HXWToolBar.h"

#define imgHeight 37
#define lblgap 2

@interface HXWToolBarButton()
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *bageValeLbl;
@property (nonatomic, assign) BOOL highLight;
@end

@implementation HXWToolBarButton

-(UIImageView *)backImgView
{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc]init];
        [self addSubview:_backImgView];
    }
    return _backImgView;
}

-(UILabel *)bageValeLbl
{
    if (!_bageValeLbl) {
        _bageValeLbl = [[UILabel alloc]init];
        _bageValeLbl.backgroundColor = [UIColor redColor];
        _bageValeLbl.layer.cornerRadius = 4;
        _bageValeLbl.font = [UIFont systemFontOfSize:10];
        _bageValeLbl.textColor = [UIColor whiteColor];
        _bageValeLbl.hidden = _bageHidden;
        [self addSubview:_bageValeLbl];
    }
    return _bageValeLbl;
}

-(UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        [self addSubview:_titleLbl];
    }
    return _titleLbl;
}

-(id)init
{
    if (self = [super init])
    {
        _bageHidden = YES;  
        _titleFont = 14;
    }
    return self;
}

//-(void)setHidden:(BOOL)hidden
//{
//    _bageHidden = hidden;
//    _bageValeLbl.hidden = _bageHidden;
//}
//
//-(void)setBageValue:(NSString *)bageValue
//{
//    _bageValue = bageValue;
//    _bageValeLbl.text = _bageValue;
//}

-(void)setHighLight:(BOOL)highLight
{
    _highLight = highLight;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    //title文字高亮
    if (_highLight&&_highLightTitleColor) {
        _titleLbl.textColor = _highLightTitleColor;
    }
    else
    {
        _titleLbl.textColor = _titleColor;
    }
    //背景颜色高亮
    if (_highLight&&_highLightBackColor) {
        self.backgroundColor = _highLightBackColor;
    }
    else
    {
        self.backgroundColor = _backColor;
    }
    //背景图片高亮
    if (_highLight&&_hightLightbackImg) {
        self.backImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_hightLightbackImg]];
    }
    else
    {
        self.backImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_backImg]];
    }
    //对齐方式
    switch (_titleAlignment) {
        case 0:
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
            break;
        case 1:
            self.titleLbl.textAlignment = NSTextAlignmentLeft;
            break;
        case 2:
            self.titleLbl.textAlignment = NSTextAlignmentRight;
            break;
    
        default:
            break;
    }
    self.titleLbl.font = [UIFont systemFontOfSize:_titleFont];
    self.titleLbl.text = _title;
//    CGFloat w = CalcTextWidth(_titleLbl.font, _titleLbl.text);
    CGFloat h = CalcTextHeight(_titleLbl.font, _titleLbl.text);

    if (_buttonMode == HXWToolBarButtonMode_titleAndImg) {
        _backImgView.hidden = NO;
        _titleLbl.hidden = NO;
        _backImgView.frame = CGRectMake((self.frame.size.width - imgHeight)/2, lblgap, imgHeight, imgHeight);
        _titleLbl.frame = CGRectMake(0, CGRectGetMaxY(_backImgView.frame), self.frame.size.width, self.frame.size.height - imgHeight - 2*lblgap);
    }
    else if (_buttonMode == HXWToolBarButtonMode_ImgOnly)
    {
        _backImgView.hidden = NO;
        _titleLbl.hidden = YES;
        _backImgView.frame = CGRectMake((self.frame.size.width - imgHeight)/2, (self.frame.size.height - imgHeight)/2, imgHeight, imgHeight);
    }
    else
    {
        _backImgView.hidden = YES;
        _titleLbl.hidden = NO;
        _titleLbl.frame = CGRectMake(0, (self.frame.size.height - h)/2, self.frame.size.width, h);
    }
}

@end


@interface HXWToolBar()
@property (nonatomic, strong) HXWToolBarButton *selectBtn;
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation HXWToolBar

-(id)init
{
    if (self = [super init]) {
        _currentIndex = 0;
        _sliderHidden = YES;
        _sliderView = [[UIView alloc]init];
    }
    return self;
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    for (int idx = 0; idx < _items.count; idx ++) {
        HXWToolBarButton *btn = _items[idx];
        if (idx == _currentIndex) {
            //点击事件发生后再此处设置点击按钮的高亮，tap中设置的话会重复设置，因为一开始此处便要设置初始高亮
            btn.highLight = YES;
            __weak typeof(self)HXW = self;
            if (_selectBtn&&!_sliderHidden&&_animateBlock) {
                _animateBlock(HXW.sliderView,btn.frame);
            }
            else
            {
                _sliderView.frame = btn.frame;
            }
        }
        if (btn.highLight) {
            _selectBtn = btn;
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!_selectBtn&&!_sliderHidden&&_selectBlock) {
        _sliderView = _selectBlock();
        [self addSubview:_sliderView];
    }
    if (_items.count > 0) {
        __block HXWToolBarButton *btn;
        [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            btn = _items[idx];
            if (self.toolBarMode == HXWToolBarAlignment_Horizenta) {
                //横向排列
                btn.frame = CGRectMake( self.frame.size.width / _items.count * idx, 0, self.frame.size.width / _items.count, self.frame.size.height);
            }
            else
            {
                //纵向排列
                btn.frame = CGRectMake( 0, self.frame.size.height / _items.count * idx, self.frame.size.width, self.frame.size.height / _items.count);
            }
            btn.tag = idx;
            
            if (idx == _currentIndex) {
                //点击事件发生后再此处设置点击按钮的高亮，tap中设置的话会重复设置，因为一开始此处便要设置初始高亮
                btn.highLight = YES;
                __weak typeof(self)HXW = self;
                if (_selectBtn&&!_sliderHidden&&_animateBlock) {
                    _animateBlock(HXW.sliderView,btn.frame);
                }
                else
                {
                    _sliderView.frame = btn.frame;
                }
            }
            if (btn.highLight) {
                _selectBtn = btn;
            }
        
            [self addSubview:btn];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [btn addGestureRecognizer:tapGesture];
        }];
        btn = nil;
    }
}

-(void)tap:(UIGestureRecognizer *)gesture
{
    HXWToolBarButton *newBtn = (HXWToolBarButton *)[gesture view];
    if (_block) {
        _block((int)newBtn.tag);
    }

    if (newBtn.tag == _selectBtn.tag) {
        return;
    }
    else
    {
        _selectBtn.highLight = NO;
        _selectBtn = newBtn;
        self.currentIndex = newBtn.tag;
    }
}


@end
