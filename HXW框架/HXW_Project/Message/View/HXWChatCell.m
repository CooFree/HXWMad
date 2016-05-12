//
//  HXWChatCell.m
//  HXW框架
//
//  Created by hxw on 16/4/21.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWChatCell.h"
#define imgWidth 200
#define imgHeight 300
#define messageWidth  250        //消息宽度
#define chatPadding    5          //间隔
@implementation HXWChatCell
{
    UIImageView *backImgV;
    UIImageView *iconImgV;
    UIImageView *messageImgV;
    UILabel *messageLbl;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HXWColor(255, 255, 255);
        [self inital];
    }
    return self;
}

-(void)inital
{
    messageLbl = [self createLblWithText:nil Multi:YES];
    messageImgV = [[UIImageView alloc]init];
    iconImgV = [[UIImageView alloc]init];
    backImgV = [[UIImageView alloc]init];
    backImgV.layer.borderWidth = 2;
    backImgV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.contentView addSubview:backImgV];
    [self.contentView addSubview:messageImgV];
    [self.contentView addSubview:messageLbl];
    [self.contentView addSubview:iconImgV];
    
}

-(void)setChatModel:(HXWChatModel *)chatModel
{
    _chatModel = chatModel;
    messageLbl.text = chatModel.message;
    CGFloat messageHeight = CalcArticleHeight([UIFont systemFontOfSize:14], chatModel.message, messageWidth);

    messageImgV.image = image(chatModel.imgStr);
    iconImgV.image = image(chatModel.iconStr);

    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if (messageImgV.image) {
        width = messageImgV.image.size.width;
        height = messageImgV.image.size.height;
        //当图片宽或者高大于给定的宽高值时，根据图片的宽高比确定图片的大小
        if (width > imgWidth||height > imgHeight) {
            CGFloat radio = width/height;
            if (radio > imgWidth/imgHeight)
                //说明图片的宽高比大，以imgWidth给值
            {
                width = imgWidth;
                height = imgWidth/radio;
            }
            else
            {
                height = imgHeight;
                width = imgHeight*radio;
            }
        }
    }
    //消息类型为接收
    if ([chatModel.msgType isEqualToString:@"receive"]) {
        backImgV.image = [image(@"SenderTextNodeBkg") stretchableImageWithLeftCapWidth:30 topCapHeight:50];
        backImgV.contentMode = UIViewContentModeScaleToFill;
        [iconImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(chatPadding);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.trailing.mas_equalTo(-chatPadding);
            make.bottom.mas_lessThanOrEqualTo(-chatPadding);
        }];
        if (chatModel.message.length > 0)
        //消息为文字
        {
            [messageLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(iconImgV.mas_leading).offset(-3*chatPadding);
                make.top.mas_equalTo(3*chatPadding);
                make.width.mas_lessThanOrEqualTo(messageWidth);
                make.height.mas_equalTo(messageHeight);
                make.bottom.mas_equalTo(-3*chatPadding);
            }];
            [backImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(messageLbl).insets(UIEdgeInsetsMake(-padding, -padding, -padding, -padding));
            }];
            messageLbl.hidden = NO;
            messageImgV.hidden = YES;
        }
        else
        //消息为图片
        {
            [messageImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(iconImgV.mas_leading).offset(-2*chatPadding);
                make.top.mas_equalTo(2*chatPadding);
                make.size.mas_equalTo(CGSizeMake(width, height));
                make.bottom.mas_equalTo(-2*chatPadding);
            }];
            [backImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(messageImgV).insets(UIEdgeInsetsMake(-padding, -padding, -padding, -padding));
            }];
            messageImgV.hidden = NO;
            messageLbl.hidden = YES;
        }
    }
    //消息类型为发送
    else
    {
        backImgV.image = [image(@"ReceiverTextNodeBkgHL")stretchableImageWithLeftCapWidth:30 topCapHeight:50];
        backImgV.contentMode = UIViewContentModeScaleToFill;

        [iconImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(chatPadding);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.leading.mas_equalTo(chatPadding);
            make.bottom.mas_lessThanOrEqualTo(-chatPadding);//设置与底部的约束大于等于chatPadding
        }];
        //消息为文字
        if (chatModel.message.length > 0) {
            [messageLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(iconImgV.mas_trailing).offset(3*chatPadding);
                make.top.mas_equalTo(3*chatPadding);
                make.width.mas_lessThanOrEqualTo(messageWidth);
                make.height.mas_equalTo(messageHeight);
                make.bottom.mas_equalTo(-3*chatPadding);
            }];
            [backImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(messageLbl).insets(UIEdgeInsetsMake(-padding, -padding, -padding, -padding));
            }];
            messageLbl.hidden = NO;
            messageImgV.hidden = YES;
        }
        else
        //消息为图片
        {
            [messageImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(iconImgV.mas_trailing).offset(2*chatPadding);
                make.top.mas_equalTo(2*chatPadding);
                make.size.mas_equalTo(CGSizeMake(width, height));
                make.bottom.mas_equalTo(-2*chatPadding);
            }];
            [backImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(messageImgV).insets(UIEdgeInsetsMake(-padding, -padding, -padding, -padding));
            }];
            messageImgV.hidden = NO;
            messageLbl.hidden = YES;
//            messageImgV.layer.mask = backImgV.layer;
        }
    }
}

-(UILabel *)createLblWithText:(NSString *)str Multi:(BOOL)multi
{
    UILabel *lbl = [[UILabel alloc]init];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.layer.borderWidth = 1;
    lbl.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.text = str;
    lbl.textColor = [UIColor blackColor];
    if (multi) {
        lbl.numberOfLines = 0;
        lbl.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return lbl;
}

@end
