//
//  HXWInterestViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWInterestViewController.h"
#import "BrokenLineView.h"
#import "CircleView.h"
#import "HistogramView.h"

@interface HXWInterestViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    BrokenLineView *lineV;
    CircleView *circleV;
    HistogramView *histogramV;
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
    
    if ([_type isEqualToString:@"0"]) {
        lineV = [[BrokenLineView alloc]init];
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
    else if([_type isEqualToString:@"1"])
    {
        circleV = [[CircleView alloc]init];
        circleV.radius = 100;
        circleV.centerTitle = @"我是扇形图";
        circleV.lineWidth = 50;
        circleV.duration = .5;
        circleV.itemAry = @[@"1",@"2",@"3",@"4"];
        circleV.pecentAry = @[@".25",@".15",@".3",@".3"];
        circleV.colorAry = @[HXWColor(155, 205, 155),HXWColor(205, 145, 158),HXWColor(194, 194, 194),HXWColor(238, 220, 130)];
        circleV.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64);
        [self.view addSubview:circleV];
    }
    else
    {
        histogramV = [[HistogramView alloc]init];
        histogramV.itemAry = @[@[@"64",@"30",@"70"],@[@"90",@"60",@"40"],@[@"75",@"99",@"26"]];
        histogramV.xAry = @[@"武力值",@"心胸",@"谋略"];
        histogramV.yAry = @[@"0",@"25",@"50",@"75",@"100"];
        histogramV.duration = 1;
        histogramV.colorAry = @[HXWColor(155, 205, 155),HXWColor(205, 145, 158),HXWColor(194, 194, 194)];
        histogramV.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64);
        [self.view addSubview:histogramV];
    }
}

-(void)setRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:Image(@"navigationbar_more") forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:Image(@"navigationbar_more_highlighted") forState:UIControlStateHighlighted];
    rightBtn.size = rightBtn.currentBackgroundImage.size;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
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
