//
//  HXWProfileViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWProfileViewController.h"
#import "HXWProfileCell.h"
#import "HXWTableViewCell.h"
#import "HXWHeadPhotoViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface HXWProfileViewController ()
{
    NSArray *imgAry;
    NSArray *titleAry;
}
@end

@implementation HXWProfileViewController

-(void)receiveNotification:(NSNotification *)noti
{
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated{
    //选中后取消选中
    NSIndexPath *select = [self.tableview indexPathForSelectedRow];
    if (select) {
        [self.tableview deselectRowAtIndexPath:select animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableview registerClass:[HXWProfileCell class] forCellReuseIdentifier:HXWTestHeightCellIdentifier];
    imgAry = @[@"album",@"collect",@"pay",@"vip",@"like"];
    titleAry = @[@"图片",@"收藏",@"支付",@"会员",@"喜欢"];
    self.view.backgroundColor = HXWColor(248, 248, 255);
    [self addRefresh];
    [self beginRefesh];
}

-(void)refresh
{
    sleep(2);
    [self endHeaderRefresh];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    else
    {
        return 40;
    }
}

//修改header和footer颜色
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = HXWColor(248, 248, 255);
//    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
//    [footer.textLabel setTextColor:[UIColor whiteColor]];//修改文字颜色
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return padding;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self tableView:tableView titleCellForRowAtIndexPath:indexPath];
    }
    else
    {
        static NSString *ident_cell = @"ident_cell";
        HXWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident_cell];
        if (nil == cell) {
            cell  = [[HXWTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident_cell];
        }
        if (indexPath.row == 0) {
            cell.headLine.hidden = NO;
            [cell.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(padding);
            }];
        }
        else if (indexPath.row == titleAry.count - 1)
        {
            cell.headLine.hidden = YES;
            [cell.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(0);
            }];
        }
        else
        {
            cell.headLine.hidden = YES;
            [cell.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(padding);
            }];
        }
        cell.imageView.image = thumbnailWithImage(image(imgAry[indexPath.row]), CGSizeMake(160, 160));
        cell.textLabel.text = titleAry[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView titleCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXWProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:HXWTestHeightCellIdentifier];
    cell.headLine.hidden = NO;
    [cell.bottomLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(0);
    }];
    cell.titleLbl.text = @"江阴影魔";
    cell.picView.image = image([cachePath(@"picCache") stringByAppendingPathComponent:[HXWUserDefaults instance].headPic]);
    cell.codeView.image = image(@"code");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后取消选中
    if (indexPath.row == 0) {
        HXWHeadPhotoViewController *headerCrl = [[HXWHeadPhotoViewController alloc]initWithMsgKey:@"HXWHeadPhotoViewController"];
        headerCrl.imgName = [cachePath(@"picCache") stringByAppendingPathComponent:[HXWUserDefaults instance].headPic];
        [self.navigationController pushViewController:headerCrl animated:YES];
    }
}


@end
