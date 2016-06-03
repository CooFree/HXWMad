//
//  HXWLoginViewController.m
//  HXW框架
//
//  Created by hxw on 16/5/25.
//  Copyright © 2016年 hxw. All rights reserved.
//

#import "HXWLoginViewController.h"
#import "HXWTabbarViewController.h"
#import "HXWUserModel.h"
#import "HXWLoginTimePoint.h"

@interface HXWLoginViewController ()<UITextFieldDelegate>
{
    UITextField *txtName;
    UITextField *txtPwd;
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@end

@implementation HXWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    //背景图片
    UIImageView *loginBgView = [[UIImageView alloc]init];
    loginBgView.image = Image(@"login_bg");
    [self.view addSubview:loginBgView];
    
    UIImageView *nameBgView = [[UIImageView alloc]init];
    nameBgView.image = Image(@"txt_name");
    [self.view addSubview:nameBgView];
    
    UIImageView *pwdBgView = [[UIImageView alloc]init];
    pwdBgView.image = Image(@"txt_pwd");
    [self.view addSubview:pwdBgView];
    
    //输入框和登入按钮
    txtName = [self createTextWithPlaceHolder:@"请输入用户名"];
    txtName.delegate = self;
    [self.view addSubview:txtName];
    
    txtPwd = [self createTextWithPlaceHolder:@"请输入密码"];
    txtPwd.delegate = self;
    [self.view addSubview:txtPwd];
    
    UIButton *loginBtn = [self createBtnWithText:@"登入" action:@selector(login)];
    [self.view addSubview:loginBtn];

    //布局
    __weak typeof(self)Self = self;
    [loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(Self.view);
    }];
    [nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(Self.view);
        make.centerY.mas_equalTo(Self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(331, 52));
    }];
    [pwdBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(nameBgView);
        make.centerY.mas_equalTo(Self.view).offset(30);
        make.size.mas_equalTo(nameBgView);
    }];
    [txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(nameBgView).insets(UIEdgeInsetsMake(5, 50, 5, 5));
    }];
    [txtPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(pwdBgView).insets(UIEdgeInsetsMake(5, 50, 5, 5));
    }];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(pwdBgView).multipliedBy(.5);
        make.height.mas_equalTo(pwdBgView);
        make.centerX.mas_equalTo(pwdBgView);
        make.centerY.mas_equalTo(pwdBgView).offset(60);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self login];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.textAlignment == NSTextAlignmentRight) {
        textField.text = @"";
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = [UIFont systemFontOfSize:14];
    }
}

