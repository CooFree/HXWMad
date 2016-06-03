//
//  HXWHomeViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWHomeViewController.h"
#import "HXWCycleView.h"
#import "CycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HXWDropView.h"
#import "HXWPopOverView.h"
#import "HXWInterestViewController.h"
#import "HXWHomeCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HXWTopicViewController.h"
#import "HXWModelWindow.h"
#import "HXWPhotoViewController.h"
#import "HXWLoginViewController.h"

@interface HXWHomeViewController ()<HXWCycleViewDelegate>
@property (nonatomic, strong) HXWCycleView *cycleV;
@property (nonatomic, strong) NSArray *picAry;
@end

@implementation HXWHomeViewController

-(void)receiveNotification:(NSNotification *)noti
{
    HXWInterestViewController *interCrl = [[HXWInterestViewController alloc]init];
    interCrl.type = noti.userInfo[@"type"];
    [self.navigationController pushViewController:interCrl animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HXWRandomColor;
    self.picAry = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    [self.tableview registerClass:[HXWHomeCell class] forCellReuseIdentifier:HXWHomeCellIdentification];
    [self addRefresh];
    [self setleftBtn];
    [self setRightBtn];
}

-(void)setleftBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(dropMenu:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:Image(@"timeline_icon_more") forState:UIControlStateNormal];
    [rightBtn setImage:Image(@"timeline_icon_more_highlighted") forState:UIControlStateHighlighted];
    [rightBtn setTitle:@"浦东新区" forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(7.5, 10, 7.5, 0)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//内容左对齐,效果不明显
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    rightBtn.backgroundColor = HXWColor(51, 153, 102);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    rightBtn.size = CGSizeMake(100, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)setRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:Image(@"tabbar_profile") forState:UIControlStateNormal];
    [rightBtn setImage:Image(@"tabbar_profile_selected") forState:UIControlStateSelected];
    rightBtn.size = CGSizeMake(30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

-(void)login:(UIButton *)btn
{
    HXWLoginViewController *login = [[HXWLoginViewController alloc]init];
    self.rootViewController = login;
}

-(void)dropMenu:(UIButton *)btn
{
    HXWDropView *dropView = [[HXWDropView alloc]init];
    dropView.frame = CGRectMake(0, 0, 100, 130);//这边就是传入dropview 的宽高
    [HXWPopOverView showPopOverView:dropView atView:btn direction:HXWPopOverViewDirection_Down completion:^(id data){
    }];
}

-(void)refresh
{
    sleep(2);
    [self endHeaderRefresh];
}

-(void)loadMore
{
    sleep(2);
    [self endFooterRefresh];
}

#pragma mark HXWPageViewDelegate
#pragma required
-(NSInteger)numberOfPagesInCycleView:(HXWCycleView *)hxwCycleView
{
    return self.picAry.count;
}

-(UIView *)viewForPageInCycleView:(HXWCycleView *)hxwCycleView atIndex:(NSInteger)index
{
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.image = Image(self.picAry[index]);
    imgV.backgroundColor = HXWRandomColor;
    return imgV;
}

#pragma optional
-(void)deSelectPageInCycleView:(HXWCycleView *)hxwCycleView atIndex:(NSInteger)index
{
    HXWLog(@"点击了第%ld张",index);
    HXWPhotoViewController *photoV = [[HXWPhotoViewController alloc]init];
    photoV.index = index;
    ModelWindowConfig *config = [[ModelWindowConfig alloc]init];
    config.headerInterval = (self.view.height - 400)/2;
    config.modelWidth = self.view.width;
    config.rightInterval = 0;
    config.footerInterval = (self.view.height - 400)/2;
    config.cornerRadius = 2;
    config.direction = HXWModelWindowDirection_Up;
    //    config.imgVBKImage = [NSString stringWithFormat:@"syz.jpg"];
    [HXWModelWindow setModelConfig:config];
    [HXWModelWindow showModelWindow:photoV touchedDismiss:YES confirmBlock:nil cancelBlock:^(id data) {
        NSString *str = [(NSDictionary *)data objectForKey:@"key"];
        HXWLog(@"%@",str);
    }];
}

-(NSString *)titleForPageInCycleView:(HXWCycleView *)hxwCycleView atIndex:(NSInteger)index
{
    NSArray *titleAry = @[@"国足晋级12强啦！",@"国足要崛起了么？",@"乒乓球又是吊打全世界",@"美人鱼问鼎票房冠军"];
    return titleAry[index];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:HXWHomeCellIdentification cacheByIndexPath:indexPath configuration:^(id cell) {
            [cell setContentStr:@"极冻之地，雪域有女，声媚，肤白，眸似月，其发如雪；有诗叹曰：千古冬蝶，万世凄绝。"];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *ident_cellPage = @"ident_cellPage";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident_cellPage];
        if (nil == cell) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident_cellPage];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.backgroundColor = [UIColor lightGrayColor];
            HXWCycleView *cycleV = [[HXWCycleView alloc]init];
            cycleV.delegate = self;
            cycleV.currentPage = 1;
//            cycleV.animateTime = 1;
            cycleV.backgroundColor = HXWRandomColor;
            [cell addSubview:cycleV];
            __weak typeof(cell)HXW = cell;
            [cycleV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(HXW).insets(UIEdgeInsetsZero);
            }];
            self.cycleV = cycleV;
        }
        return cell;
    }
    else
    {
        HXWHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:HXWHomeCellIdentification];
        
        [cell setContentStr:@"极冻之地，雪域有女，声媚，肤白，眸似月，其发如雪；有诗叹曰：千古冬蝶，万世凄绝。"];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXWTopicViewController *topCrl = [[HXWTopicViewController alloc]init];
    [self.navigationController pushViewController:topCrl animated:YES];
}


@end
