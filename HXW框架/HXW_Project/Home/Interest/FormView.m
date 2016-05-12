//
//  FormView.m
//  HXW框架
//
//  Created by hxw on 16/4/25.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "FormView.h"
@interface FormView()
{
    int num;
}

@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSMutableArray *levelAry;

@end

@implementation FormView

-(NSMutableArray *)dataAry
{
    if (!_dataAry) {
        _dataAry = [[NSMutableArray alloc]init];
    }
    return _dataAry;
}

-(NSMutableArray *)_levelAry
{
    if (!_levelAry) {
        _levelAry = [[NSMutableArray alloc]init];
    }
    return _levelAry;
}

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.layer.borderWidth = 1;
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

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [self expand:_dataDic];
}

-(void)expand:(NSDictionary*)dic
{
    [self.dataAry addObject:dic];
    NSArray *childs = [dic objectForKey:@"Objects"];
    //判断是否有子数组
    if (childs.count > 0) {
        //展开子数组
        for (NSDictionary *dic in childs) {
            //找最大层
            if ([[dic objectForKey:@"level"] intValue] > num) {
                num = [[dic objectForKey:@"level"] intValue];
            }
            [self expand:dic];
        }
    }
}

-(void)layoutSubviews
{
    for (int i = 0; i < num; i ++) {
        NSMutableArray *ary = [NSMutableArray array];
        for (NSDictionary *dic in self.dataAry) {
            if ([[dic objectForKey:@"level"] intValue] == i) {
                [ary addObject:dic];
            }
        }
        [self.levelAry addObject:ary];
    }
    for (int i = 0; i < self.levelAry.count; i++) {
        NSArray *ary = self.levelAry[i];
        if (i == 0) {
            NSDictionary *dic = ary[0];
            UILabel *lbl = [self createLblWithText:[dic objectForKey:@"name"] Multi:NO];
            lbl.frame = CGRectMake(0, 0, self.width, self.height/num);
            [self addSubview:lbl];
        }
        else
        {
            NSArray *formAry = self.levelAry[i - 1];
            for (int i = 0; i < formAry.count; i ++) {
                
            }
        }
    }
}

@end