-(void)login
{
    if ([txtName.text isEqualToString:@"!请输入用户名"]) {
        return;
    }
    if ([txtPwd.text isEqualToString:@"!请输入密码"]) {
        return;
    }
    if (txtName.text.length <= 0) {
        txtName.text = @"!请输入用户名";
        txtName.textColor = [UIColor redColor];
        txtName.textAlignment = NSTextAlignmentRight;
        txtName.font = [UIFont systemFontOfSize:12];
        return;
    }
    if (txtPwd.text.length <= 0) {
        txtPwd.text = @"!请输入密码";
        txtPwd.textColor = [UIColor redColor];
        txtPwd.textAlignment = NSTextAlignmentRight;
        txtPwd.font = [UIFont systemFontOfSize:12];
        return;
    }
//    NSString *url = @"/login";
//    NSDictionary *dic  = @{@"username":txtName.text,
//                           @"pwd":txtPwd.text};
//    __weak typeof(self)Self = self;
//    [HYBNetworking getWithUrl:url params:dic progress:nil success:^(id response) {
//        NSLog(@"get成功%@",response);
//        HXWTabbarViewController *tabbar = [[HXWTabbarViewController alloc]init];
//        Self.rootViewController = tabbar;
//    } fail:^(NSError *error) {
//        NSLog(@"get失败%@",error);
//    }];
    NSString *sql = @"select * from userList";
    __block BOOL isUserNameRight = NO;
    __block BOOL isUserPwdRight = NO;
    __block HXWUserModel *userModel;
    [DB searchSQL:sql Class:[HXWUserModel class] callback:^(NSArray *results) {
        HXWLog(@"%@",results);
        for (HXWUserModel *model in results) {
            if ([model.userName isEqualToString:txtName.text]) {
                isUserNameRight = YES;
            }
            if ([model.userPwd isEqualToString:txtPwd.text]) {
                isUserPwdRight = YES;
            }
            if (isUserNameRight&&isUserPwdRight) {
                userModel = model;
                break;
            }
        }
    }];
    if (!isUserNameRight) {
        HXWLog(@"用户名不存在");
        return;
    }
    if (isUserNameRight&&!isUserPwdRight) {
        HXWLog(@"密码输入有误");
        return;
    }
    //数据库登入时间表插入
    HXWLoginTimePoint *loginTime = [[HXWLoginTimePoint alloc]init];
    loginTime.timePoint = StringFromDate([NSDate date], @"yyyy-MM-dd hh:mm:ss");
    loginTime.userId = userModel.userId;
    __block int timePointId;
    //数据库查找，results直接是对象的集合
    [DB searchSQL:@"select * from loginTimePointList" Class:[HXWLoginTimePoint class] callback:^(NSArray *results) {
        if (results.count == 0) {
            timePointId = -1;
        }
        else
        {
            HXWLoginTimePoint *timePoint = [results lastObject];
            timePointId = timePoint.timePointId;
        }
    }];
    loginTime.timePointId = timePointId + 1;
    [DB insertToDB:loginTime];
    
    [HXWUserDefaults instance].userName = txtName.text;
    [HXWUserDefaults instance].userPwd = txtPwd.text;
    
    HXWTabbarViewController *tabVc = [[HXWTabbarViewController alloc]init];
    self.rootViewController = tabVc;
}

-(void)sql
{
    //数据库事务操作
    HXWUserModel *model1 = [[HXWUserModel alloc]init];
    model1.userId = 1;
    model1.userName = @"Hxwa";
    model1.userPwd = @"234";
    HXWUserModel *model2 = [[HXWUserModel alloc]init];
    model2.userId = 2;
    model2.userName = @"Hxwb";
    model2.userPwd = @"345";
    HXWUserModel *model3 = [[HXWUserModel alloc]init];
    model3.userId = 3;
    model3.userName = @"Hxwc";
    model3.userPwd = @"456";
    [DB transactionToDB:@[model1,model2,model3]];
    
    [DB searchWhere:@{@"userPwd":@"123"} orderBy:nil offset:0 count:100 Class:[HXWUserModel class] callback:^(NSArray *results) {
        HXWLog(@"============%@",results);
    }];
}

-(UITextField *)createTextWithPlaceHolder:(NSString *)holder
{
    UITextField *text = [[UITextField alloc]init];
    text.backgroundColor = [UIColor whiteColor];
    text.textColor = [UIColor blackColor];
    text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    text.layer.borderWidth = 0;
    text.layer.cornerRadius = 0;
    text.placeholder = holder;
    text.font = [UIFont systemFontOfSize:14];
    
    UIColor *color = [UIColor lightGrayColor];
    text.attributedPlaceholder = [[NSAttributedString alloc] initWithString:holder attributes:@{NSForegroundColorAttributeName: color}];
    return text;
}

-(UIButton *)createBtnWithText:(NSString *)str action:(SEL)sel
{
    UIButton *btn = [[UIButton alloc]init];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 0;
    btn.layer.cornerRadius = 8;
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitle:str forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:Image(@"new_feature_finish_button_highlighted") forState:UIControlStateSelected];
    [btn setBackgroundImage:Image(@"new_feature_finish_button") forState:UIControlStateNormal];
    return btn;
}

@end
