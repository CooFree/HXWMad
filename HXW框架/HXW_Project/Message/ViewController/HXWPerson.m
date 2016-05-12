//
//  HXWPerson.m
//  HXW框架
//
//  Created by hxw on 16/4/13.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWPerson.h"
#import <objc/runtime.h>

@implementation HXWPerson

-(void)sayUnDefine
{
    HXWLog(@"objc_msgSend可以让对象运行在.h中没有声明的方法");
}

-(void)sayHello
{
    HXWLog(@"wo shi peroson");
}

/*
 动态添加方法:当走valueForKey时会直接调用这个方法？
 */
void cry(id self,SEL _cmd)
{
    HXWLog(@"wo  cry");
}

//是在调用此类方法时，如果没有这个方法就会掉这个函数。
+(BOOL)resolveInstanceMethod:(SEL)sel
{
    class_addMethod([self class], sel, (IMP)cry, "v@:");
    return [super resolveInstanceMethod:sel];
}

/*
 动态替换方法
 */
void smile(id self,SEL _cmd)
{
    HXWLog(@"wo smile");
}

-(void)replaceMethod
{
    class_replaceMethod([self class], @selector(sayHello), (IMP)smile, "v@:");
}

-(NSArray *)allPropertieNames
{
    //获取对象的属性
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i ++) {
        const char *property = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:property];
        [ary addObject:name];
    }
    free(properties);//这里是使用的是C语言的API，因此我们也需要使用C语言的释放内存的方法free。
    return ary;
}

- (NSDictionary *)dicFromModel
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSArray *propertyNames = [self allPropertieNames];
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = [self valueForKey:propertyNames[idx]];
        if (value) {
            [dic setValue:value forKey:propertyNames[idx]];
        }
    }];
    return dic;
}

-(void)modelFromDic:(NSDictionary *)dic
{
    NSArray *propertyNames = [self allPropertieNames];
    [propertyNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (dic[propertyNames[idx]]) {
            [self setValue:dic[propertyNames[idx]] forKey:propertyNames[idx]];
        }
    }];
}


@end


