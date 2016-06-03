//
//  TestModel.h
//  Data
//
//  Created by mac  on 13-3-4.
//  Copyright (c) 2013年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKDaoBase.h"


/* ======================================== 使用实例
 - (IBAction)Btn_AddData:(id)sender {
    TestModel *model=[[[TestModel alloc]init]autorelease];
    model.Bid=@"1";
    model.StoreName=@"测试";
    model.Latitude=@"11";
    model.Longitude=@"22";
    [[DataFactory shardFactory] insertToDB:model];
 }
 //也可以删除全部数据,也可以根据条件删除，自己看工厂的里面的方法
 - (IBAction)Btn_DeleteData:(id)sender {
    TestModel *model=[[[TestModel alloc]init]autorelease];
    model.Bid=@"1";
    model.StoreName=@"测试";
    model.Latitude=@"11";
    model.Longitude=@"22";
    [[DataFactory shardFactory] deleteToDB:model];
 }
 
 - (IBAction)Btn_Update:(id)sender {
    TestModel *model=[[[TestModel alloc]init]autorelease];
    model.Bid=@"1";
    model.StoreName=@"测试22";
    model.Latitude=@"22222";
    model.Longitude=@"22222";
    [[DataFactory shardFactory] updateToDB:model];
 }
 
 - (IBAction)Btn_Select:(id)sender {
    [[DataFactory shardFactory] searchWhere:@{@"Bid":@(1)}
                                    orderBy:nil
                                     offset:0
                                      count:100
                                      Class:[TestModel class]
                                   callback:^(NSArray *result) {
                   NSLog(@"%@",result);
                }];
 }
*/

@interface TestModel:LKModelBase

@property(retain,nonatomic)NSString *Bid;
@property(retain,nonatomic)NSString *StoreName;
@property(retain,nonatomic)NSString *Longitude;
@property(retain,nonatomic)NSString *Latitude;

@end
