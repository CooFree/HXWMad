//
//  HXWPic.m
//  HXW微博
//
//  Created by hxw on 16/3/18.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWPic.h"
#define nameKey @"nameKey"

@implementation HXWPic
#pragma mark - NSCoding
/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_picName forKey:nameKey];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _picName = [aDecoder decodeObjectForKey:nameKey];
    }
    return self;
}

@end
