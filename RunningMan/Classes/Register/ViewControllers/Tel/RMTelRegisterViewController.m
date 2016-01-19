//
//  RMTelRegisterViewController.m
//  RunningMan
//
//  Created by tarena01 on 16/1/17.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMTelRegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "MBProgressHUD+KR.h"
#import "RMUserInfo.h"
#import "RMXMPPTool.h"
#import "RMTelRegisterSuccessViewController.h"

@interface RMTelRegisterViewController()
{
    NSArray *_bgImageArray;
    NSInteger index; //更换图片索引
}

@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation RMTelRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.verificationBtn.userInteractionEnabled = NO;
    self.verificationBtn.alpha=0.4;
    
    /** 背景图片动画部分 */
    _bgImageArray = @[ [UIImage imageNamed:@"image1.jpg"],
                       [UIImage imageNamed:@"image2.jpg"],
                       [UIImage imageNamed:@"image3.jpg"],
                       [UIImage imageNamed:@"image4.jpg"],
                       ];
    self.bgImageView.image = _bgImageArray[2];
    /**  定时更换 图片 */
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeBackGroundImage:) userInfo:nil repeats:YES];
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
                    MYLog(@"请求已成功发出");
                    [MBProgressHUD showSuccess:@"请求已成功发出"];
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
    [SMSSDK commitVerificationCode:self.verificationCodeTextField.text phoneNumber:self.telTextField.text zone:@"86" result:^(NSError *error) {
        if (error) {
            MYLog(@"验证码不正确");
            [MBProgressHUD showError:@"验证码不正确"];
        }
        else
        {
            MYLog(@"验证码正确");
            [RMUserInfo sharedRMUserInfo].userName = self.telTextField.text;
            [[RMUserInfo sharedRMUserInfo] saveUserInfoToSandbox];
         [self performSegueWithIdentifier:@"registerOKSegue" sender:nil];
            
        }
    }];
}

/**  跳转 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController * VC = segue.destinationViewController;
    if ([VC isKindOfClass:[RMTelRegisterSuccessViewController class]]) {
        RMTelRegisterSuccessViewController *registerSuccessVc = (RMTelRegisterSuccessViewController*)VC;
    }
}

#pragma mark - 更换背景图
-(void)changeBackGroundImage:(NSTimer*)timer
{
    if (index == _bgImageArray.count -1 ) {
        index = 0;
    }else{
        index++;
    }
    UIImage *image = _bgImageArray[index];
    //    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    //      self.bgImageView.image = _bgImageArray[index];
    //    } completion:nil];
    
    [UIView transitionWithView:self.bgImageView duration:3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.bgImageView.image = image;
    } completion:nil];
    
}

@end
