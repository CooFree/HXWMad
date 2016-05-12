//
//  HXWModelWindow.h
//  UIPopViewController
//
//  Created by hxw on 15/7/30.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HXWModelWindowDirection_Up = 0,
    HXWModelWindowDirection_Left,
    HXWModelWindowDirection_Down,
    HXWModelWindowDirection_Right
}HXWModelWindowDirection;

@interface ModelWindowConfig : NSObject//配置弹出window的所有参数
@property (nonatomic, assign) CGFloat headerInterval;
@property (nonatomic, assign) CGFloat modelWidth;
@property (nonatomic, assign) CGFloat footerInterval;
@property (nonatomic, assign) CGFloat rightInterval;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) HXWModelWindowDirection direction;
@property (nonatomic, assign) float imgVBKAlpha;        //弹出window时的背景的透明度，如果不加背景，由于弹出时的动画效果有时间间隔，所以点击弹出事件时，若快速点击可以响应多次，默认为0.3f
@property (nonatomic, strong) NSString *imgVBKImage;
@end

typedef void (^ModelWindowBlock) (id data);
@interface HXWModelWindow : UIView
/**
 *	@brief	CYGModelWindow通用配置
 *
 *	@param 	config 	配置信息
 */
+(HXWModelWindow *)setModelConfig:(ModelWindowConfig *)config;

/**
 *	@brief	弹出模态窗口
 * 特别说明：关闭模态窗口通过调用：
 *         NotificationPost(NotificationMsg_HXWModelWindowDisMiss, nil, data);data会通过回调block传给所在页面
 *	@param 	viewController 	模态窗口
 *	@param 	isTouchedDismiss 	是否点击空白处时销毁
 *	@param 	confirmBlock 	确定状态的回调Block
 *	@param 	cancelBlock 	取消状态的回调Block
 */

+(HXWModelWindow *)showModelWindow:(UIViewController *)viewController
        touchedDismiss:(BOOL)isTouchedDismiss
          confirmBlock:(ModelWindowBlock)confirmBlock
           cancelBlock:(ModelWindowBlock)cancelBlock;



@end
