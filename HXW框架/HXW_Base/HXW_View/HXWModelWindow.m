//
//  HXWModelWindow.m
//  UIPopViewController
//
//  Created by hxw on 15/7/30.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "HXWModelWindow.h"

@implementation ModelWindowConfig
@end

@interface HXWModelWindow()<UIGestureRecognizerDelegate>
{
    ModelWindowConfig *modelConfig;
    UIView *contentView;
    UIView *modelView;
    UIView *currentView;
    CGFloat contentWidth;
    CGFloat contentHeight;
    UIImageView *imgVBK;
}
@property (nonatomic, copy) ModelWindowBlock confirmBlock;
@property (nonatomic, copy) ModelWindowBlock cancelBlock;

@end

@implementation HXWModelWindow

static NSMutableDictionary *dic = nil;

+(NSMutableDictionary *)dic
{
    if (nil == dic) {
        dic = [NSMutableDictionary dictionary];
    }
    return dic;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss:) name:@"NotificationMsg_HXWModelWindowDisMiss" object:nil];
    }
    return self;
}

-(void)dismiss:(NSNotification *)notification
{
    if (_confirmBlock) {
        _confirmBlock(notification.userInfo);
    }
    if (_cancelBlock) {
        _cancelBlock(notification.userInfo);
    }
    [UIView animateWithDuration:.3 delay:.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.alpha = .0f;
        //        self.transform = CGAffineTransformMakeTranslation(0, 0);
        switch (modelConfig.direction) {
            case HXWModelWindowDirection_Up:
                self.frame = CGRectMake(0, -contentHeight, contentWidth, contentHeight);
                break;
            case HXWModelWindowDirection_Left:
                self.frame = CGRectMake(-contentWidth, 0, contentWidth, contentHeight);
                break;
            case HXWModelWindowDirection_Down:
                self.frame = CGRectMake(0, contentHeight, contentWidth, contentHeight);
                break;
            case HXWModelWindowDirection_Right:
                self.frame = CGRectMake(contentWidth, 0, contentWidth, contentHeight);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self removeFromSuperview];
        [imgVBK removeFromSuperview];
    }];
}

+(HXWModelWindow *)setModelConfig:(ModelWindowConfig *)config
{
    HXWModelWindow *modelWindow = [[HXWModelWindow alloc]init];
    [modelWindow setModelConfig:config];
    return modelWindow;
}

-(void)setModelConfig:(ModelWindowConfig *)config
{
    modelConfig = [[ModelWindowConfig alloc]init];
    modelConfig.headerInterval = config.headerInterval;
    modelConfig.modelWidth = config.modelWidth;
    modelConfig.footerInterval = config.footerInterval;
    modelConfig.rightInterval = config.rightInterval;
    modelConfig.cornerRadius = config.cornerRadius;
    modelConfig.direction = config.direction;
    modelConfig.imgVBKAlpha = config.imgVBKAlpha;
    modelConfig.imgVBKImage = config.imgVBKImage;
    //此处设置的modelConfig是属于setModelConfig中创建的modelWindow，所以showModelWindow方法中创建的modelWindow的modelConfig还是空的
    [[[self class] dic] setObject:modelConfig forKey:@"modelConfig"];
}

+(HXWModelWindow *)showModelWindow:(UIViewController *)viewController
                    touchedDismiss:(BOOL)isTouchedDismiss
                      confirmBlock:(ModelWindowBlock)confirmBlock
                       cancelBlock:(ModelWindowBlock)cancelBlock
{
    HXWModelWindow *modelWindow = [[HXWModelWindow alloc]init];
    [modelWindow showModelWindow:viewController touchedDismiss:isTouchedDismiss confirmBlock:confirmBlock cancelBlock:cancelBlock];
    return modelWindow;
}

