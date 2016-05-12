//
//  HXWNavigationViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/15.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWNavigationViewController.h"

@interface HXWNavigationViewController ()

@end

@implementation HXWNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //说明不是第一个
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;//push时隐藏tabbar

        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
        backBtn.size = backBtn.currentBackgroundImage.size;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
