//
//  HXWPageView.m
//  HXW
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWPageView.h"

#define scrollScale  1/5                //每次滑动的距离占每一页的百分比(外部传入index滑动)
#define scrollTime .3                     //滑动的总时间(外部传入index滑动)

@interface HXWPageView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, assign) NSInteger prePage;//默认为1,第一页
@property (nonatomic, assign) NSInteger totalPage;//总页数
@property (nonatomic, strong) UIScrollView *scrollV;
@property (nonatomic, strong) NSMutableSet *reusedViews;// 可重用的容器视图
@property (nonatomic, strong) NSMutableSet *visibleViews;// 当前显示的容器视图
@property (nonatomic, strong) NSTimer *timerShow;
@property (nonatomic, assign) BOOL leftOrRight;      //当外部传入点击的index判断往右或者往左
@property (nonatomic, assign) NSInteger selectIndex;   //保存外部传入的index值
@property (nonatomic, assign) BOOL goDelegate;        //当外部传入index使scrollview滑动时不走deScrollToPage这个代理
@end

@implementation HXWPageView

#pragma mark 懒加载
-(NSMutableSet *)reusedViews
{
    if (!_reusedViews) {
        _reusedViews = [[NSMutableSet alloc]init];
    }
    return _reusedViews;
}

-(NSMutableSet *)visibleViews
{
    if (!_visibleViews) {
        _visibleViews = [[NSMutableSet alloc]init];
    }
    return _visibleViews;
}

-(UIScrollView *)scrollV
{
    if (!_scrollV) {
        _scrollV = [[UIScrollView alloc]init];
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.showsVerticalScrollIndicator = NO;
        _scrollV.scrollEnabled = YES;
        _scrollV.pagingEnabled = YES;
        _scrollV.delegate = self;
        [self addSubview:_scrollV];//这个写到init方法中会调用layoutsubviews两次，因为在init方法中调用addsubview会调用layoutsubviews，而在外部只有改变frame时才会调用layoutsubviews
    }
    return _scrollV;
}

-(id)init
{
    if (self = [super init]) {
        self.prePage = 1;    //第一页
        self.isAddTouch = NO;
        _goDelegate = YES;
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //判断当前显示页
    NSInteger pre;
    NSInteger last;
    CGFloat offset = scrollView.contentOffset.x;
    pre = floorf(offset/self.width);
    offset = offset - pre * self.width;
    if (offset < 0.000001) {
        //说明当前只有一页显示
        last = pre;
        self.prePage = pre + 1;
        if ([self.delegate respondsToSelector:@selector(deScrollToPage:InPagingView:)]&&[self.delegate conformsToProtocol:@protocol(HXWPageViewDelegate)]&&_goDelegate) {
            [self.delegate deScrollToPage:_prePage InPagingView:self];
        }
    }
    else
    {
        //说明有两页显示
        last = pre + 1;
        if ([self.delegate respondsToSelector:@selector(deScrollOffsetInPagingView:offset:isChange:)]&&[self.delegate conformsToProtocol:@protocol(HXWPageViewDelegate)]&&_goDelegate) {
            if ((self.prePage == 1&&scrollView.contentOffset.x >= 0.000000)||(self.prePage == 2&&scrollView.contentOffset.x <= self.width)) {
                [self.delegate deScrollOffsetInPagingView:self offset:offset/self.width isChange:YES];
            }
            else
            {
                [self.delegate deScrollOffsetInPagingView:self offset:offset/self.width isChange:NO];
            }
        }
    }
//    HXWLog(@"%f",scrollView.contentOffset.x/self.width);
//    HXWLog(@"%ld,%ld",(long)pre,(long)last);
    //处理越界
    if (pre < 0) {
        pre = 0;
    }
    if (last >= self.totalPage) {
        last = self.totalPage - 1;
    }
    // 回收不再显示的containView
    NSInteger containViewIndex = 0;
    for (UIView *containView in self.visibleViews) {
        containViewIndex = containView.tag - 1;
        // 不在显示范围内
        if (containViewIndex < pre || containViewIndex > last) {
            [self.reusedViews addObject:containView];
            [containView removeFromSuperview];
        }
    }
    //- (void)unionSet:(NSSet *)otherSet;  // 求并集
    //- (void)minusSet:(NSSet *)otherSet;  // 求差集
    //- (void)intersectSet:(NSSet *)otherSet;  // 求交集
    [self.visibleViews minusSet:self.reusedViews];
    if (offset < 0.000001) {
        HXWLog(@"当前可视数组＝＝＝%@",self.visibleViews);
        HXWLog(@"当前可重用数组＝＝＝%@",self.reusedViews);
    }

    // 是否需要显示新的视图
    for (NSInteger index = pre; index <= last; index++) {
        BOOL isShow = NO;
        
        for (UIView *containView in self.visibleViews) {
            if ((containView.tag - 1) == index) {
                isShow = YES;
            }
        }

        if (!isShow) {
            [self showContainViewAtIndex:index];
        }
    }
}

-(void)showContainViewAtIndex:(NSInteger)index
{
    UIView *containView = [self.reusedViews anyObject];
    if (containView) {
        //是否有可重用的
        if (containView.subviews.count > 0) {
            for (UIView *view in containView.subviews) {
                [view performSelector:@selector(removeFromSuperview)];
            }
        }
        [self.reusedViews removeObject:containView];
    }
    else
    {
        //无可重用则新建
        containView = [[UIView alloc]init];
    }
    containView.tag = index + 1;
    [self.scrollV addSubview:containView];
    [self.visibleViews addObject:containView];

    __weak typeof(self)HXW = self;
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(HXW.width * (index));
        make.height.equalTo(HXW);
//        make.bottom.equalTo(HXW.scrollV);    设置这个则上下会有滑动显示整个图片，而左右滑动不了
        make.top.equalTo(HXW);
        make.width.equalTo(HXW);
//        make.edges.equalTo(HXW.scrollV).insets(UIEdgeInsetsMake(0, HXW.scrollV.width * (index), 0, 0));    //这样设置containview的大小非常小，而且滑动不了
    }];
    
    //每一次要新显示页面都由viewForPageInPagingView代理获取
    UIView *itemView = [self.delegate viewForPageInPagingView:self atIndex:index];
    itemView.userInteractionEnabled = YES;
    if (_isAddTouch) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPageView)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        [itemView addGestureRecognizer:tap];
    }
    [containView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(containView).insets(UIEdgeInsetsZero);
    }];
}

