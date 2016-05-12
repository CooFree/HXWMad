//
//  HXWPopOverView.m
//  UIPopViewController
//
//  Created by hxw on 15/7/27.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "HXWPopOverView.h"


#define gapPadding 0.0f                          //弹出框距离targetView的距离
#define arrowBottomWidth 10.0f                 //箭头宽度

@interface HXWPopOverView()<UIGestureRecognizerDelegate>
{
    CGPoint currentPoint;                                  //当前view内箭头尖所在的点
    CGPoint targetPoint;                                   //箭头尖所在的点
    UIView *popView;                                        //弹出视图
    float contentWidth;
    float contentHeight;
    HXWPopOverViewDirection directionTag;
}
@property (nonatomic, copy) popOverViewBlock completionBlock;
@end

@implementation HXWPopOverView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss:) name:@"NotificationMsg_HXWPopOverViewDisMiss" object:nil];
    }
    return self;
}

-(void)dismiss:(NSNotification *)notification
{
    if (_completionBlock) {
        _completionBlock(notification.userInfo);
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self removeFromSuperview];
    }];
}

+(HXWPopOverView *)showPopOverView:(UIView *)contentView
                            atView:(UIView *)targetView
                         direction:(HXWPopOverViewDirection)direction
                        completion:(popOverViewBlock)completionBlock
{
    HXWPopOverView *popView = [[HXWPopOverView alloc]init];
    [popView showPopOverView:contentView atView:targetView direction:direction completion:completionBlock];
    return popView;
}

- (void)showPopOverView:(UIView *)contentView
                 atView:(UIView *)targetView
              direction:(HXWPopOverViewDirection)direction
             completion:(popOverViewBlock)completionBlock
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *currentView = [[window subviews] objectAtIndex:0];//获取当前窗口的当前视图
    popView = contentView;
    contentWidth = contentView.frame.size.width;
    contentHeight = contentView.frame.size.height;
    directionTag = direction;
    
    //根据方向，计算弹出窗在当前视图的位置
    switch (direction) {
        case HXWPopOverViewDirection_Up:
            targetPoint = CGPointMake(CGRectGetMinX(targetView.frame) + targetView.frame.size.width / 2, CGRectGetMinY(targetView.frame));
            currentPoint = [currentView convertPoint:targetPoint fromView:targetView.superview];
            popView.frame = CGRectMake(currentPoint.x - contentWidth / 2, currentPoint.y - gapPadding - contentHeight, contentWidth, contentHeight);
            break;
        case HXWPopOverViewDirection_Left:
            targetPoint = CGPointMake(CGRectGetMinX(targetView.frame), CGRectGetMinY(targetView.frame) + targetView.frame.size.height / 2);
            currentPoint = [currentView convertPoint:targetPoint fromView:targetView.superview];
            popView.frame = CGRectMake(currentPoint.x - gapPadding - contentWidth, currentPoint.y - contentHeight / 2, contentWidth, contentHeight);
            break;
        case HXWPopOverViewDirection_Down:
            targetPoint = CGPointMake(CGRectGetMinX(targetView.frame) + targetView.frame.size.width / 2, CGRectGetMaxY(targetView.frame));
            currentPoint = [currentView convertPoint:targetPoint fromView:targetView.superview];
            popView.frame = CGRectMake(currentPoint.x - contentWidth / 2, currentPoint.y + gapPadding, contentWidth, contentHeight);
            break;
        case HXWPopOverViewDirection_Right:
            targetPoint = CGPointMake(CGRectGetMaxX(targetView.frame), CGRectGetMinY(targetView.frame) + targetView.frame.size.height / 2);
            currentPoint = [currentView convertPoint:targetPoint fromView:targetView.superview];
            popView.frame = CGRectMake(currentPoint.x + gapPadding, currentPoint.y - contentHeight / 2, contentWidth, contentHeight);
            break;
        default:
            break;
    }

    targetPoint = CGPointMake(CGRectGetMinX(targetView.frame) + targetView.frame.size.width / 2, CGRectGetMinY(targetView.frame) + targetView.frame.size.height / 2);
    currentPoint = [currentView convertPoint:targetPoint fromView:targetView.superview];
    //frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
    //frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
    self.layer.anchorPoint = CGPointMake(currentPoint.x / currentView.bounds.size.width,currentPoint.y / currentView.bounds.size.height);
    self.frame = currentView.bounds;
    self.alpha = 0.f;
    self.transform = CGAffineTransformMakeScale(.1, .1);
    [self setNeedsDisplay];
    [self addSubview:popView];//self作为底视图加载弹出视图，self是透明的，所以效果是只有弹出视图,注：如果此时self没有设置frame，先add popView的话，当后面设置self的frame的时候popView的frame会变化，导致后面点击事件dismiss时点击popView外某些地方时消失不了，其实是popView的frame变大了
    [currentView addSubview:self]; // 加载到当前显示的视图
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate =self;
    [self addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.f, 1.f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    
    //回调方法,这里其实就相当于block的set方法
    if (completionBlock) {
        _completionBlock = completionBlock;
    }
}

