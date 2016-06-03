//
//  HXWMeViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWMeViewController.h"
#import "JSONKit.h"
#import "HXWHomeModel.h"

@interface HXWMeViewController ()
@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation HXWMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lbl = [self createLblWithText:@"@我" Multi:NO];
    lbl.frame = self.view.bounds;
    //下面autoresizingMask和mas_makeConstraints效果是一样的让lbl自适应view的大小
    //    lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:lbl];
    self.lbl = lbl;
    __weak typeof(self)Self = self;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    
//    NSURL *url = [NSURL URLWithString:@"https://api.douban.com/v2/movie/subject/26279433"];
//    NSString *jsonString =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *dic = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
//    HXWLog(@"json 数据为：%@",dic);
//    HXWHomeModel *model = [HXWHomeModel objectWithKeyValues:dic];
//    HXWLog(@"model 数据为：%@和%@",model.aka,model.alt);
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Self.view).insets(UIEdgeInsetsZero);
    }];
}

-(void)timeUp
{
    self.lbl.text = StringFromDate([NSDate date], @"yy-MM-dd-hh-mm-ss");
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
    [self.timer invalidate];
    self.timer = nil;
}

@end
