//
//  brokenLineView.m
//  HXW框架
//
//  Created by hxw on 16/4/19.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "brokenLineView.h"
#define widthX   (self.width - tailWidth)/(self.xAry.count +1)            //X轴每一格的宽度
#define widthY   (self.height - tailHeight)/(self.yAry.count + 1)          //Y轴每一格的宽度
#define maxY                         [[self.yAry lastObject] floatValue]     //Y轴最大值
#define tailHeight                              20            //x轴距离底部的高度
#define arrowSize                              5             //箭头大小
#define arrowPadding                         5             //箭头距离顶部和右边的距离
#define detailWidth                            40           //说明图标的宽度
#define detailPadding                          5            //说明图标于说明文字之间的距离
#define titleFont                                12           //文字大小
#define xyColor           HXWColor(140, 140, 140)  //xy轴颜色
#define brokenWidth                               2             //折线宽度
#define xyWidth                               1             //网格线宽度

@interface brokenLineView()
@property (nonatomic, strong) NSMutableArray *lineMaxAry;//计录每条折线的最大值
@property (nonatomic, strong) NSMutableArray *pathLayerAry;
@property (nonatomic, strong) NSMutableArray *cycLayerAry;

@end
@implementation brokenLineView
{
    CABasicAnimation *pathAnimation;
    CGFloat tailWidth;                                         //y轴距离左边的宽度
}

-(NSMutableArray *)lineMaxAry
{
    if (!_lineMaxAry) {
        _lineMaxAry = [[NSMutableArray alloc]init];
    }
    return _lineMaxAry;
}

-(NSMutableArray *)pathLayerAry
{
    if (!_pathLayerAry) {
        _pathLayerAry = [[NSMutableArray alloc]init];
    }
    return _pathLayerAry;
}

-(NSMutableArray *)cycLayerAry
{
    if (!_cycLayerAry) {
        _cycLayerAry = [[NSMutableArray alloc]init];
    }
    return _cycLayerAry;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        tailWidth = 0.0;
    }
    return self;
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

-(void)setLineAry:(NSArray *)lineAry
{
    _lineAry = lineAry;
    //每次把原来的画布清空
    [self.pathLayerAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *pathLayer = self.pathLayerAry[idx];
        [pathLayer removeFromSuperlayer];
    }];
    [self.cycLayerAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CAShapeLayer *cycLayer = self.cycLayerAry[idx];
        [cycLayer removeFromSuperlayer];
    }];
    [self.pathLayerAry removeAllObjects];
    [self.cycLayerAry removeAllObjects];
    //设置每条线的画布
    for (int i = 0; i < lineAry.count; i ++) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.bounds;
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = brokenWidth;
        pathLayer.lineJoin = kCALineJoinRound;//终点处理
        pathLayer.lineCap = kCALineJoinRound;//拐点处理
        //strokeStart以及strokeEnd代表着在这个path中所占用的百分比,下面表示pathLayer只显示整个路径的20％到40%
        //        pathLayer.strokeStart = .2;
        //        pathLayer.strokeEnd = .4;
        [self.layer addSublayer:pathLayer];
        [self.pathLayerAry addObject:pathLayer];
    }

    //设置折线数据
    [self.lineMaxAry removeAllObjects];
    for (int i = 0; i < lineAry.count; i ++) {
        __weak typeof(self)Self = self;
        __block float max = 0.0;
        NSArray *lineDetailAry = lineAry[i];
        __block NSMutableArray *maxAry = [NSMutableArray array];
        [lineDetailAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //设置每一个点的画布
            CAShapeLayer *cycLayer = [CAShapeLayer layer];
            cycLayer.frame = self.bounds;
            cycLayer.lineWidth = brokenWidth;
            cycLayer.fillColor = HXWColor(255, 255, 255).CGColor;
            cycLayer.lineJoin = kCALineJoinRound;//终点处理
            cycLayer.lineCap = kCALineJoinRound;//拐点处理
            [Self.layer addSublayer:cycLayer];
            //这边就使点的画布在线的画布之上，当线经过节点时，是从下面经过的，把节点的填充色设为白色（不设填充色的话是透明的），在节点上是看不到线的。
            [Self.cycLayerAry addObject:cycLayer];

            //处理存在多个相同最大值的情况
            if (max - [lineDetailAry[idx] floatValue] < 0.000001&&max - [lineDetailAry[idx] floatValue] > -0.000001) {
                [maxAry addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
            }
            else if ([lineDetailAry[idx] floatValue] - max >= 0.000001)
            {
                max = [lineDetailAry[idx] floatValue];
                if (maxAry.count > 0) {
                    //这里也会把前一次设置lineAry时的maxAry清空
                    [maxAry removeAllObjects];
                }
                [maxAry addObject:[NSString stringWithFormat:@"%lu",(unsigned long)idx]];
            }
            if (idx == lineDetailAry.count - 1) {
                [Self.lineMaxAry addObject:maxAry];
            }
        }];
    }
}

