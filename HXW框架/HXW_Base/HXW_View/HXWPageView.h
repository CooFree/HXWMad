//
//  HXWPageView.h
//  HXW
//
//  Created by hxw on 16/3/22.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HXWPageViewDelegate;
@interface HXWPageView : UIView
@property (nonatomic, assign) NSInteger currentPage;//当前页，默认为1
@property (nonatomic, assign) BOOL isAddTouch;//是否加点击事件，默认为不加
@property (nonatomic, weak) id<HXWPageViewDelegate> delegate;
@end

@protocol  HXWPageViewDelegate<NSObject>
@required
- (NSInteger)numberOfPagesInPagingView:(HXWPageView *)hxwPageView;
- (UIView *)viewForPageInPagingView:(HXWPageView *)hxwPageView atIndex:(NSInteger)index;
@optional
-(void)deSelectPageInPagingView:(HXWPageView *)hxwPageView atIndex:(NSInteger)index;
-(void)deScrollToPage:(NSInteger)index InPagingView:(HXWPageView *)hxwPageView;
-(void)deScrollOffsetInPagingView:(HXWPageView *)hxwPageView offset:(CGFloat)offset isChange:(BOOL )isChange;
@end