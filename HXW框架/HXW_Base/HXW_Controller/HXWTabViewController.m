//
//  HXWPageViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTabViewController.h"
#import "HXWToolBar.h"

#define padding 10
#define toolBarHeight 40

@interface HXWTabViewController ()
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, weak) UIViewController *currentCrl;
@property (nonatomic, strong) NSMutableArray *childNameAry;

@end

@implementation HXWTabViewController

-(void)setCrlAry:(NSArray *)crlAry
{
    _crlAry = crlAry;
    [self initFirstCrl];
}

-(void)setTitleAry:(NSArray *)titleAry
{
    _titleAry = titleAry;
    [self initContentView];
}

-(UIView *)pageView
{
    if (!_pageView) {
        _pageView = [[UIView alloc]init];
        _pageView.backgroundColor = [UIColor whiteColor];
    }
    return _pageView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

-(NSMutableArray *)childNameAry
{
    if (!_childNameAry) {
        _childNameAry = [NSMutableArray array];
    }
    return _childNameAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
}

-(void)initContentView
{
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
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.mas_equalTo(padding);
        make.height.mas_equalTo(toolBarHeight);
    }];
    
    //pageView的位置
    [self.contentView addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Self.contentView).insets(UIEdgeInsetsMake(2*padding + toolBarHeight, padding, padding, padding));
    }];
}

-(void)initFirstCrl
{
    //设置第一个crl
    NSString *className = [self.crlAry firstObject];
    Class class = NSClassFromString(className);
    UIViewController *crl = [[class alloc]init];
    crl.view.frame = self.pageView.bounds;
    [self.pageView addSubview:crl.view];
    [self addChildViewController:crl];
    self.currentCrl = crl;//设置一个弱指针指向当前显示的crl
    [self.childNameAry addObject:[self.crlAry firstObject]];//用一个数组记录已被add的子控制器类名
}

-(void)touchToolBar:(NSInteger)idx
{
    //    HXWLog(@"%ld",(long)idx);
    //    UIViewController *oldCrl = [self.childViewControllers firstObject];
    //    [oldCrl willMoveToParentViewController:nil];
    //    [oldCrl.view removeFromSuperview];
    //    [oldCrl removeFromParentViewController];
    //    UIViewController *newCrl = [[NSClassFromString(self.crlAry[idx]) alloc]init];
    //    newCrl.view.frame = self.contentView.bounds;
    //    [self.contentView addSubview:newCrl.view];
    //    [self addChildViewController:newCrl];
    //    [newCrl didMoveToParentViewController:self];
    
    /*
     *此处newCrl被addChildViewController，newCrl所指的viewcontroller就被self.childViewControllers数
     *组强引用，而oldCrl所指的viewcontroller由于不再被self.childViewControllers数组强引用而被释放以
     *上面这种写法，切换viewcontroller后原来的控制器就被销毁了，这边有个问题？第一个字控制器永远不销毁
     */
    if ([[NSString stringWithUTF8String:object_getClassName(self.currentCrl)]  isEqualToString:self.crlAry[idx]]) {
        //如果当前显示的crl和你所点击的crl相同，则返回不做任何操作
        return;
    }
    else
    {
        if ([self.childNameAry containsObject:self.crlAry[idx]]) {
            //如果所点击的字控制器已被add，则从self.childViewControllers中找出对应的控制器设置为currentCrl
            [self.currentCrl.view removeFromSuperview];
            UIViewController *newCrl = [self.childViewControllers objectAtIndex:[self.childNameAry indexOfObject:self.crlAry[idx]]];
            newCrl.view.frame = self.pageView.bounds;
            [self.pageView addSubview:newCrl.view];
            self.currentCrl = newCrl;
            HXWLog(@"%@",self.childViewControllers);
        }
        else
        {
             //如果所点击的子控制器未被add，则add新的子控制器
            [self.currentCrl.view removeFromSuperview];
            UIViewController *newCrl = [[NSClassFromString(self.crlAry[idx]) alloc]init];
            newCrl.view.frame = self.pageView.bounds;
            [self.pageView addSubview:newCrl.view];
            [self addChildViewController:newCrl];
            [newCrl didMoveToParentViewController:self];
            [self.childNameAry addObject:self.crlAry[idx]];
            self.currentCrl = newCrl;
        }
    }
}


@end
