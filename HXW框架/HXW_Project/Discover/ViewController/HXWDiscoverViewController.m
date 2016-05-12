//
//  HXWDiscoverViewController.m
//  HXW框架
//
//  Created by hxw on 16/3/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWDiscoverViewController.h"
#import "HXWWeiXinModel.h"
#import "HXWWenXinCell.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface HXWDiscoverViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataAry;
    dispatch_semaphore_t semaphore;
    BOOL isLoad;
}
@end

@implementation HXWDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataAry = [NSMutableArray array];
    [self.tableview registerClass:[HXWWenXinCell class] forCellReuseIdentifier:HXWWeiXinCellIdentifier];
    [self addRefresh];
    [self beginRefesh];
    semaphore = dispatch_semaphore_create(1);
}

//下拉刷新
-(void)refresh
{
    self.tableview.userInteractionEnabled = NO;
    NSArray *ary = [self createData];
    if (dataAry.count == 0) {
        [dataAry addObjectsFromArray:ary];
    }
    else
    {
        [ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dataAry replaceObjectAtIndex:idx withObject:ary[idx]];
        }];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self endHeaderRefresh];
        self.tableview.userInteractionEnabled = YES;
    });
}

//上啦加载
-(void)loadMore
{
    // Invalid update: invalid number of rows in section 0.  The number of rows contained in an existing section after the update (7) must be equal to the number of rows contained in that section before the update (7), plus or minus the number of rows inserted or deleted from that section (0 inserted, 1 deleted) and plus or minus the number of rows moved into or out of that section (0 moved in, 0 moved out).'
   // 包含在已存在的section中的行数量在更新后必须等于更新之前对应section的行数量加上或减去插入或删除的行的数量。
    //如果不设置userInteractionEnabled那么在滑动刷新的过程中点击展开会报上面的错误
    isLoad = YES;
    [dataAry addObjectsFromArray:[self createData]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self endFooterRefresh];
        isLoad = NO;
    });
}

-(NSArray *)createData
{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何，https://github.com/gsdios/SDAutoLayoutgrtgrtgtgtrgr等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/ffewwfwefewfewrttretet然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真，再回首恍然如梦，再回首我心依旧，只有那不变的长路伴着我",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
//
//    NSArray *picImageNamesArray = @[ @"pic0.jpg",
//                                     @"pic1.jpg",
//                                     @"pic2.jpg",
//                                     @"pic3.jpg",
//                                     @"pic4.jpg",
//                                     @"pic5.jpg",
//                                     @"pic6.jpg",
//                                     @"pic7.jpg",
//                                     @"pic8.jpg"
//                                     ];
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        HXWWeiXinModel *model = [HXWWeiXinModel new];
        model.headerImg = [NSString stringWithFormat:@"%@/%@", @"HXWResource.bundle/weixin", iconImageNamesArray[iconRandomIndex]];
        model.nameStr = namesArray[nameRandomIndex];
        model.contentStr = textArray[contentRandomIndex];
        
        
        // 模拟“随机图片”
//        int random = arc4random_uniform(10);
//        
//        NSMutableArray *temp = [NSMutableArray new];
//        for (int i = 0; i < random; i++) {
//            int randomIndex = arc4random_uniform(9);
//            [temp addObject:picImageNamesArray[randomIndex]];
//        }
//        if (temp.count) {
//            model.picNamesArray = [temp copy];
//        }
//        
        int commentRandom = arc4random_uniform(6);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            HXWWeiXinCommentModel *commentItemModel = [HXWWeiXinCommentModel new];
            int index = arc4random_uniform((int)namesArray.count);
            commentItemModel.firstName = namesArray[index];
            if (arc4random_uniform(10) < 5) {
                commentItemModel.secondName = namesArray[arc4random_uniform((int)namesArray.count)];
            }
            commentItemModel.comment = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
        }
        model.commentAry = [tempComments copy];
        
        [resArr addObject:model];
    }
    return [resArr copy];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataAry.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:HXWWeiXinCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell setModel:dataAry[indexPath.row]];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXWWenXinCell *cell = [tableView dequeueReusableCellWithIdentifier:HXWWeiXinCellIdentifier];
    cell.idx = indexPath.row;
    __weak typeof(self)HXW = self;
    [cell setTapMoreBtnBlock:^(NSInteger idx) {
        if (!isLoad) {
            HXWWeiXinModel *model = dataAry[idx];
            model.isOpen = !model.isOpen;
            [HXW.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    cell.model = dataAry[indexPath.row];
    return cell;
}

@end
