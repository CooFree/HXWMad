//
//  HXWMeViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWMeViewController.h"

@interface HXWMeViewController ()
@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HXWMeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self timer];
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self timer];
    UILabel *lbl = [self createLblWithText:@"@我" Multi:NO];
    lbl.frame = self.view.bounds;
    //下面autoresizingMask和mas_makeConstraints效果是一样的让lbl自适应view的大小
    //    lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:lbl];
    self.lbl = lbl;
    __weak typeof(self)Self = self;

    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Self.view).insets(UIEdgeInsetsZero);
    }];
}

-(void)timeGo
{
    self.lbl.text = [NSString stringWithFormat:@"%@",StringFromDate([NSDate date], @"yyyy-MM-dd-hh:mm:ss")];
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.layer.borderWidth = 2;
    lbl.layer.cornerRadius = 4;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消定时器
    [self.timer invalidate];
    self.timer = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
