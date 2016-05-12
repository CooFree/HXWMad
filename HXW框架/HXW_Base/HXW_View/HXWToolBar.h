//
//  HXWToolBar.h
//  HXWTieBATest
//
//  Created by hxw on 15/6/4.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickButtonDelegate <NSObject>

-(void)clickButtonAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, HXWToolBarButtonMode)
{
    HXWToolBarButtonMode_titleOnly,//只有文字,默认只有文字
    HXWToolBarButtonMode_ImgOnly,//只有图片
    HXWToolBarButtonMode_titleAndImg//有图片和文字
};

//文字对齐方式
typedef NS_ENUM(NSInteger, HXWToolBarButtonTitleAlignment)
{
    HXWToolBarButtonTitleAlignment_Center,//默认居中
    HXWToolBarButtonTitleAlignment_Left,
    HXWToolBarButtonTitleAlignment_Right
};

@interface HXWToolBarButton : UIView
@property (nonatomic, assign) HXWToolBarButtonMode buttonMode;
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, assign) CGFloat titleFont;//标题文字大小,默认14
@property (nonatomic, assign) HXWToolBarButtonTitleAlignment titleAlignment;//标题对齐方式
@property (nonatomic, strong) UIColor *titleColor;//标题颜色
@property (nonatomic, strong) UIColor *highLightTitleColor;//高亮标题颜色，若不要高亮效果，此处不设置就可以，下同
@property (nonatomic, strong) NSString *backImg;//背景图片
@property (nonatomic, strong) NSString *hightLightbackImg;
@property (nonatomic, strong) UIColor *backColor;//背景颜色，默认为white
@property (nonatomic, strong) UIColor *highLightBackColor;
@property (nonatomic, strong) NSString *bageValue;//提示框中的内容
@property (nonatomic, assign) BOOL bageHidden;//提示框是否显示,默认不显示

@end

typedef void (^tapObserveBlock) (int index);
typedef UIView * (^createSelectBlock) (void);
typedef void (^createAnimateBlock) (UIView *selcetView,CGRect newRect);


typedef NS_ENUM(NSInteger, HXWToolBarAlignment)
{
    HXWToolBarAlignment_Horizenta,//横向排列,默认横向排列
    HXWToolBarAlignment_Vertical//竖向排列
};

@interface HXWToolBar : UIView
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) HXWToolBarAlignment *toolBarMode;
@property (nonatomic, copy) tapObserveBlock block;
@property (nonatomic, assign) id <clickButtonDelegate> delegate;
@property (nonatomic, assign) BOOL sliderHidden;//是否隐藏滑块，默认为yes
@property (nonatomic, copy) createSelectBlock selectBlock;//滑块，若不需要设置滑块，sliderHidden设置为yes，下同，若需要设置滑块，请将backColor和highLightBackColor都设置为clearColor
@property (nonatomic, copy) createAnimateBlock animateBlock;//滑块滑动效果
@property (nonatomic, assign) NSInteger currentIndex;//当前块位置,默认为0

-(void)setBlock:(tapObserveBlock)block;
-(void)setSelectBlock:(createSelectBlock)selectBlock;
-(void)setAnimateBlock:(createAnimateBlock)animateBlock;

@end
