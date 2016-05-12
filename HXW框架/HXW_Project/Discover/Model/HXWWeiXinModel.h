//
//  HXWWeiXinModel.h
//  HXW框架
//
//  Created by hxw on 16/4/6.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXWWeiXinModel : NSObject
@property (nonatomic, strong) NSString *headerImg;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *picAry;
@property (nonatomic, assign) BOOL isShowMoreBtn;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSArray *commentAry;
@end


@interface HXWWeiXinCommentModel : NSObject
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSString *comment;
@end