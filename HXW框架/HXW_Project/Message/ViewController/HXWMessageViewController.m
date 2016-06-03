//
//  HXWMessageViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWMessageViewController.h"
#import "HXWChatCell.h"
#import "HXWChatModel.h"
#import "SDAnalogDataGenerator.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface HXWMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *itemAry;
}
@end

@implementation HXWMessageViewController

-(void)receiveNotification:(NSNotification *)noti
{
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableview registerClass:[HXWChatCell class] forCellReuseIdentifier:HXWChatCellIdentifier];
//    itemAry = [[NSMutableArray alloc]init];
//    [self addRefresh];
//    [self beginRefesh];
}

-(void)refresh{
    [self initalData];
}

-(void)initalData
{
    self.tableview.userInteractionEnabled = NO;
    for (int i = 0; i<10; i ++) {
        HXWChatModel *model = [[HXWChatModel alloc]init];
        model.iconStr = [NSString stringWithFormat:@"%@/%@", @"HXWResource.bundle/weixin", [SDAnalogDataGenerator randomIconImageName]];
        model.message = [SDAnalogDataGenerator randomMessage];
        model.imgStr = [NSString stringWithFormat:@"%@/%@", @"HXWResource.bundle/weixin", [NSString stringWithFormat:@"pic%d.jpg",arc4random_uniform(9)]];
        model.msgType = arc4random_uniform(2) == 0?[NSString stringWithFormat:@"receive"]:[NSString stringWithFormat:@"send"];
        [itemAry addObject:model];
    }
    __weak typeof(self)Self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Self.tableview reloadData];
        [Self endHeaderRefresh];
        Self.tableview.userInteractionEnabled = YES;
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:HXWChatCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setChatModel:itemAry[indexPath.row]];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXWChatCell *cell = [tableView dequeueReusableCellWithIdentifier:HXWChatCellIdentifier];
    cell.chatModel = itemAry[indexPath.row];
    return cell;
}

@end
