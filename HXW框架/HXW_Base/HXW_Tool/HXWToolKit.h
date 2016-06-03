//
//  HXWToolKit.h
//  HXW
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

//{@缩略图
//缩略到指定大小
extern UIImage *ThumbnailWithImage(UIImage *image,CGSize asize);
//宽高比不变，缩略到指定大小@}
extern UIImage *ThumbnailWithImageSameScale(UIImage *image,CGSize asize);

//根据图片路径加载图片
extern UIImage *Image(NSString *imgName);

//日期转字符串
extern NSString *StringFromDate(NSDate* aDate, NSString *aFormat);

//{@文件操作
//检查路径是否存在
extern BOOL ExistAtPath(NSString* fileFullPath);
//数据库路径
extern NSString *ConfigPath(NSString* fileName);
//缓存路径
extern NSString *CachePath(NSString *filePath);
//获取资源全路径
extern NSString *ResourcePath(NSString *filePath);
//删除所有cache文件
void RemoveCacheFiels(void);
//删除文件
BOOL RemoveFile(NSString* fileName);
//存储文件@}
void SaveFile(NSString* fileName, NSData* data);




