//
//  SDAnalogDataGenerator.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDAnalogDataGenerator.h"

static NSArray *namesArray;
static NSArray *iconNamesArray;
static NSArray *messagesArray;

@implementation SDAnalogDataGenerator

+ (NSString *)randomName
{
    int randomIndex = arc4random_uniform((int)[self names].count);
    return [self names][randomIndex];
}

+ (NSString *)randomIconImageName
{
    int randomIndex = arc4random_uniform((int)[self iconNames].count);
    return iconNamesArray[randomIndex];
}

+ (NSString *)randomMessage
{
    int randomIndex = arc4random_uniform((int)[self messages].count);
    return messagesArray[randomIndex];
}

+ (NSArray *)names
{
    if (!namesArray) {
        namesArray = @[@"二龙湖浩哥",
                       @"微风",
                       @"夜在哭泣",
                       @"GSD_iOS",
                       @"hello world",
                       @"大脸猫",
                       @"你似不似傻",
                       @"天天向上",
                       @"不爱掏粪男孩",
                       @"最爱欧巴",
                       @"大长腿思密达",
                       @"别给我晒脸",
                       @"可爱男孩",
                       @"筷子姐妹",
                       @"法海你不懂爱",
                       @"长城长",
                       @"老北京麻辣烫",
                       @"我不搞笑",
                       @"原来我不帅",
                       @"亲亲我的宝贝",
                       @"请叫我吴彦祖",
                       @"帅锅莱昂纳多",
                       @"星星之火",
                       @"雅蠛蝶~雅蠛蝶"
                       ];
    }
    return namesArray;
}

+ (NSArray *)iconNames
{
    if (!iconNamesArray) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            NSString *iconName = [NSString stringWithFormat:@"icon%d.jpg", i];
            [temp addObject:iconName];
        }
        iconNamesArray = [temp copy];
    }
    return iconNamesArray;
}

+ (NSArray *)messages
{
    if (!messagesArray) {
        messagesArray = @[@"二龙湖浩哥：什么事？🐂🐂🐂🐂GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"微风：麻蛋！！！GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"夜在哭泣：好好地，🐂别瞎胡闹",
                          @"GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"hello world：🐂🐂🐂我不懂GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"大脸猫：这。。。。。。酸爽~ http://www.cocoachina.com/ios/20151223/14778.html",
                          @"你似不似傻：呵呵🐎🐎🐎🐎🐎🐎GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"天天向上：辛苦了！GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"不爱掏粪男孩：新年快乐！猴年大吉！摸摸哒 http://www.cocoachina.com/ios/20151223/14778.html",
                          @"最爱欧巴：[呲牙][呲牙][呲牙]",
                          @"大长腿思密达：[图片]GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"别给我晒脸：坑死我了。。。。。",
                          @"可爱男孩：你谁？？？🐎🐎🐎🐎",
                          @"筷子姐妹：和尚。。尼姑。。",
                          @"法海你不懂爱：春晚太难看啦，妈蛋的🐎🐎🐎🐎🐎🐎🐎🐎",
                          @"长城长：好好好~~~",
                          @"老北京麻辣烫：约起 http://www.cocoachina.com/ios/20151223/14778.html",
                          @"我不搞笑：寒假过得真快GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"原来我不帅：有木有人儿？GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"亲亲我的宝贝：你🐎说🐎啥🐎呢GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"请叫我吴彦祖：好搞笑🐎🐎🐎，下次还来GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"帅锅莱昂纳多：我不理解 http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"星星之火：脱掉，脱掉，统统脱掉🐎GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html",
                          @"雅蠛蝶~雅蠛蝶：好脏，好污，好喜欢GSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.htmlGSD_iOS：SDAutoLayout  下载地址http://www.cocoachina.com/ios/20151223/14778.html"
                          ];
    }
    return messagesArray;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com