//
//  RMRegisterTableViewController.m
//  RunningMan
//
//  Created by tarena01 on 16/1/16.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMRegisterTableViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD+KR.h"
#import "RMUserInfo.h"
#import "RMXMPPTool.h"
#import "RMWebRegister.h"

@interface RMRegisterTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;

@end

@implementation RMRegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.verificationBtn.userInteractionEnabled = NO;
    self.verificationBtn.alpha=0.4;
}

- (IBAction)comebackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  获取验证码
- (IBAction)getTelVerificationCodeButtonClick:(id)sender {
    NSString *tel =self.telTextField.text;
    if ( tel.length == 0 ) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    /**  判断输入的格式 */
    if (tel.length == 11) {
        if( ([tel longLongValue] > 13000000000) && ([tel longLongValue] < 19000000000) )
            {
                [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:tel zone:@"86" customIdentifier:nil result:^(NSError *error) {
                    if (error) {
                        MYLog(@"发送验证码错误：%@",error);
                    }else{
                        MYLog(@"验证码已成功发出");
                        [MBProgressHUD showSuccess:@"验证码已成功发出"];
                    }
                }];
                
            }else
            {
                [MBProgressHUD showError:@"您输入的号码格式不正确"];
            }
    }
    else{
        [MBProgressHUD showError:@"您输入的号码格式不正确"];
    }
}

#pragma mark - 注册验证

- (IBAction)verificationCodeTextFieldDidEditingChange:(id)sender {
    self.verificationBtn.userInteractionEnabled = YES;
    self.verificationBtn.alpha = 1;
    if(self.verificationCodeTextField.text.length == 0 )
    {
        self.verificationBtn.userInteractionEnabled = NO;
        self.verificationBtn.alpha = 0.4;
    }
    
}

- (IBAction)verificationButtonClick:(id)sender {
    MYLog(@"beginghjkl;ghjk");
    [SMSSDK commitVerificationCode:self.verificationCodeTextField.text phoneNumber:self.telTextField.text zone:@"86" result:^(NSError *error) {
        if (error) {
            MYLog(@"验证码不正确");
            [MBProgressHUD showError:@"验证码不正确"];
        }
        else
        {
            MYLog(@"验证码正确");
            /**  验证成功 则自动登录以及保存信息 */
            [self autoRegister];
        }
    }];
}

-(void)autoRegister
{
    RMUserInfo *user = [RMUserInfo sharedRMUserInfo];
    user.registerName = self.telTextField.text;
    /**  密码就是 “RM + 手机号” */
    user.registerPassword = [@"RM" stringByAppendingString:self.telTextField.text];
    user.registerType = YES;
    
    [MBProgressHUD showMessage:@"正在注册，请等待..."];
    __weak typeof(self) VC = self;
    [[RMXMPPTool sharedRMXMPPTool] userRegister:^(RMXMPPResultType type) {
        /**  变为weak 防止循环引用  */
        [VC handleRegisterResult:type];
    }];
}

-(void)handleRegisterResult:(RMXMPPResultType)type
{
    [MBProgressHUD hideHUD];
    switch (type) {
        case RMXMPPResultTypeNetError:
            [MBProgressHUD showError:@"网络错误"];
            MYLog(@"注册网络错误");
            break;
        case RMXMPPResultTypeRegisterFailure:
            [MBProgressHUD showError:@"注册失败"];
            MYLog(@"注册失败");
            break;
        case RMXMPPResultTypeRegisterSuccess:
        {
            /**  注册成功，则保存到沙盒 */
            RMUserInfo *user = [RMUserInfo sharedRMUserInfo];
            user.userName = user.registerName;
            user.userPassword = user.registerPassword;
            user.registerType = NO;
            /**  注册成功过,下次自动登录 */
            user.everRegister = YES;
            [user saveUserInfoToSandbox];
            
            // 向服务器 发起一个web注册 产生web账号
            [[RMWebRegister sharedRMWebRegister] webRegister];
            
#warning TODO：跳转到主界面
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}

@end
