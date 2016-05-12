//
//  HXWViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWViewController.h"

@interface HXWViewController ()

@end

@implementation HXWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HXWLog(@"%@**********viewDidLoad",[self class]);
}

-(id)initWithMsgKey:(NSString *)msgKey
{
    if (self = [super init]) {
        self.msgKey = msgKey;
    }
    return self;
}

-(void)setMsgKey:(NSString *)msgKey
{
    [HXWNotificationCenter addObserver:self selector:@selector(receiveNotification:) name:msgKey object:nil];
    _msgKey = msgKey;
}

//接受消息重写此方法
-(void)receiveNotification:(NSNotification *)noti
{
    
}

-(void)dealloc
{
    [HXWNotificationCenter removeObserver:self];
    HXWLog(@"%@**********dealloc",[self class]);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    HXWLog(@"%@**********viewWillDisappear",[self class]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    HXWLog(@"%@**********viewWillAppear",[self class]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    HXWLog(@"%@**********内存警告",[self class]);
}

@end
