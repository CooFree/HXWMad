//
//  HXWPageViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/30.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWPageViewController.h"
#import "HXWPageView.h"
#import "HXWToolBar.h"

#define padding 10
#define toolBarHeight 40


@interface HXWPageViewController ()<HXWPageViewDelegate>
@property (nonatomic, strong) HXWPageView *pageView;
@property (nonatomic, strong) HXWToolBar *toolBar;
@property (nonatomic, strong) NSMutableArray *pageViewCrls;//控制器容器
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation HXWPageViewController

-(HXWPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[HXWPageView alloc]init];
        _pageView.delegate = self;
    }
    return _pageView;
}

-(NSMutableArray *)pageViewCrls
{
    if (!_pageViewCrls) {
        _pageViewCrls = [[NSMutableArray alloc]init];
    }
    return _pageViewCrls;
}

-(void)setCrlAry:(NSArray *)crlAry
{
    _crlAry = crlAry;
    for (int i = 0; i < _crlAry.count; i++) {
        [self.pageViewCrls addObject:[NSNull null]];
    }
}

-(void)setTitleAry:(NSArray *)titleAry
{
    _titleAry = titleAry;
    [self initContentView];
}

-(void)initContentView
{
    UIButton *backBtn = [self createBtnWithText:@"返回" action:@selector(backtouch)];
    backBtn.backgroundColor = HXWRandomColor;
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(5);
        make.trailing.mas_equalTo(-5);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(200);
    }];
    self.backBtn = backBtn;
    
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    __weak typeof(self)HXW = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backBtn.mas_bottom).offset(0);
        make.leading.mas_equalTo(HXW.view);
        make.trailing.mas_equalTo(HXW.view);
        make.bottom.mas_equalTo(HXW.view);
    }];

    NSMutableArray *itemAry = [NSMutableArray array];
    [self.titleAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXWToolBarButton *barItem = [[HXWToolBarButton alloc] init];
        barItem.title = self.titleAry[idx];
        //若要设置滑块，则barItem的背景色为透明
        barItem.backColor = [UIColor clearColor];
        //        toolBar.highLightBackColor = HXWColor(128, 34, 22);
        [itemAry addObject:barItem];
    }];
    HXWToolBar *toolBar = [[HXWToolBar alloc]init];
    __weak typeof(self)Self = self;
    [toolBar setBlock:^(int index) {
        [Self touchToolBar:index];
    }];
    toolBar.items = itemAry;
    //设置滑块
    [toolBar setSelectBlock:^UIView *{
        UIView *selectedView = [[UIView alloc]init];
        selectedView.backgroundColor = HXWColor(207, 207, 207);
        return selectedView;
    }];
    
    //设置滑块动画
    [toolBar setAnimateBlock:^(UIView *selcetView, CGRect newRect) {
        [UIView animateWithDuration:.2 animations:^{
            selcetView.frame = newRect;
        }];
    }];
    toolBar.sliderHidden = NO;//显示滑块
    toolBar.backgroundColor = HXWColor(205, 105, 105);
    [self.contentView addSubview:toolBar];
    //toolbar的位置
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(padding);
        make.trailing.mas_equalTo(-padding);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(toolBarHeight);
    }];
    self.toolBar = toolBar;
    
    //pageView的位置
    [self.contentView addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Self.contentView).insets(UIEdgeInsetsMake(padding + toolBarHeight, padding, padding, padding));
    }];
}

-(UIButton *)createBtnWithText:(NSString *)str action:(SEL)sel
{
    UIButton *btn = [[UIButton alloc]init];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 4;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)backtouch
{
    
}

-(void)touchToolBar:(NSInteger)index
{
    self.pageView.currentPage = index + 1;
    if (index == 0) {
        [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(220);
        }];
    }
    else
    {
        [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark HXWPageViewDelegate
#pragma required
-(NSInteger)numberOfPagesInPagingView:(HXWPageView *)hxwPageView
{
    return self.crlAry.count;
}

-(UIView *)viewForPageInPagingView:(HXWPageView *)hxwPageView atIndex:(NSInteger)index
{
    if (self.pageViewCrls[index] == [NSNull null]) {
        HXWViewController *newCrl = [[NSClassFromString(self.crlAry[index]) alloc]initWithMsgKey:self.crlAry[index]];
        [self.pageViewCrls replaceObjectAtIndex:index withObject:newCrl];
    }
    return ((UIViewController *)self.pageViewCrls[index]).view;
}

#pragma optional
-(void)deSelectPageInPagingView:(HXWPageView *)hxwPageView atIndex:(NSInteger)index
{
    HXWLog(@"点击了第%ld张",index);
}

-(void)deScrollToPage:(NSInteger)index InPagingView:(HXWPageView *)hxwPageView
{
    HXWLog(@"滑动到了第%ld张",index);
    self.toolBar.currentIndex = index - 1;
}

-(void)deScrollOffsetInPagingView:(HXWPageView *)hxwPageView offset:(CGFloat)offset isChange:(BOOL)isChange
{
    if (isChange) {
        [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(220 - 200*offset);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


/**
 *@brief  在完成类似新浪滑动页面切换过程中遇到的问题：
              1:首先就是思路问题，  思路1:起初研究scrollview循环滚动时，看到一个demo是用三个containview左中右不断来回，每次滑动后都设置contentoffset为scrollview的width，确保第二个一直在中间，然后把itemAry(即要展示的view)按照滑动后所获得的currentpage，把currentpage－1 和currentpage和currentpage＋1三个itemView加在对应的containview上，所以我在实现页面切换的时候也有用这种方法    思路2:模仿tableview使用类似tableview的重用来实现，即建一个visibleAry和一个reusedAry当滑动时先从reusedAry中找是否有可重用的view如果有用它来加载要加载的itemView，如果没有则新建，当可重用的或者新建的view用来展示时，要注意visibleAry和一个reusedAry两个数组的控制
              2:内存管理：
              3:scrollview的方法：setcontenoffset会调用scrollviewdidscroll，scrollview用masonary来添加约束
                   //判断当前显示页，浮点数判断
                   NSInteger pre;
                   NSInteger last;
                   CGFloat offset = scrollView.contentOffset.x;
                   pre = floorf(offset/self.width);
                   offset = offset - pre * self.width;
                   if (offset < 0.000001)
              4:手势传递：- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;此方法返回YES,手势事件会一直往下传递，不论当前层次是否对该事件进行响应
              5:layoutsubviews：自定义是在init方法中addsubview会调用layoutsubview，在外面只有设置frame时会调用layoutsubview ，layoutsubviews与masonary效果一样，在layoutsubviews中直接用width，height布局就行
              6:NSMutableSet 无序数组
              7:viewForPageInPagingView是一直要调用的，不能用itemary是否有对应的值而不去调用该代理，该代理可以保证实时性
 */
