//
//  HXWChatCell.h
//  HXW框架
//
//  Created by hxw on 16/4/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXWChatModel.h"

static NSString * const HXWChatCellIdentifier = @"HXWChatCellIdentifier";
@interface HXWChatCell : UITableViewCell
@property (nonatomic, strong) HXWChatModel *chatModel;
-(void)setChatModel:(HXWChatModel *)chatModel;
@end
