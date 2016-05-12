//
//  CycleScrollView.m
//  CycleScrollDemo
//
//  Created by Weever Lu on 12-6-14.
//  Copyright (c) 2012年 linkcity. All rights reserved.
//

#import "CycleScrollView.h"

@interface CycleScrollView()<
UIGestureRecognizerDelegate,
UIScrollViewDelegate
>{
    UIPageControl *pageControl;
    
    UIScrollView *scrollView;
    UIImageView *curImageView;
    
    NSInteger totalPage;
    NSInteger curPage;
    CGRect scrollFrame;
    
    CycleDirection scrollDirection;     // scrollView滚动的方向
    NSArray *imagesArray;               // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
    
    NSTimer *timerShow;
}

@end

@implementation CycleScrollView
@synthesize delegate;
@synthesize animateTime;

- (id)initWithFrame:(CGRect)frame cycleDirection:(CycleDirection)direction pictures:(NSArray *)pictureArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        scrollDirection = direction;
        totalPage = pictureArray.count;
        curPage = 1;                                    // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        animateTime = 0;
        
        scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.backgroundColor = [UIColor blackColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(CGRectGetMinX(scrollFrame),
                                                                      frame.size.height-50,
                                                                      frame.size.width,
                                                                      30)];
        pageControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        pageControl.numberOfPages = pictureArray.count;
        [self addSubview:pageControl];
        
        // 在水平方向滚动
        if(scrollDirection == CycleDirectionLandscape) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3,
                                                scrollView.frame.size.height);
        }
        // 在垂直方向滚动
        if(scrollDirection == CycleDirectionPortait) {
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,
                                                scrollView.frame.size.height * 3);
        }
        
        
        [self refreshScrollView];
    }
    
    return self;
}

- (void)setPictureArray:(NSArray *)pictureArray{
    _pictureArray = pictureArray;
    
    totalPage = pictureArray.count;
    imagesArray = [[NSArray alloc] initWithArray:pictureArray];
    pageControl.numberOfPages = pictureArray.count;
}
- (void)setAnimateTime:(float)_animateTime {
    if (imagesArray.count <= 1) {
        return;
    }
    if (_animateTime > 0) {
        animateTime = _animateTime;
        if (timerShow) {
            [timerShow invalidate];
            timerShow = nil;
        }
        timerShow = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(animateNext:) userInfo:nil repeats:YES];
        [timerShow fire];
    }
}

- (void)animateNext:(NSTimer *)timer {
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        int x = scrollView.contentOffset.x+20;
        int y = scrollView.contentOffset.y;
        scrollView.contentOffset = CGPointMake(x, y);
        if (scrollView.contentOffset.x == scrollView.frame.size.width) {
            [timer pause];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [timer resume];
            });
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        int x = scrollView.contentOffset.x;
        int y = scrollView.contentOffset.y+20;
        scrollView.contentOffset = CGPointMake(x, y);
        if (scrollView.contentOffset.y == scrollView.frame.size.height) {
            [timer pause];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [timer resume];
            });
        }
    }
}

- (void)refreshScrollView {
    
    NSArray *subViews = [scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        imageView.image = image([curImages objectAtIndex:i]);
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        singleTap.delegate = self;
        [imageView addGestureRecognizer:singleTap];
        
        // 水平滚动
        if(scrollDirection == CycleDirectionLandscape) {
            imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        }
        // 垂直滚动
        if(scrollDirection == CycleDirectionPortait) {
            imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * i);
        }
        
        
        [scrollView addSubview:imageView];
    }
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height)];
    }
}

- (NSArray *)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:curPage-1];
    NSInteger last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last-1]];
    
    return curImages;
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == 0) value = totalPage;                   // value＝1为第一张，value = 0为前面一张
    if(value == totalPage + 1) value = 1;
    
    return value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    int x = aScrollView.contentOffset.x;
    int y = aScrollView.contentOffset.y;
    
    // 水平滚动
    if(scrollDirection == CycleDirectionLandscape) {
        // 往下翻一张
        if(x >= (2*scrollFrame.size.width)) {
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(x <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    // 垂直滚动
    if(scrollDirection == CycleDirectionPortait) {
        // 往下翻一张
        if(y >= 2 * (scrollFrame.size.height)) {
            curPage = [self validPageValue:curPage+1];
            [self refreshScrollView];
        }
        if(y <= 0) {
            curPage = [self validPageValue:curPage-1];
            [self refreshScrollView];
        }
    }
    
    pageControl.currentPage = curPage-1;
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didScrollImageView:)]) {
        [delegate cycleScrollViewDelegate:self didScrollImageView:curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    //    int x = aScrollView.contentOffset.x;
    //    int y = aScrollView.contentOffset.y;
    //    TPLLOG(@"--end  x=%d  y=%d", x, y);
    
    if (scrollDirection == CycleDirectionLandscape) {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
    }
    if (scrollDirection == CycleDirectionPortait) {
        [scrollView setContentOffset:CGPointMake(0, scrollFrame.size.height) animated:YES];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([delegate respondsToSelector:@selector(cycleScrollViewDelegate:didSelectImageView:)]) {
        [delegate cycleScrollViewDelegate:self didSelectImageView:curPage];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
