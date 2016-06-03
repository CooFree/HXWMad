//
//  circleView.m
//  HXW框架
//
//  Created by hxw on 16/6/1.
//  Copyright © 2016年 hxw. All rights reserved.
//

#define titleFont                                14           //文字大小
#define centerColor                             HXWColor(87, 87, 87)             //中心文字颜色

#import "CircleView.h"
@interface CircleView()
{
    CABasicAnimation *pathAnimation;
    BOOL isShowTitle;
}
@property (nonatomic, strong) NSMutableArray *caShapeAry;//cashapelayer画布集合
@end

@implementation CircleView

-(NSMutableArray *)caShapeAry
{
    if (!_caShapeAry) {
        _caShapeAry = [NSMutableArray array];
    }
    return _caShapeAry;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setItemAry:(NSArray *)itemAry
{
    _itemAry = itemAry;
    for (int i = 0; i < itemAry.count; i++) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = _lineWidth;
        //    pathLayer.lineJoin = kCALineJoinRound;//终点处理
        //    pathLayer.lineCap = kCALineJoinRound;//拐点处理
//        pathLayer.strokeColor = [UIColor redColor].CGColor;
        [self.layer addSublayer:pathLayer];//一定要把pathLayer加到画布上
        //strokeStart以及strokeEnd代表着在这个path中所占用的百分比,下r面表示pathLayer只显示整个路径的20％到40%
        //        pathLayer.strokeStart = .2;
        //        pathLayer.strokeEnd = .4;
        [self.caShapeAry addObject:pathLayer];
    }
}

//设置动画时间
-(void)setDuration:(CGFloat)duration
{
    _duration = duration;
    if (!pathAnimation) {
        pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        //value代表着在这个path中动画所占用的百分比,即动画在路径的一半开始在80%的时候结束
        //        pathAnimation.fromValue = [NSNumber numberWithFloat:0.5f];
        //        pathAnimation.toValue = [NSNumber numberWithFloat:0.8f];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.delegate = self;
    }
    pathAnimation.duration = (NSTimeInterval)duration;
}

-(void)drawRect:(CGRect)rect
{
    if (isShowTitle) {
        CGFloat width = CalcTextWidth([UIFont systemFontOfSize:titleFont], _centerTitle);
        CGFloat height = CalcTextHeight([UIFont systemFontOfSize:titleFont], _centerTitle);
        [_centerTitle drawAtPoint:CGPointMake(self.width/2 - width/2,self.height/2 - height/2) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,centerColor,NSForegroundColorAttributeName, nil]];
        return;
    }
    for (int i = 0; i < _itemAry.count; i++) {
        CAShapeLayer *pathLayer = self.caShapeAry[i];
        pathLayer.strokeColor = ((UIColor *)_colorAry[i]).CGColor;
        UIBezierPath *cycPath = [UIBezierPath bezierPath];
        CGFloat startAngle = 0.0;
        CGFloat endAngle = 0.0;
        if (i == 0) {
            startAngle -= 0.25;            //使它从圆弧最上方开始画
            endAngle = [_pecentAry[i] floatValue] - 0.25;
        }
        else
        {
            for (int m = 0; m < i; m++) {
                startAngle = startAngle + [_pecentAry[m] floatValue];
            }
            startAngle -= 0.25;
            endAngle = startAngle + [_pecentAry[i] floatValue];
        }
        [cycPath addArcWithCenter:CGPointMake(self.width/2, self.height/2) radius:_radius startAngle:startAngle * 2 * M_PI endAngle:endAngle * 2 * M_PI clockwise:YES];
        /*
         当半径是pathLayer线宽的一半时，为实心圆
         center：圆心的坐标
         radius：半径
         startAngle：起始的弧度
         endAngle：圆弧结束的弧度
         clockwise：YES为顺时针，No为逆时针
         */
        pathLayer.path = cycPath.CGPath;
        if ([pathLayer animationForKey:@"strokeEnd"]) {
            [pathLayer removeAnimationForKey:@"strokeEnd"];
        }
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        }
}

//CABasicanimation   delelgate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //动画结束后的回调
    HXWLog(@"jieshu");
    isShowTitle = YES;
    [self setNeedsDisplay];
    /*
     setNeedsDisplay和setNeedsLayout两个方法都是异步的，setNeedsDisplay会自动调用drawRect，而setNeedsLayout会自动调用layoutSubviews。
     1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect 掉用是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在 控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量 值).
     2、该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
     */

}

@end
