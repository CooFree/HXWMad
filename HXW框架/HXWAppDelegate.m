//
//  HXWAppDelegate.m
//  HXW框架
//
//  Created by hxw on 16/3/17.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWAppDelegate.h"
#import "HXWLoginViewController.h"
#import "HXWTabbarViewController.h"
/*测试*/
@implementation HXWAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //数据库设置
    [self sqliteSetting];
    //设置网络
    [self remoteSetting];
    //全局设置
    [self totalSet];
    //设置键盘
    [self handleKeyBoard];
    //创建窗口
    self.window = [[HXWWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
//    HXWLoginViewController *login = [[HXWLoginViewController alloc]init];
    HXWTabbarViewController *login = [[HXWTabbarViewController alloc]init];
    //设置根控制器
    self.window.rootViewController = login;
    //显示
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)sqliteSetting
{
    //拷贝初始化数据库，当沙盒中没有数据库时拷贝全路径中的数据库至沙盒路径所以当你想在数据库中添加表，要在ResourcePath(@"db.sqlite")路径下的数据库添加，并把沙盒中原来的数据库删除，另外数组类型不能添加到数据库中存储，只能多加一张表，用id标识
    NSString* path = ConfigPath(@"db.sqlite");
    if (!ExistAtPath(path)) {
        NSString* contentFile = ResourcePath(@"db.sqlite");
        NSData *data = [NSData dataWithContentsOfFile:contentFile];
        SaveFile(path, data);
    }
    [DataFactory setDatabasePath:ConfigPath(nil)];
}

-(void)remoteSetting
{
    [HYBNetworking updateBaseUrl:@"http://192.168.10.20/nc_mobile_service"];
    [HYBNetworking netWorkStatus];
    [HYBNetworking enableInterfaceDebug:YES];
}

-(void)totalSet
{
    [UINavigationBar appearance].barTintColor = HXWColor(233, 116, 40);
//    [UINavigationBar appearance].tintColor = HXWColor(238, 121, 66);
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:HXWColor(255, 255, 255)};
}

-(void)handleKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
