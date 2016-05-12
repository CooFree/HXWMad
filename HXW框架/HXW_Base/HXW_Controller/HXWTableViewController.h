//
//  HXWTableViewController.h
//  HXW框架
//
//  Created by hxw on 16/3/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXWViewController.h"

@interface HXWTableViewController : HXWViewController
@property (nonatomic, strong, readonly) UITableView *tableview;
-(id)initWithMsgKey:(NSString *)msgKey style:(UITableViewStyle)style;
-(void)addRefresh;//添加下拉刷新
-(void)beginRefesh;//进入刷新状态
-(void)refresh;//下拉刷新，实现此方法
-(void)loadMore;//加载更多，实现此方法
-(void)endHeaderRefresh;
-(void)endFooterRefresh;
@end
