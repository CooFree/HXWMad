//
//  HXWViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

//测试
static NSMutableDictionary* g_vcStack;

@interface StackItem :NSObject
@property(nonatomic,weak)NSObject*  obj;
@end
@implementation StackItem
+(id)itemWithObj:(NSObject*)obj {
    StackItem* item = StackItem.new;
    item.obj = obj;
    return item;
}

//重写nsobject的描述方法
-(NSString*)description {
    return self.obj.description;
}
@end


#import "HXWViewController.h"

@interface HXWViewController ()

@end

@implementation HXWViewController

- (instancetype)init {
    if (self = [super init]) {
        if (nil == g_vcStack) {
            g_vcStack = [[NSMutableDictionary alloc] init];
        }
        g_vcStack[self.description] = [StackItem itemWithObj:self];
    }
    return self;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        if (nil == g_vcStack) {
            g_vcStack = [[NSMutableDictionary alloc] init];
        }
        g_vcStack[self.description] = [StackItem itemWithObj:self];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        if (nil == g_vcStack) {
            g_vcStack = [[NSMutableDictionary alloc] init];
        }
        g_vcStack[self.description] = [StackItem itemWithObj:self];
    }
    return self;
}

- (NSString *)description {
    return NSStringFromClass([self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HXWLog(@"%@**********viewDidLoad",[self description]);
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

-(UIViewController *)rootViewController
{
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)setRootViewController:(UIViewController *)rootViewController
{
    [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
}

-(void)dealloc
{
    if (self.msgKey.length > 0) {
        [HXWNotificationCenter removeObserver:self];
    }
    HXWLog(@"%@**********dealloc",[self description]);
    [g_vcStack removeObjectForKey:[self description]];
    HXWLog(@"**********g_vcStack = %@",g_vcStack);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    HXWLog(@"%@**********viewWillDisappear",[self description]);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    HXWLog(@"%@**********viewWillAppear",[self description]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    HXWLog(@"%@**********内存警告",[self description]);
}

@end
