//
//  HXWPageView.h
//  HXW
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HXWCycleViewDelegate;
@interface HXWCycleView : UIView
@property (nonatomic, assign) NSInteger currentPage;//默认为1,第一页
@property (nonatomic, assign) float animateTime;
@property (nonatomic, assign) id<HXWCycleViewDelegate> delegate;
@end

@protocol  HXWCycleViewDelegate<NSObject>
@required
- (NSInteger)numberOfPagesInCycleView:(HXWCycleView *)hxwCycleView;
- (UIView *)viewForPageInCycleView:(HXWCycleView *)hxwCycleView atIndex:(NSInteger)index;
@optional
- (NSString *)titleForPageInCycleView:(HXWCycleView *)hxwCycleView  atIndex:(NSInteger)index;
-(void)deSelectPageInCycleView:(HXWCycleView *)hxwCycleView atIndex:(NSInteger)index;
@end