-(void)showModelWindow:(UIViewController *)viewController touchedDismiss:(BOOL)isTouchedDismiss confirmBlock:(ModelWindowBlock)confirmBlock cancelBlock:(ModelWindowBlock)cancelBlock
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    contentView = [[window subviews] objectAtIndex:0];
    contentWidth = contentView.bounds.size.width;
    contentHeight = contentView.bounds.size.height;
    currentView = viewController.view;

    modelConfig = [[[self class]dic] objectForKey:@"modelConfig"];
    //设置弹出窗口时的背景
    imgVBK = [[UIImageView alloc]init];
    imgVBK.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    imgVBK.backgroundColor = [UIColor lightGrayColor];
    if (modelConfig.imgVBKAlpha > 0) {
        imgVBK.alpha = modelConfig.imgVBKAlpha;
    }
    else
    {
        imgVBK.alpha = .3;
    }
    imgVBK.userInteractionEnabled = YES;
    if (modelConfig.imgVBKImage) {
        imgVBK.image = [UIImage imageNamed:modelConfig.imgVBKImage];
    }
    [contentView addSubview:imgVBK];
    
    self.layer.anchorPoint = CGPointMake(.5, .5);
    self.alpha = .0f;
    //根据方向计算self的frame
    switch (modelConfig.direction) {
        case HXWModelWindowDirection_Up:
            self.frame = CGRectMake(0, -contentHeight, contentWidth, contentHeight);
            break;
        case HXWModelWindowDirection_Left:
            self.frame = CGRectMake(-contentWidth, 0, contentWidth, contentHeight);
            break;
        case HXWModelWindowDirection_Down:
            self.frame = CGRectMake(0, contentHeight, contentWidth, contentHeight);
            break;
        case HXWModelWindowDirection_Right:
            self.frame = CGRectMake(contentWidth, 0, contentWidth, contentHeight);
            break;
        default:
            break;
    }
    //    self.transform = CGAffineTransformMakeTranslation(0, 0);
    [contentView addSubview:self];
    
    //modelView为弹出窗口，currentView为所需加载的视图
    //根据modelConfig配置弹出窗口
    modelView = [[UIView alloc]initWithFrame:CGRectMake(contentWidth - (modelConfig.modelWidth + modelConfig.rightInterval), modelConfig.headerInterval, modelConfig.modelWidth, contentHeight- modelConfig.headerInterval - modelConfig.footerInterval)];
    modelView.layer.cornerRadius = modelConfig.cornerRadius;
    modelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    modelView.layer.borderWidth = 1;
    modelView.backgroundColor = [UIColor whiteColor];
    currentView.frame = CGRectMake(0, 0, currentView.frame.size.width, currentView.frame.size.height);
    [modelView addSubview:currentView];
    [self addSubview:modelView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    [UIView animateWithDuration:.3 delay:.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 1.0f;
//        self.transform = CGAffineTransformMakeTranslation(contentWidth - (modelConfig.modelWidth + modelConfig.rightInterval), 0);
        self.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    } completion:^(BOOL finished) {
//        self.transform = CGAffineTransformIdentity;
    }];
    
    //回调方法，相当于block的set方法
    if (confirmBlock) {
        _confirmBlock = confirmBlock;
    }
    if (cancelBlock) {
        _cancelBlock = cancelBlock;
    }
}

#pragma mark UIGestureRecognizerDelegate
//点击事件代理方法判断touch点击事件发生的位置，如果位置在modelView上则UIGestureRecognizer不响应该touch，此时如果modelView中有tableview的话，就会自动响应tableview的点击事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint tapPoint = [touch locationInView:self];
    if (tapPoint.x > CGRectGetMinX(modelView.frame)&&tapPoint.x < CGRectGetMaxX(modelView.frame)&&tapPoint.y > CGRectGetMinY(modelView.frame)&&tapPoint.y < CGRectGetMaxY(modelView.frame))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//点击事件触发
-(void)dismiss
{
    [UIView animateWithDuration:.3 delay:.0f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.alpha = .0f;
        //        self.transform = CGAffineTransformMakeTranslation(0, 0);
        switch (modelConfig.direction) {
            case HXWModelWindowDirection_Up:
                self.frame = CGRectMake(0, -contentHeight, contentWidth, contentHeight);
                break;
            case HXWModelWindowDirection_Left:
                self.frame = CGRectMake(-contentWidth, 0, contentWidth, contentHeight);
                break;
            case HXWModelWindowDirection_Down:
                self.frame = CGRectMake(0, contentHeight, contentWidth, contentHeight);
                break;
            case HXWModelWindowDirection_Right:
                self.frame = CGRectMake(contentWidth, 0, contentWidth, contentHeight);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self removeFromSuperview];
        [imgVBK removeFromSuperview];
    }];
}

@end
