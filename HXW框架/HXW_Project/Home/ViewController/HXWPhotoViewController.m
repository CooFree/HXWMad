//
//  HXWPhotoViewController.m
//  HXW框架
//
//  Created by hxw on 16/5/11.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWPhotoViewController.h"

@interface HXWPhotoViewController ()

@end

@implementation HXWPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:_imageName];
    [self.view addSubview:imgV];
    __weak typeof(self)Self = self;
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(Self.view).insets(UIEdgeInsetsZero);
    }];
}

@end
