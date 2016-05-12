//
//  UILabel+ThemeKit.m
//  HXWProjectNotes
//
//  Created by hxw on 15/8/5.
//  Copyright (c) 2015年 hxw. All rights reserved.
//

#import "UILabel+ThemeKit.h"
#import <objc/runtime.h>

@implementation UILabel(ThemeKit)
@dynamic lineSpace;
@dynamic headIndent;

static float lineSpaceKey;
static float headIndentKey;


+(instancetype)theme
{
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UIThemes" ofType:@"plist"]];
    NSDictionary *tmp = [dic objectForKey:@"UILabel_Customer"];
    UILabel *label = [[UILabel alloc]init];
    
    NSString *color1 = [tmp objectForKey:@"textColor"];
    SEL textSel = NSSelectorFromString(color1);
    UIColor* textColor = nil;
    if ([UIColor respondsToSelector: textSel])
    {
        textColor  = [UIColor performSelector:textSel];
    }
    label.textColor = textColor;
    //字符串转化成颜色
    NSString *color2 = [tmp objectForKey:@"backgroundColor"];
    SEL backSel = NSSelectorFromString(color2);
    UIColor* backColor = nil;
    if ([UIColor respondsToSelector: backSel])
    {
        backColor  = [UIColor performSelector:backSel];
    }
    label.textColor = backColor;
    
    
    label.textAlignment = (int)[tmp objectForKey:@"textalignment"];
    label.font = [UIFont systemFontOfSize:[[tmp objectForKey:@"fontSize"] floatValue]];
    return label;
}

-(void)setLineSpace:(CGFloat)lineSpace
{
    objc_setAssociatedObject(self, &lineSpaceKey, [NSString stringWithFormat:@"%f",lineSpace], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self resetContent];
}

-(CGFloat)lineSpace
{
    return [objc_getAssociatedObject(self, &lineSpaceKey) floatValue];
}

-(void)setHeadIndent:(CGFloat)headIndent
{
    objc_setAssociatedObject(self, &headIndentKey, [NSString stringWithFormat:@"%f",headIndent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self resetContent];
}

-(CGFloat)headIndent
{
    return [objc_getAssociatedObject(self, &headIndentKey) floatValue];
}

-(void)resetContent
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    if (self.lineSpace) {
        [paragraphStyle setLineSpacing:self.lineSpace];
    }
    if (self.headIndent) {
        [paragraphStyle setFirstLineHeadIndent:self.headIndent];
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
