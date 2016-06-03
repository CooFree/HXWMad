//
//  HXWDropView.m
//  HXW框架
//
//  Created by hxw on 16/3/31.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWDropView.h"

@implementation HXWDropView
{
    NSArray *titleAry;
}

-(id)init
{
    if (self = [super init]) {
        titleAry = @[@"折线图",@"扇形图",@"柱状图"];
        [self initialSet];
    }
    return self;
}

-(void)initialSet
{
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0;
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = [[UIImage imageNamed:@"popover_background_left"] stretchableImageWithLeftCapWidth:30 topCapHeight:20];
    [self addSubview:imgV];
    __weak typeof(self)HXW = self;
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(HXW).insets(UIEdgeInsetsZero);
    }];
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(HXW).insets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident_cell = @"ident_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident_cell];
    if (nil == cell) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident_cell];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = titleAry[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        [HXWNotificationCenter postNotificationName:@"NotificationMsg_HXWPopOverViewDisMiss" object:nil];
        HXWLog(@"当前线程是 ：%@",[NSThread currentThread]);
    });
    
    [HXWNotificationCenter postNotificationName:@"HXWHomeViewController" object:nil userInfo:@{@"type":[NSString stringWithFormat:@"%ld",(long)indexPath.row]}];
}

@end
