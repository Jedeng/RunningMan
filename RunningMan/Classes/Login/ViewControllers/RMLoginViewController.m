//
//  RMLoginViewController.m
//  RunningMan
//
//  Created by tarena01 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMLoginViewController.h"
#import "RMUserInfo.h"
#import "MBProgressHUD+KR.h"
#import "RMXMPPTool.h"
#import "AppDelegate.h"

@interface RMLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;


- (IBAction)loginButtonClick:(id)sender;
- (IBAction)forgetPasswordButtonClick:(id)sender;
- (IBAction)registerButtonClick:(id)sender;


@end

@implementation RMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma  mark - 视图出现时
/** 设置输入文本框左边的图标 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /** 设置账号输入框的左视图 */
    UIImage *imageN = [UIImage imageNamed:@"icon"];
    UIImageView *leftN = [[UIImageView alloc]initWithImage:imageN];
    leftN.frame = CGRectMake(0, 0, 55, 20);
    leftN.contentMode = UIViewContentModeCenter;
    self.userNameTextField.leftView  = leftN;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    /** 设置密码输入框的左视图 */
    UIImage *imageP = [UIImage imageNamed:@"lock"];
    UIImageView *leftP = [[UIImageView alloc]initWithImage:imageP];
    leftP.frame = CGRectMake(0, 0, 55, 20);
    leftP.contentMode = UIViewContentModeCenter;
    self.userPasswordTextField.leftView = leftP;
    self.userPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
   
    /**  注册成功过 则自动登录 */
    if ([RMUserInfo sharedRMUserInfo].everRegister)
    {
        self.userNameTextField.text = [RMUserInfo sharedRMUserInfo].userName;
        self.userPasswordTextField.text = [RMUserInfo sharedRMUserInfo].userPassword;
    }
    
}

#pragma mark - 按钮被点击
/**  登录按钮被点击 */
- (IBAction)loginButtonClick:(id)sender {
  
    /** 判断用户名密码不能为空 */
    if(self.userNameTextField.text.length == 0){
        [MBProgressHUD showError:@"用户名不能为空"];
        return;
    }
  
    if(self.userPasswordTextField.text.length == 0){
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    RMUserInfo *userInfo = [RMUserInfo sharedRMUserInfo];
    [MBProgressHUD showMessage:@"正在登录..."];
    userInfo.userName = self.userNameTextField.text;
    userInfo.userPassword = self.userPasswordTextField.text;
    userInfo.registerType = NO;
    
    // 点击登录按钮 调用工具的登录方法
    __weak  typeof(self) vc = self;
    [[RMXMPPTool sharedRMXMPPTool] userLogin:^(RMXMPPResultType type) {
        [vc handleLoginResultType:type];
    }];
    
}
/** 处理登录的返回状态 */
- (void) handleLoginResultType:(RMXMPPResultType) type
{
    [MBProgressHUD hideHUD];
    switch (type) {
        case RMXMPPResultTypeLoginSuccess:
        {
            MYLog(@"登录成功");
            
            [RMUserInfo sharedRMUserInfo].loginStatus = YES;
            [[RMUserInfo sharedRMUserInfo] saveUserInfoToSandbox];
            // 切换到主界面
            UIStoryboard *stroyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = stroyborad.instantiateInitialViewController;
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setupNavigationController];
            
            break;
        }
        case RMXMPPResultTypeLoginFailure:
            [MBProgressHUD showError:@"登录失败"];
            MYLog(@"登录失败");
            break;
        case RMXMPPResultTypeNetError:
            [MBProgressHUD showError:@"网络繁忙"];
            MYLog(@"网络错误");
            break;
        default:
            break;
    }
}

/**  忘记密码按钮被点击 */
- (IBAction)forgetPasswordButtonClick:(id)sender {
    
}

/**  注册按钮被点击 */
- (IBAction)registerButtonClick:(id)sender {

}

@end
