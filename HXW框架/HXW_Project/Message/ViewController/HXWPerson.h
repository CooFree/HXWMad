//
//  HXWPerson.h
//  HXW框架
//
//  Created by hxw on 16/4/13.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXWPerson : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *img;

-(void)sayHello;
-(void)replaceMethod;
-(NSArray *)allPropertieNames;
//模型转字典
- (NSDictionary *)dicFromModel;
//字典转模型
-(void)modelFromDic:(NSDictionary *)dic;
@end


