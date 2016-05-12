//
//  HXWInterestViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWInterestViewController.h"
#import "brokenLineView.h"

@interface HXWInterestViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    brokenLineView *lineV;
}
@property (nonatomic, strong) NSMutableArray *crlAry;
@property (nonatomic, strong) UIViewController *currentCrl;
@property (nonatomic, strong) NSMutableArray *childNameAry;

@end

@implementation HXWInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightBtn];
    
    
    lineV = [[brokenLineView alloc]init];
    lineV.xAry = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"];
    lineV.yAry = @[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000",@"8000",@"9000",@"10000"];
    
    NSMutableArray *ary1 = [NSMutableArray array];
    NSMutableArray *ary2 = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        [ary1 addObject:[NSString stringWithFormat:@"%d",arc4random_uniform(10000)]];
        [ary2 addObject:[NSString stringWithFormat:@"%d",arc4random_uniform(10000)]];
    }
    lineV.lineAry = @[ary1,ary2];
    lineV.detailAry = @[@"去年",@"今年"];
    lineV.lineColorAry = @[HXWColor(60, 179, 113),HXWColor(205, 85, 85)];
    lineV.duration = 3.0;
    lineV.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64);
    //lineV中有CAShapeLayer的动画，而layer不支持自动布局所以这边要用计算的frame
//    __weak typeof(self)Self = self;
//    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(Self.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
//    }];
    [self.view addSubview:lineV];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if ((lineV.x<point.x<lineV.x + lineV.width)&&(lineV.y<point.y<lineV.y + lineV.height)) {
        [self refresh];
    }
}

-(void)setRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:image(@"navigationbar_more") forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:image(@"navigationbar_more_highlighted") forState:UIControlStateHighlighted];
    rightBtn.size = rightBtn.currentBackgroundImage.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)refresh
{
    NSMutableArray *ary1 = [NSMutableArray array];
    NSMutableArray *ary2 = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        [ary1 addObject:[NSString stringWithFormat:@"%d",arc4random_uniform(10000)]];
        [ary2 addObject:[NSString stringWithFormat:@"%d",arc4random_uniform(10000)]];
    }
    lineV.lineAry = @[ary1,ary2];
    [lineV setNeedsDisplay];
    /*
    setNeedsDisplay和setNeedsLayout两个方法都是异步的，setNeedsDisplay会自动调用drawRect，而setNeedsLayout会自动调用layoutSubviews。
    1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect 掉用是在Controller->loadView, Controller->viewDidLoad 两方法之后掉用的.所以不用担心在 控制器中,这些View的drawRect就开始画了.这样可以在控制器中设置一些值给View(如果这些View draw的时候需要用到某些变量 值).
    2、该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
