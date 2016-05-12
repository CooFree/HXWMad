//
//  HXWPopOverView.h
//  UIPopViewController
//
//  Created by hxw on 15/7/27.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef  NS_ENUM(NSInteger, HXWPointDirection)
//{
//    HXWPopOverViewDirection_Up,
//    HXWPopOverViewDirection_Left,
//    HXWPopOverViewDirection_Down,
//    HXWPopOverViewDirection_Right
//};

typedef enum
{
    HXWPopOverViewDirection_Up = 0,
    HXWPopOverViewDirection_Left,
    HXWPopOverViewDirection_Down,
    HXWPopOverViewDirection_Right
}HXWPopOverViewDirection;

typedef void (^popOverViewBlock) (id data);


@interface HXWPopOverView : UIView

/**
 *	@brief	弹出pop窗口<窗口外围不变暗，点了外围区域窗口消失>
 * 弹出窗口颜色和contentView背景颜色同
 * 特别说明：主动关闭pop窗口通过调用：
 *         NotificationPost(NotificationMsg_HXWPopOverViewDisMiss, nil, data);data会通过回调block传给所在页面
 *	@param 	contentView 	任何形式view，窗口尺寸根据contentView的frame.size而定，所以设好再传进来
 *	@param 	targetView 	在哪个targetView上弹<箭头指向>
 *	@param 	direction 	    箭头从哪个方向指向目标view
 *	@param 	completionBlock      确定状态的回调Block
 */

+(HXWPopOverView *)showPopOverView:(UIView *)contentView
                 atView:(UIView *)targetView
              direction:(HXWPopOverViewDirection)direction
             completion:(popOverViewBlock)completionBlock;


@end
