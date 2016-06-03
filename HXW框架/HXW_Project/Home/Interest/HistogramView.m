//
//  HistogramView.m
//  HXW框架
//
//  Created by hxw on 16/6/2.
//  Copyright © 2016年 hxw. All rights reserved.
//
#define histogramWith                        20                   //每一条柱状的宽度
#define tailHeight                              20                   //x轴距离底部的高度
#define titleFont                                14                  //文字大小
#define xyWidth                                 1                    //轴线宽度
#define xyColor           HXWColor(140, 140, 140)         //xy轴颜色
#define xPadding                              10                  //x轴右部距离
#define yPadding                              30                  //Y轴顶部距离
#define maxY                         [[self.yAry lastObject] floatValue]     //Y轴最大值

#import "HistogramView.h"
@interface HistogramView()
{
    CABasicAnimation *pathAnimation;
    CGFloat tailWidth;                                               //y轴距离左边的宽度
    NSUInteger histogramNum;                                    //单个x轴对象的条状个数
}
@property (nonatomic, strong) NSMutableArray *caShapeAry;//cashapelayer画布集合
@property (nonatomic, strong) NSMutableArray *heightAry;//柱状图的高度集合

@end

@implementation HistogramView

-(NSMutableArray *)caShapeAry
{
    if (!_caShapeAry) {
        _caShapeAry = [NSMutableArray array];
    }
    return _caShapeAry;
}

-(NSMutableArray *)heightAry
{
    if (!_heightAry) {
        _heightAry = [NSMutableArray array];
    }
    return _heightAry;
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
    histogramNum = _itemAry.count;
    for (int i = 0; i < itemAry.count; i++) {
        NSArray *detailAry = itemAry[i];
        for (int m = 0; m < detailAry.count; m++) {
            CAShapeLayer *pathLayer = [CAShapeLayer layer];
            pathLayer.frame = self.bounds;
            pathLayer.fillColor = nil;
            pathLayer.lineWidth = histogramWith;
            //    pathLayer.lineJoin = kCALineJoinRound;//终点处理
            //    pathLayer.lineCap = kCALineJoinRound;//拐点处理
            //        pathLayer.strokeColor = [UIColor redColor].CGColor;
            [self.layer addSublayer:pathLayer];//一定要把pathLayer加到画布上
            //strokeStart以及strokeEnd代表着在这个path中所占用的百分比,下r面表示pathLayer只显示整个路径的20％到40%
            //        pathLayer.strokeStart = .2;
            //        pathLayer.strokeEnd = .4;
            [self.caShapeAry addObject:pathLayer];
            [self.heightAry addObject:detailAry[m]];
        }
    }
}

//设置y轴与左端的距离
-(void)setYAry:(NSArray *)yAry
{
    _yAry = yAry;
    [yAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat width = CalcTextWidth([UIFont systemFontOfSize:titleFont], yAry[idx]);
        if (width > tailWidth) {
            tailWidth = width;
        }
    }];
    
    tailWidth = tailWidth + 3;//3为y轴标示与y轴之间的空隙
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
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文

    //画X轴标示文字
    CGFloat widthX = (self.width - tailWidth - xPadding - histogramNum*histogramWith*_xAry.count)/(_xAry.count + 1);
    for (int i = 0; i < _xAry.count; i++) {
        [_xAry[i] drawAtPoint:CGPointMake(widthX * (i+1) + tailWidth + histogramNum*histogramWith/2 + histogramNum*histogramWith*i - CalcTextWidth([UIFont systemFontOfSize:titleFont], _xAry[i])/2, self.height - tailHeight) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,xyColor,NSForegroundColorAttributeName, nil]];
    }
    
    //画Y轴标示文字
    CGFloat widthY = (self.height - tailHeight - yPadding)/(_yAry.count - 1);
    for (int i = 0; i < _yAry.count; i++) {
        [_yAry[i] drawAtPoint:CGPointMake(tailWidth - CalcTextWidth([UIFont systemFontOfSize:titleFont], _yAry[i]) - 3, self.height - tailHeight - widthY * i - CalcTextHeight([UIFont systemFontOfSize:titleFont], _yAry[0])/2) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,xyColor,NSForegroundColorAttributeName, nil]];
    }

    //画X轴和x轴上方的横线
    for (int i = 0; i < _yAry.count; i++) {
        CGPoint point[2];
        point[0] = CGPointMake(tailWidth, self.height - tailHeight - widthY*i);
        point[1] = CGPointMake(self.width - xPadding, self.height - tailHeight - widthY*i);
        CGContextSetLineWidth(context, xyWidth);
        CGContextAddLines(context, point, 2);
        CGContextSetStrokeColorWithColor(context, xyColor.CGColor);
        CGContextDrawPath(context, kCGPathStroke);
    }
 
    for (int i = 0; i < _caShapeAry.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CAShapeLayer *pathLayer = self.caShapeAry[i];
        //i%_xAry.count                     第几个树状图簇
        //floor(i/_xAry.count)              树状图簇的第几个
        NSInteger max;
        max = floorf(i/_xAry.count);
        [path moveToPoint:CGPointMake(tailWidth + widthX * (i%_xAry.count + 1) + histogramNum*histogramWith*(i%_xAry.count) + histogramWith * (max + 1/2), self.height - tailHeight)];
        [path addLineToPoint:CGPointMake(tailWidth + widthX * (i%_xAry.count + 1) + histogramNum*histogramWith*(i%_xAry.count) + histogramWith * (max + 1/2), self.height - tailHeight - [self.heightAry[i] floatValue]/maxY*(self.height - tailHeight - yPadding))];
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = ((UIColor *)self.colorAry[max]).CGColor;
        if ([pathLayer animationForKey:@"strokeEnd"]) {
            [pathLayer removeAnimationForKey:@"strokeEnd"];
        }
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }
}

@end