#pragma mark UITapGestureRecognizerDelegate
//点击事件代理方法判断touch点击事件发生的位置，如果位置在popView上则UIGestureRecognizer不响应该touch，此时如果popView是tableview的话，就会自动响应tableview的点击事件
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint tapPoint = [touch locationInView:self];
    if (tapPoint.x > CGRectGetMinX(popView.frame)&&tapPoint.x < CGRectGetMaxX(popView.frame)&&tapPoint.y > CGRectGetMinY(popView.frame)&&tapPoint.y < CGRectGetMaxY(popView.frame))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    return NO;
//}

////避免与点击键盘消失UIViewKeyBoardTapDismiss里面的tap事件冲突
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//}

//点击事件触发
-(void)dismiss
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self removeFromSuperview];
    }];
}

////视图弹出后绘制视图带箭头边框
//-(void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文
//    CGContextSetRGBStrokeColor(context, 115, 115, 115, 1.0);//线的颜色
//    CGContextSetLineWidth(context, 4.0);//线的宽度
//    CGPoint aPoint[8]; //点数组
//    
//    //根据方向计算画边框线所需的最少的点
//    switch (directionTag) {
//        case HXWPopOverViewDirection_Up:
//            aPoint[0] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame));
//            aPoint[1] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame));
//            aPoint[2] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[3] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth / 2 + arrowBottomWidth / 2, CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[4] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth / 2, CGRectGetMinY(popView.frame) + gapPadding + contentHeight);
//            aPoint[5] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth / 2 - arrowBottomWidth / 2, CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[6] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[7] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) - 2);
//            break;
//        case HXWPopOverViewDirection_Left:
//            aPoint[0] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame));
//            aPoint[1] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame));
//            aPoint[2] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame) + contentHeight / 2 - arrowBottomWidth / 2);
//            aPoint[3] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth + gapPadding, CGRectGetMinY(popView.frame) + contentHeight / 2);
//            aPoint[4] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame) + contentHeight / 2 + arrowBottomWidth / 2);
//            aPoint[5] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[6] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[7] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) - 2);
//            break;
//        case HXWPopOverViewDirection_Down:
//            aPoint[0] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame));
//            aPoint[1] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth / 2 - arrowBottomWidth / 2, CGRectGetMinY(popView.frame));
//            aPoint[2] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth / 2, CGRectGetMinY(popView.frame) - gapPadding);
//            aPoint[3] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth / 2 + arrowBottomWidth / 2, CGRectGetMinY(popView.frame));
//            aPoint[4] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame));
//            aPoint[5] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[6] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[7] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) - 2);
//            break;
//        case HXWPopOverViewDirection_Right:
//            aPoint[0] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame));
//            aPoint[1] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame));
//            aPoint[2] = CGPointMake(CGRectGetMinX(popView.frame) + contentWidth, CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[3] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) + contentHeight);
//            aPoint[4] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) + contentHeight / 2 + arrowBottomWidth / 2);
//            aPoint[5] = CGPointMake(CGRectGetMinX(popView.frame) - gapPadding, CGRectGetMinY(popView.frame) + contentHeight / 2);
//            aPoint[6] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) + contentHeight / 2 - arrowBottomWidth / 2);
//            aPoint[7] = CGPointMake(CGRectGetMinX(popView.frame), CGRectGetMinY(popView.frame) - 2);
//            break;
//        default:
//            break;
//    }
//    
//    CGContextAddLines(context, aPoint, 8);
//    CGContextDrawPath(context, kCGPathStroke);//开始画线
//    [self setNeedsDisplay];
//}

@end
