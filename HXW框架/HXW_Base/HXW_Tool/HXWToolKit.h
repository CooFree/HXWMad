//
//  HXWToolKit.h
//  HXW微博
//
//  Created by hxw on 16/3/16.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import <Foundation/Foundation.h>

//计算单行文字实际高度,宽度
extern float CalcTextHeight(UIFont *font, NSString* text);
extern float CalcTextWidth(UIFont *font, NSString* text);
//计算多行文字高度
extern float CalcArticleHeight(UIFont *font, NSString* article, CGFloat width);
//缩略图
//缩略到指定大小
extern UIImage * thumbnailWithImage(UIImage *image,CGSize asize);
//宽高比不变，缩略到指定大小
extern UIImage * thumbnailWithImageSameScale(UIImage *image,CGSize asize);

extern NSString* StringFromDate(NSDate* aDate, NSString *aFormat);
extern UIImage* image(NSString *imgName);
extern NSString *cachePath(NSString *filePath);
extern NSString *resourcePath(NSString *filePath);