-(void)tapPageView
{
    if ([self.delegate respondsToSelector:@selector(deSelectPageInPagingView:atIndex:)]&&[self.delegate conformsToProtocol:@protocol(HXWPageViewDelegate)]) {
        [self.delegate deSelectPageInPagingView:self atIndex:_prePage];
    }
}
#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    /**
     *scrollview会先响应手势，当发现手势是点击时，便不会往下一级的containview传递，所以点击事件没有触发，解决方法：此方法返回YES,手势事件会一直往下传递，不论当前层次是否对该事件进行响应
     */
    return YES;
}

-(void)setCurrentPage:(NSInteger)currentPage
{
    if (_prePage == currentPage) {
        return;
    }
    else
    {
        if (currentPage > _prePage) {
            _leftOrRight = YES;
        }
        else
        {
            _leftOrRight = NO;
        }
        _selectIndex = currentPage;
        /*下面这个方法没有滑动的效果直接显示那一页
         */
         //先找reused，再找visible
        //重新设置当前页
//        _prePage = currentPage;
//        [self showContainViewAtIndex:_prePage - 1];
//        [self.scrollV setContentOffset:CGPointMake(self.width * (_prePage - 1), self.height)];//此方法调用scrollViewDidScroll会把不显示的containview回收
        
        /*下面这个方法有滑动的效果，会滑动显示到那一页
         */
        int srcollPage = abs((int)(_selectIndex - _prePage));//取滑动的页数，根据滑动的页数多少求计时器每次滑动时的时间间隔，确保滑动的总时间是一样的
        if (_timerShow) {
            [_timerShow invalidate];
            _timerShow = nil;
        }
        
        _timerShow = [NSTimer scheduledTimerWithTimeInterval:scrollTime*scrollScale/srcollPage target:self selector:@selector(animateNext:) userInfo:nil repeats:YES];
        [_timerShow fire];
    }
}

- (void)animateNext:(NSTimer *)timer
{
    if (_leftOrRight) {
        _goDelegate = NO;//不走deScrollToPage代理，让toolbar的index不随scrollview的滑动而不断变化，而是直接滑到选中的index
        [self.scrollV setContentOffset:CGPointMake(_scrollV.contentOffset.x+self.width*scrollScale, self.height)];
    }
    else
    {
        _goDelegate = NO;
        [self.scrollV setContentOffset:CGPointMake(_scrollV.contentOffset.x-self.width*scrollScale, self.height)];
    }

    if (_scrollV.contentOffset.x == self.width * (_selectIndex - 1)) {
        [_timerShow invalidate];
        _timerShow = nil;
        _goDelegate = YES;
    }
}

-(NSInteger)currentPage
{
    return _prePage;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //当滑动时scrollview add重用的view时会不断调用此方法，所以此处要加判断
    if (self.totalPage != [self.delegate numberOfPagesInPagingView:self]) {
        //获取总页数
        self.totalPage = [self.delegate numberOfPagesInPagingView:self];
        __weak typeof(self)HXW = self;
        [self.scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(HXW).insets(UIEdgeInsetsZero);
        }];
        
        self.scrollV.contentSize = CGSizeMake(self.totalPage * self.width, self.height);
        //初显示时设置当前页
        [self showContainViewAtIndex:self.prePage - 1];
    }
}

@end
