//
//  HXWLoginTimePoint.h
//  HXW框架
//
//  Created by hxw on 16/5/27.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <FMDatabase/FMDB.h>

@interface HXWLoginTimePoint : LKModelBase
@property (nonatomic, assign) int timePointId;
@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *timePoint;
@end
