//
//  CycleScrollView.h
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CycleDirectionPortait,          // 垂直滚动
    CycleDirectionLandscape         // 水平滚动
}CycleDirection;

@class CycleScrollView;

@protocol CycleScrollViewDelegate <NSObject>
@optional
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didSelectImageView:(NSInteger)index;
- (void)cycleScrollViewDelegate:(CycleScrollView *)cycleScrollView didScrollImageView:(NSInteger)index;
@end

@interface CycleScrollView : UIView

@property (nonatomic, strong) NSArray *pictureArray;

@property (nonatomic, assign) float animateTime;
@property (nonatomic, assign) id<CycleScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray;

- (NSInteger)validPageValue:(NSInteger)value;
- (NSArray *)getDisplayImagesWithCurpage:(NSInteger)page;
- (void)refreshScrollView;

@end
