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
    self.view.backgroundColor = [ UIColor clearColor];
    UILabel *idxLbl = [self createLblWithText:[NSString stringWithFormat:@"点击了第%ld页",(long)self.index] Multi:NO];
    [self.view addSubview:idxLbl];
    idxLbl.frame = CGRectMake(0, 0, self.view.width, 400);
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.layer.borderWidth = 1;
    lbl.layer.cornerRadius = 4;
    lbl.font = [UIFont systemFontOfSize:30];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}


@end
