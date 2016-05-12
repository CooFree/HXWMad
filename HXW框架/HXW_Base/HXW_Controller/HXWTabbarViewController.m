//
//  HXWTabbarViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/14.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTabBar.h"
#import "HXWTabbarViewController.h"
#import "HXWNavigationViewController.h"

#import "HXWHomeViewController.h"
#import "HXWMessageViewController.h"
#import "HXWDiscoverViewController.h"
#import "HXWProfileViewController.h"
#import "HXWCenterViewController.h"


@interface HXWTabbarViewController ()

@end

@implementation HXWTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置子控制器
    HXWLog(@"%@ ----- viewDidLoad",[self class]);

    HXWHomeViewController *home = [[HXWHomeViewController alloc] initWithMsgKey:@"HXWHomeViewController"  style:UITableViewStylePlain];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    HXWMessageViewController *messageCenter = [[HXWMessageViewController alloc] initWithMsgKey:@"HXWMessageViewController" style:UITableViewStylePlain];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    HXWDiscoverViewController *discover = [[HXWDiscoverViewController alloc]  initWithMsgKey:@"HXWDiscoverViewController" style:UITableViewStylePlain];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    HXWProfileViewController *profile = [[HXWProfileViewController alloc] initWithMsgKey:@"HXWProfileViewController" style:UITableViewStylePlain];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    HXWTabBar *tabbar = [[HXWTabBar alloc]init];
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
//    [self addChildViewController:home];
//    [self addChildViewController:messageCenter];
//    [self addChildViewController:discover];
//    [self addChildViewController:profile];
    //    tabbarVc.viewControllers = @[vc1, vc2, vc3, vc4];
    
    // 很多重复代码 ---> 将重复代码抽取到一个方法中
    // 1.相同的代码放到一个方法中
    // 2.不同的东西变成参数
    // 3.在使用到这段代码的这个地方调用方法， 传递参数
}

-(void)clickCenterBtn:(HXWTabBar *)tabBar
{
    /*
     切换控制器的手段
     1.push：依赖于UINavigationController，控制器的切换是可逆的，比如A切换到B，B又可以回到A
     2.modal：控制器的切换是可逆的，比如A切换到B，B又可以回到A
     3.切换window的rootViewController
     modal方式，不建议采取：新特性控制器不会销毁
     */

    
    //这种不可取
//    HXWAddViewController *addV = [[HXWAddViewController alloc]init];
//    [self presentViewController:addV animated:YES completion:nil];
    //在HXWAddViewController中也用presentViewController
    /**
     *  用model方式，在新的界面发送通知给homeviewcontroller，homeviewcontroller接受到消息，说明虽然tabbarcontroller的view消失了，window显示addV的view，但是tabbarcontroller并没有被释放，即tabbarcontroller容器下的viewcontrollers都没被释放，多次点击内存泄漏会越来越大
     *  用rootViewController方式，原来的viewcontroller就被释放了
     */
    //可以
//    HXWCenterViewController *centerV = [[HXWCenterViewController alloc]init];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = centerV;
    
    //可以
    HXWCenterViewController *centerV = [[HXWCenterViewController alloc]init];
    [self presentViewController:centerV animated:YES completion:nil];
    //在HXWCenterViewController中    [self dismissViewControllerAnimated:YES completion:nil];


    
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字和图片
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
//    childVc.tabBarItem.badgeValue = @"55";
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//图片按原始状态显示，不被渲染成别的颜色
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HXWColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = HXWRandomColor;
    HXWNavigationViewController *navi = [[HXWNavigationViewController alloc]initWithRootViewController:childVc];
    [self addChildViewController:navi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    HXWLog(@"%@**********dealloc",[self class]);
}

@end
