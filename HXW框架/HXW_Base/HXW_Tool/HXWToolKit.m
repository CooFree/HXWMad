//
//  HXWToolKit.m
//  HXW微博
//
//  Created by hxw on 16/3/16.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWToolKit.h"

float CalcTextHeight(UIFont *font, NSString* text){
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(0, 2000)
                                        options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize.height;
}

float CalcTextWidth(UIFont *font, NSString* text){
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(2000, 0)
                                        options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize.width;
}


//下面这种方法更精确，会把换行到第二行而因为是一个单词所浪费的空间计算在内
float CalcArticleHeight(UIFont *font, NSString* article, CGFloat width){
    CGSize articleSize = [article boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
    return articleSize.height;
}


NSString* StringFromDate(NSDate* aDate, NSString *aFormat) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //	[formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSTimeZone *tzCCT = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzCCT];
    [formatter setDateFormat:aFormat];
    NSString *dateString = [formatter stringFromDate:aDate];
    
    return dateString;
}


UIImage* image(NSString *imageName){
    return [UIImage imageNamed:imageName];
}

NSString *cachePath(NSString *filePath){
    NSString *cachePath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *string = [cachePath stringByAppendingPathComponent:filePath];
    NSLog(@"%@",string);
    if (![fileManager fileExistsAtPath:string]) {
        if (![fileManager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"create filepath fail:%@", string);
        }
    }
    return string;
}

NSString* resourcePath(NSString *filePath)
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@",filePath];
}

UIImage * thumbnailWithImage(UIImage *image,CGSize asize)
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(asize, NO, 2.0);
        }
        else
        {
            UIGraphicsBeginImageContext(asize);
        }
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

UIImage * thumbnailWithImageSameScale(UIImage *image,CGSize asize)
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(asize, NO, 2.0);
        }
        else
        {
            UIGraphicsBeginImageContext(asize);
        }
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}