//设置y轴与左端的距离
-(void)setYAry:(NSArray *)yAry
{
    _yAry = yAry;
    [yAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CalcTextWidth([UIFont systemFontOfSize:titleFont], yAry[idx]) > tailWidth) {
            tailWidth = CalcTextWidth([UIFont systemFontOfSize:titleFont], yAry[idx]);
        }
    }];
    
    tailWidth = tailWidth + 3;//3为y轴标示与y轴之间的空隙
}

-(void)drawRect:(CGRect)rect
{
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文
    //画原点
    NSString *zero = @"0";
    [zero drawAtPoint:CGPointMake(tailWidth - CalcTextWidth([UIFont systemFontOfSize:titleFont], @"0"), self.height - tailHeight) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,xyColor,NSForegroundColorAttributeName, nil]];
    //画X轴标示文字
    for (int i = 0; i < _xAry.count; i++) {
        //填充，显示对应x轴的突起效果
        CGContextFillRect(context, CGRectMake(widthX * (i+1) + tailWidth, self.height - tailHeight, xyWidth, -widthY*self.yAry.count));
        CGContextSetFillColorWithColor(context, xyColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
        
        [_xAry[i] drawAtPoint:CGPointMake(widthX * (i+1) + tailWidth - CalcTextWidth([UIFont systemFontOfSize:titleFont], _xAry[i])/2, self.height - tailHeight) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,xyColor,NSForegroundColorAttributeName, nil]];
    }
    
    //画Y轴标示文字
    for (int i = 0; i < _yAry.count; i++) {
        //填充，显示对应y轴的突起效果
        CGContextFillRect(context, CGRectMake(tailWidth, self.height - tailHeight - widthY * (i+1), widthX*self.xAry.count, xyWidth));
        CGContextSetFillColorWithColor(context, xyColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
        CGFloat textHeight = CalcTextHeight([UIFont systemFontOfSize:titleFont], _yAry[0]);
        [_yAry[i] drawAtPoint:CGPointMake(tailWidth - CalcTextWidth([UIFont systemFontOfSize:titleFont], _yAry[i]) - 3, self.height - tailHeight - widthY * (i+1) - textHeight/2) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,xyColor,NSForegroundColorAttributeName, nil]];
    }

    //画XY轴
    CGPoint point[3];
    point[0] = CGPointMake(tailWidth, arrowPadding);
    point[1] = CGPointMake(tailWidth, self.height - tailHeight);
    point[2] = CGPointMake(self.width - arrowPadding, self.height - tailHeight);
    CGContextSetLineWidth(context, xyWidth);
    CGContextAddLines(context, point, 3);
    CGContextSetStrokeColorWithColor(context, xyColor.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    //画X轴箭头
    CGPoint arrowXPoint[3];
    arrowXPoint[0] = CGPointMake(self.width - arrowPadding - arrowSize, self.height - tailHeight - arrowSize);
    arrowXPoint[1] = CGPointMake(self.width - arrowPadding, self.height - tailHeight);
    arrowXPoint[2] = CGPointMake(self.width - arrowPadding - arrowSize, self.height - tailHeight + arrowSize);
    CGContextSetLineWidth(context, xyWidth);
    CGContextAddLines(context, arrowXPoint, 3);
    CGContextSetStrokeColorWithColor(context, xyColor.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    //画Y轴箭头
    CGPoint arrowYPoint[3];
    arrowYPoint[0] = CGPointMake(tailWidth - arrowSize, arrowPadding + arrowSize);
    arrowYPoint[1] = CGPointMake(tailWidth, arrowPadding);
    arrowYPoint[2] = CGPointMake(tailWidth + arrowSize, arrowPadding + arrowSize);
    CGContextSetLineWidth(context, xyWidth);
    CGContextAddLines(context, arrowYPoint, 3);
    CGContextSetStrokeColorWithColor(context, xyColor.CGColor);
    CGContextDrawPath(context, kCGPathStroke);
    
    //画折线
    int cycIndex = 0;
    for (int idx = 0; idx < self.lineAry.count; idx ++) {
        //每条线
        UIBezierPath *path = [UIBezierPath bezierPath];
        CAShapeLayer *pathLayer = self.pathLayerAry[idx];

        NSArray *lineDetailAry = self.lineAry[idx];
        NSArray *lineMaxDetailAry = self.lineMaxAry[idx];
        UIColor *lineColor = self.lineColorAry[idx];

        for (int i = 0; i < lineDetailAry.count; i ++) {
            //每个点
            UIBezierPath *cyc = [UIBezierPath bezierPath];
            CAShapeLayer *cycLayer = self.cycLayerAry[cycIndex];

            CGFloat x = tailWidth + widthX * (i + 1);
            CGFloat y = self.height - tailHeight - [lineDetailAry[i] floatValue]/maxY * widthY * _yAry.count;
            CGPoint point = CGPointMake(x, y);
            if (i == 0) {
                [path moveToPoint:point];//bezier曲线初始点
            }
            else{
                [path addLineToPoint:point];//bezier曲线添加其他的点
                
            }
            if ([lineMaxDetailAry containsObject:[NSString stringWithFormat:@"%d",i]]) {
//                CGContextAddArc(context, x, y, 5, 0, 2 * M_PI, 0);//添加弧线
                [cyc addArcWithCenter:point radius:5 startAngle:0 endAngle:2 * M_PI clockwise:1];
                cycLayer.fillColor = lineColor.CGColor;
            }
            else
            {
//                CGContextAddArc(context, x, y, 3, 0, 2 * M_PI, 0);
                [cyc addArcWithCenter:point radius:3 startAngle:0 endAngle:2 * M_PI clockwise:1];
            }
            cycLayer.path = cyc.CGPath;
            cycLayer.strokeColor = lineColor.CGColor;
            //给每个点加动画
            if ([cycLayer animationForKey:@"strokeEnd"]) {
                [cycLayer removeAnimationForKey:@"strokeEnd"];
            }
            [cycLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
            cycIndex++;

//            CGContextSetLineWidth(context, brokenWidth);
//            CGContextSetStrokeColorWithColor(context,lineColor.CGColor);
//            CGContextSetFillColorWithColor(context, HXWColor(255, 255, 255).CGColor);//填充色
//            CGContextDrawPath(context, kCGPathStroke); //绘制路径
        }
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = lineColor.CGColor;
        if ([pathLayer animationForKey:@"strokeEnd"]) {
            [pathLayer removeAnimationForKey:@"strokeEnd"];
        }
        [pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    }

    //画说明图标
    for (int i = 0; i < self.detailAry.count; i ++) {
        UIColor *detailColor = self.lineColorAry[i];
        CGPoint detailPoint[2];//设置点集合
        CGFloat detailTextWidth = CalcTextWidth([UIFont systemFontOfSize:titleFont], self.detailAry[i]);
        CGFloat detailTextHeight = CalcTextHeight([UIFont systemFontOfSize:titleFont], self.detailAry[i]);
        //计算每个点的坐标
        detailPoint[0] = CGPointMake(self.width - detailWidth - arrowPadding - detailTextWidth - detailPadding, arrowPadding + detailTextHeight/2 + detailTextHeight*i);
        detailPoint[1] = CGPointMake(self.width - arrowPadding - detailTextWidth - detailPadding, arrowPadding + detailTextHeight/2 + detailTextHeight*i);
        CGContextSetLineWidth(context, brokenWidth);//线的宽度
        CGContextSetStrokeColorWithColor(context,detailColor.CGColor);//画笔线的颜色另一种是CGContextSetRGBStrokeColor参数为rgb
        CGContextAddLines(context, detailPoint, 2);//连接线
        CGContextDrawPath(context, kCGPathStroke);//画线
        //画文字
        [self.detailAry[i] drawAtPoint:CGPointMake(self.width - arrowPadding - detailTextWidth, arrowPadding + detailTextHeight*i) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:titleFont], NSFontAttributeName,detailColor,NSForegroundColorAttributeName, nil]];
    }
}


//CABasicanimation   delelgate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //动画结束后的回调
}

@end
