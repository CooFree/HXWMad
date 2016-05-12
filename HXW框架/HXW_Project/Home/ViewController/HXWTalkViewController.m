//
//  HXWTalkViewController.m
//  HXW微博
//
//  Created by hxw on 16/3/16.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWTalkViewController.h"
#import "MJRefresh.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface HXWTalkViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger num;
}
@end

@implementation HXWTalkViewController


-(void)getNotification
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [HXWNotificationCenter addObserver:self selector:@selector(getNotification) name:@"消息" object:nil];
    num = 5;
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    __weak typeof(self)HXW = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(HXW.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [HXW loadNew];
    }];
//    [header setImages:@[[UIImage imageNamed:@"load1.jpg"]] duration:.1 forState:MJRefreshStateIdle];
//    [header setImages:@[[UIImage imageNamed:@"load1.jpg"]] duration:.1 forState:MJRefreshStatePulling];
//    [header setImages:@[[UIImage imageNamed:@"load1.jpg"],[UIImage imageNamed:@"load2.jpg"],[UIImage imageNamed:@"load3.jpg"]] duration:.1 forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
    
    MJRefreshFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [HXW loadNew];
    }];
    _tableView.mj_footer = footer;
//    UILabel *lbl = [self createLblWithText:@"评论" Multi:NO];
//    lbl.frame = self.view.bounds;
//    [self.view addSubview:lbl];
//    __weak typeof(self)Self = self;
//    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(0);
//        make.trailing.mas_equalTo(0);
//        make.size.equalTo(Self.view);
//    }];
    
//    UILabel *lbl = [self createLblWithText:@"聊天" Multi:NO];
//    lbl.frame = self.view.bounds;
//    [self.view addSubview:lbl];
//    __weak typeof(self)Self = self;
//    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(Self.view).insets(UIEdgeInsetsZero);
//    }];
//    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//    }];
    [_tableView.mj_header beginRefreshing];
    HXWLog(@"当前线程－－－－－－－－－－－－－－－%@",[NSThread currentThread]);
//
//    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//    [queue addOperation:operation];

}

-(void)loadNew
{
    num = num + 5;
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.layer.borderWidth = 2;
    lbl.layer.cornerRadius = 4;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident_cell = @"ident_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident_cell];
    if (nil == cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident_cell];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
