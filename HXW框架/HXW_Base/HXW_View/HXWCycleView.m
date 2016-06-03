//
//  HXWPageView.m
//  HXW
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//
#define titleLblHeight 25
#define titleFont 12
#define titleLblColor HXWColor(148, 148, 148)
#define tintColor HXWColor(255, 0, 0)
#define currentTintColor HXWColor(248, 248, 255)
#define pageCrlSize CGSizeMake(70, 10)

#import "HXWCycleView.h"
@interface HXWCycleView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) NSMutableArray *containAry;
@property (nonatomic, strong) NSMutableArray *itemAry;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPageControl *pageCrl;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) NSTimer *timerShow;
@property (nonatomic, assign) BOOL getLefting;
@property (nonatomic, assign) BOOL getRighting;
@end

@implementation HXWCycleView

-(UIScrollView *)scrollV
{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]init];
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.showsVerticalScrollIndicator = NO;
        _scrollV.scrollEnabled = YES;
        _scrollV.pagingEnabled = YES;  //分页
        _scrollV.delegate = self;
        [self addSubview:_scrollV];
        }
    return _scrollV;
}

-(NSMutableArray *)containAry
{
    if (!_containAry) {
        _containAry = [[NSMutableArray alloc]init];
        for (int i = 0; i < 3; i ++) {
            UIView *containView = [[UIView alloc]init];
            containView.backgroundColor = HXWRandomColor;
            [self.scrollV addSubview:containView];
            [_containAry addObject:containView];//初始化三个用于加载的视图容器
        }
    }
    return _containAry;
}

-(NSMutableArray *)itemAry
{
    if (!_itemAry) {
        _itemAry = [[NSMutableArray alloc]init];
        for (int i = 0; i < self.totalPage; i ++) {
            [_itemAry addObject:[NSNull null]];//所要展示的view的数组
        }
    }
    return _itemAry;
}

-(UIPageControl *)pageCrl
{
    if (!_pageCrl) {
        _pageCrl = [[UIPageControl alloc]init];
        _pageCrl.pageIndicatorTintColor = tintColor;
        _pageCrl.currentPageIndicatorTintColor = currentTintColor;
        [_pageCrl setCurrentPage:self.currentPage - 1];
        [_pageCrl setNumberOfPages:self.totalPage];
        [self addSubview:_pageCrl];
    }
    return _pageCrl;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:titleFont];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = titleLblColor;
        _titleLabel.alpha = .6;
        _titleLabel.layer.borderWidth = 0;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(id)init
{
    if (self = [super init]) {
        self.currentPage = 1;    //第一页
    }
    return self;
}

-(void)setAnimateTime:(float)animateTime
{
    if (animateTime > 0) {
        _animateTime = animateTime;
        if (_timerShow) {
            [_timerShow invalidate];
            _timerShow = nil;
        }
        _timerShow = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animateNext:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timerShow forMode:NSRunLoopCommonModes];
        //sh
    }
}

- (void)animateNext:(NSTimer *)timer
{
    int x = _scrollV.contentOffset.x+20;
    int y = _scrollV.contentOffset.y;
    _scrollV.contentOffset = CGPointMake(x, y);
    if (_scrollV.contentOffset.x == _scrollV.frame.size.width) {
        [timer pause];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_animateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [timer resume];
        });
    }
}

-(void)getNewViewAt:(NSInteger)index
{
    //原来是判断self.itemAry中有没有该项，有该项就不调用代理，这样是不好的，没考虑界面更新的情况
    UIView *itemView = [self.delegate viewForPageInCycleView:self atIndex:index];
    itemView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPageView)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [itemView addGestureRecognizer:tap];
    [self.itemAry replaceObjectAtIndex:index withObject:itemView];
    _currentPage = [self validPageValue:_currentPage];
    [self reFreshScrollViewWithContentOffset:NO];//没更新当前页，不须重设contentoffset
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //第一次
    if (scrollView.contentOffset.x == 0&&_isFirst) {
        [self reFreshScrollViewWithContentOffset:YES];
        _isFirst = NO;
    }
    if (scrollView.contentOffset.x == self.width) {
        _getLefting = NO;
        _getRighting = NO;
    }
    //左滑动
    if (scrollView.contentOffset.x < self.width) {
        //往左滑动过程中如果左边页没加载，则加载左边页
        NSUInteger index = _currentPage == 1?self.itemAry.count - 1:_currentPage - 2;
        //确保取view时只取一次
        if (!_getLefting) {
            [self getNewViewAt:index];
            _getLefting = YES;
        }
    }
    if (scrollView.contentOffset.x <= 0) {
        //往左滑动完成时，更新页码，再根据_currentPage让containview add左右页的视图（如果视图还没加载，则不add）
        _getLefting = NO;
        _currentPage = _currentPage - 1;
        _currentPage = [self validPageValue:_currentPage];
        [self reFreshScrollViewWithContentOffset:YES];//更新当前页，必须重设contentoffset
    }
    
    //右滑动
    if (scrollView.contentOffset.x > self.width) {
        //往右滑动过程中如果右边页没加载，则加载右边页
        NSUInteger index = _currentPage == self.itemAry.count?0:_currentPage;
        if (!_getRighting) {
            [self getNewViewAt:index];
            _getRighting = YES;
        }
    }
    if (scrollView.contentOffset.x >= 2 * self.width) {
        //往右滑动完成时，更新页码，再根据_currentPage让containview add左右页的视图（如果视图还没加载，则不add）
        _getRighting = NO;
        _currentPage = _currentPage + 1;
        _currentPage = [self validPageValue:_currentPage];
        [self reFreshScrollViewWithContentOffset:YES];//更新当前页，必须重设contentoffset
    }

}

