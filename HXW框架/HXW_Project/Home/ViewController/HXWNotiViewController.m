//
//  HXWNotiViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/16.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWNotiViewController.h"

@interface HXWNotiViewController ()

@end

@implementation HXWNotiViewController
-(void)getNotification
{
    HXWLog(@"我是提醒");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [HXWNotificationCenter addObserver:self selector:@selector(getNotification) name:@"消息" object:nil];

    UILabel *lbl = [self createLblWithText:@"通知" Multi:NO];
    lbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lbl];
    __weak typeof(self)Self = self;
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(Self.view).insets(UIEdgeInsetsZero);
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
