//
//  HXWUserDefaults.m
//  HXWProjectNotes
//
//  Created by hxw on 16/3/4.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWUserDefaults.h"
static HXWUserDefaults *userDefaultsInstance = nil;

@implementation HXWUserDefaults
{
    NSUserDefaults *defaults;
    NSDictionary* plistInfo;
}
//+(HXWUserDefaults *)instance
//{
//    static dispatch_once_t *onces;
//    dispatch_once(onces, ^{
//        userDefaultsInstance = [[HXWUserDefaults alloc]init];
//    });
//    return userDefaultsInstance;
//}

+(HXWUserDefaults *)instance
{
    //@synchronized 的作用是创建一个互斥锁，保证此时没有其它线程对self对象进行修改。
    @synchronized(self) {
        if (userDefaultsInstance == nil) {
            userDefaultsInstance = [[self alloc] init];
        }
    }
    return userDefaultsInstance;
}

-(id)init
{
    if (self = [super init]) {
        defaults = [NSUserDefaults standardUserDefaults];
        plistInfo = [NSDictionary dictionaryWithContentsOfFile:resourcePath(@"Info.plist")];
    }
    return self;
}

//应用的版本号
-(NSString *)appVersion
{
    return [plistInfo objectForKey:@"CFBundleShortVersionString"];
}

//应用的中文名称
- (NSString*) appName {
    return [plistInfo objectForKey:@"CFBundleName"];
}

-(void)setHxwName:(NSString *)hxwName
{
    [defaults setObject:hxwName forKey:@"hxwName"];
}

-(NSString *)hxwName
{
    return [defaults objectForKey:@"hxwName"];
}

-(void)setHxwPw:(NSString *)hxwPw
{
    [defaults setObject:hxwPw forKey:@"hxwPw"];
}

-(NSString *)hxwPw
{
    return [defaults objectForKey:@"hxwPw"];
}

-(NSString *)headPic
{
    return [defaults objectForKey:@"headPic"];
}

-(void)setHeadPic:(NSString *)headPic
{
    [defaults setObject:headPic forKey:@"headPic"];
}

@end
