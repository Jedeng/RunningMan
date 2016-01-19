//
//  RMTelRegisterSuccessViewController.m
//  RunningMan
//
//  Created by tarena01 on 16/1/17.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMTelRegisterSuccessViewController.h"
#import "RMUserInfo.h"
#import "MBProgressHUD+KR.h"
#import "RMXMPPTool.h"
#import "RMWebRegister.h"


@interface RMTelRegisterSuccessViewController()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;

@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation RMTelRegisterSuccessViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.saveButton.userInteractionEnabled = NO;
    self.saveButton.alpha = 0.4;
}

- (IBAction)verifyPasswordTextFieldTextChange:(id)sender {
    if (self.userPasswordTextField.text.length == 0) {
        return;
    }
    self.saveButton.userInteractionEnabled = YES;
    self.saveButton.alpha = 1.0;
    if (self.verifyPasswordTextField.text.length == 0) {
        self.saveButton.userInteractionEnabled = NO;
        self.saveButton.alpha = 0.4;
    }
}

- (IBAction)saveButtonClick:(id)sender {
    
    NSString *pwd1 = self.userPasswordTextField.text;
    NSString *pwd2 = self.verifyPasswordTextField.text;
    
    if ((pwd1.length < 6) || (pwd2.length < 6)) {
          [MBProgressHUD showError:@"密码至少6位"];
        return;
    }
    if (![pwd1 isEqualToString:pwd2]) {
        [MBProgressHUD showError:@"密码不匹配"];
        return;
    }
    /**  保存信息 */
   RMUserInfo* user = [RMUserInfo sharedRMUserInfo];
    user.registerName = user.userName;
    user.registerPassword = pwd1;
    user.userPassword = pwd1;
    user.userEverLogin = YES;
    user.registerType = YES;
     MYLog(@"before:%@ -- %@ -- %d",user.userName,user.userPassword,user.userEverLogin);
    [user saveUserInfoToSandbox];
    
    // 向服务器 发起一个web注册 产生web账号
    [[RMWebRegister sharedRMWebRegister] webRegister];
    [user loadUserInfoFromSandbox];
    MYLog(@"after:%@ -- %@ -- %d",user.userName,user.userPassword,user.userEverLogin);
    
    /**  验证成功 则自动登录以及保存信息 ,注意隐藏 */
    [MBProgressHUD showMessage:@"正在注册，请等待..."];
    __weak typeof(self) VC = self;
    [[RMXMPPTool sharedRMXMPPTool] userRegister:^(RMXMPPResultType type) {
        /**  变为weak 防止循环引用  */
        [VC handleRegisterResult:type];
    }];
}

-(void)handleRegisterResult:(RMXMPPResultType)type
{
    /**  睡2秒先 */
    [NSThread sleepForTimeInterval:2.0];
    
    [RMUserInfo sharedRMUserInfo].registerType = NO;
    /**  无论是注册成功还是失败都直接登录 */
    [[RMXMPPTool sharedRMXMPPTool] userLogin:^(RMXMPPResultType type) {
        [self handleLoginResult:type];
    }];
}

/**  处理登录结果 注册成功则跳转 */
-(void)handleLoginResult:(RMXMPPResultType)type
{
    [MBProgressHUD hideHUD];
    switch (type) {
        case RMXMPPResultTypeNetError:
            [MBProgressHUD   showError:@"网路错误"];
           //注册失败 网络错误都跳到Login那里
        case RMXMPPResultTypeLoginFailure:
        {
            [MBProgressHUD showError:@"登录失败"];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            break;
        }
        case RMXMPPResultTypeLoginSuccess:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            break;
        }
        default:
            break;
    }
    
}

@end