-(void)reFreshScrollViewWithContentOffset:(BOOL)isReset
{
    //计算出左右页的页码
    NSInteger pre = [self validPageValue:_currentPage - 1];
    NSInteger last = [self validPageValue:_currentPage + 1];
    NSArray *pageAry = @[[NSString stringWithFormat:@"%ld",(long)pre],[NSString stringWithFormat:@"%ld",(long)_currentPage],[NSString stringWithFormat:@"%ld",(long)last]];
    for (int idx = 0 ; idx < self.containAry.count; idx ++) {

        UIView *containView = self.containAry[idx];
        __weak typeof(containView)ContainView = containView;
        // 这边不像HXWPageView获取重用页直接add，此处当刚往右滑动时左边第一页是不会加载的所以要判断
        if (self.itemAry[[pageAry[idx] integerValue] - 1] != [NSNull null]) {
            UIView *item = self.itemAry[[pageAry[idx] integerValue] - 1];
            NSArray *subViews = [containView subviews];
            if([subViews count] != 0) {
                [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
            [containView addSubview:item];

            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(ContainView).insets(UIEdgeInsetsZero);
            }];
        }
    }
    //显示中间页
    if (isReset == YES) {
        [self.scrollV setContentOffset:CGPointMake(self.width, 0)];//这边设置ContentOffset后会走scrollViewDidScroll方法的，不过scrollView的contentoffset.x直接为375 ，但是第一次直接调用此方法设置时offset  375 0 375 相当于又向左滑动一页，导致显示的是最后一页,原因是layoutsubviews之后走了scrollViewDidScroll
        self.pageCrl.currentPage = _currentPage - 1;//更新pageCrl
        self.titleLabel.text = [NSString stringWithFormat:@"    %@",[self.delegate titleForPageInCycleView:self atIndex:_currentPage - 1]];//更新title
    }
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == 0) value = self.itemAry.count;                   // value＝1为第一页，value = 0为前面一页
    if(value == self.itemAry.count + 1) value = 1;
    
    return value;
}

-(void)tapPageView
{
    [self.delegate deSelectPageInCycleView:self atIndex:_currentPage];
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    /**
     *scrollview会先响应手势，当发现手势是点击时，便不会往下一级的containview传递，所以点击事件没有触发，解决方法：此方法返回YES,手势事件会一直往下传递，不论当前层次是否对该事件进行响应
     */
    return YES;
}

-(void)layoutSubviews
{
    _isFirst = YES;
    __weak typeof(self)HXW = self;
    __block UIView *lastContainView  = nil;
    [self.containAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *containView = HXW.containAry[idx];
        //用masonary设置scrollview的约束
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(HXW.scrollV);
            make.width.equalTo(HXW);
            make.height.equalTo(HXW.scrollV);
            if (idx == HXW.containAry.count) {
                //当最后一个时，要设置最后一个containView的尾部与scrollView对齐
                make.trailing.equalTo(HXW.scrollV);
            }
            if (!lastContainView) {
                //第一个与scrollView的头部对齐
                make.leading.equalTo(HXW.scrollV);
            }
            else
            {
                //不是第一个则依次排列
                make.leading.equalTo(lastContainView.mas_trailing);
            }
        }];
        lastContainView = containView;
    }];
    [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(HXW);
        //设置scrollView的contentSize
        make.trailing.equalTo(lastContainView.mas_trailing);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(HXW);
        make.trailing.equalTo(HXW);
        make.bottom.equalTo(HXW);
        make.height.mas_equalTo(titleLblHeight);
    }];
    self.totalPage = [self.delegate numberOfPagesInCycleView:self];
    
    [self.pageCrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(HXW.titleLabel);
        make.trailing.equalTo(HXW);
        make.size.mas_equalTo(pageCrlSize);
    }];
    
    //初显示时设置当前页
    UIView *itemView = [self.delegate viewForPageInCycleView:self atIndex:self.currentPage - 1];
    itemView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPageView)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [itemView addGestureRecognizer:tap];
    [self.itemAry replaceObjectAtIndex:self.currentPage - 1 withObject:itemView];
    [self reFreshScrollViewWithContentOffset:YES];
}

-(void)dealloc
{
    [_timerShow invalidate];
}
@end
