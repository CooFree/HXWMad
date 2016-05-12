//
//  HXWCenterViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWCenterViewController.h"
@interface HXWCenterViewController ()
@end

@implementation HXWCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [HXWNotificationCenter postNotificationName:@"消息" object:nil userInfo:nil];
    

    self.titleAry = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    self.crlAry = @[@"HXWMeViewController",@"HXWSecertViewController",@"HXWTalkViewController",@"HXWNotiViewController",@"HXWMeViewController",@"HXWSecertViewController",@"HXWTalkViewController",@"HXWNotiViewController"];
}

-(void)backtouch
{
    [HXWNotificationCenter postNotificationName:@"HXWProfileViewController" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIButton *)createBtnWithText:(NSString *)str action:(SEL)sel
{
    UIButton *btn = [[UIButton alloc]init];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 4;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
