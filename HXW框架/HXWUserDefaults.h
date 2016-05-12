//
//  HXWUserDefaults.h
//  HXWProjectNotes
//
//  Created by hxw on 16/3/4.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXWUserDefaults : NSObject
@property (nonatomic, strong) NSString *hxwName;
@property (nonatomic, strong) NSString *hxwPw;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *headPic;

+(HXWUserDefaults *)instance;

@end
