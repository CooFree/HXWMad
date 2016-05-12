//
//  HXWTableViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTableViewController.h"
#import "MJRefresh.h"

@interface HXWTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HXWTableViewController

-(id)init
{
    if (self = [self initWithMsgKey:nil style:UITableViewStylePlain]) {
    }
    return self;
}

-(id)initWithMsgKey:(NSString *)msgKey style:(UITableViewStyle)style
{
    if (self = [super init]) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:style];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor clearColor];
        
        if (msgKey.length > 0) {
            [self setValue:msgKey forKey:@"msgKey"];
        }

        /**
         *设置为只读属性的tableview可以在@im中用_tableview指针变量来赋值,只读属性没有set方法，而指针变量赋值不走set方法
         *这边msgKey是父crl只读的属性，只能用self.msgKey调用，不能用_msgKey，因为_msgKey只在父crl中的@im中才能修改，所以这边msgKey用kvc赋值
         */
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    __weak typeof(self)HXW = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(HXW.view).insets(UIEdgeInsetsZero);
    }];
}

-(void)beginRefesh
{
    [self.tableview.mj_header beginRefreshing];
}

-(void)addRefresh
{
    __weak typeof(self)HXW = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [HXW refresh];
    }];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [HXW loadMore];
    }];
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
}

//下拉刷新，实现此方法
-(void)refresh
{
    
}

//加载更多，实现此方法
-(void)loadMore
{
    
}

//结束刷新
-(void)endHeaderRefresh
{
    [self.tableview.mj_header endRefreshing];
}

-(void)endFooterRefresh
{
    [self.tableview.mj_footer endRefreshing];
}

//接受消息
-(void)receiveNotification:(NSNotification *)noti
{
    
}


#pragma mark UITableViewDelegate and UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* HXWTableView_cell = @"HXWTableView_cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:HXWTableView_cell];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:HXWTableView_cell];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section:%lu,row=%lu",(long)indexPath.row, (long)indexPath.row];
    
    return cell;
}

@end
