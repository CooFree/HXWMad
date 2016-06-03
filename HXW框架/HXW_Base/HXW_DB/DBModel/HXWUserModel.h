//
//  HXWUserModel.h
//  HXW框架
//
//  Created by hxw on 16/5/26.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <FMDatabase/FMDB.h>

@interface HXWUserModel : LKModelBase
@property (nonatomic, assign) int         userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPwd;
@property (nonatomic, strong) NSMutableArray *loginTimeAry;
@end
