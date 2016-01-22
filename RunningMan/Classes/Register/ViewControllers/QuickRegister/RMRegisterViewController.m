//
//  RMRegisterViewController.m
//  RunningMan
//
//  Created by tarena01 on 16/1/21.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMRegisterViewController.h"
#import "MBProgressHUD+KR.h"
#import "RMUserInfo.h"
#import "RMXMPPTool.h"
#import "RMWebRegister.h"
#import "AppDelegate.h"

@interface RMRegisterViewController ()
{
    NSArray *_bgImageArray;
    NSInteger index; //更换图片索引
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation RMRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerButton.userInteractionEnabled = NO;
    self.registerButton.alpha = 0.5;
    
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
- (IBAction)comeBackButonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma  mark - 密码有输入
- (IBAction)userNameTextField:(id)sender {
    [self passwordTextFieldEditingDidChange:nil];
}
- (IBAction)passwordTextFieldEditingDidChange:(id)sender {
    
    if (self.userNameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
    }
    self.registerButton.userInteractionEnabled = NO;
    self.registerButton.alpha = 0.3;
    
    if (self.userPasswordTextField.text.length >= 6 &&
        self.userNameTextField.text.length != 0) {
        
        self.registerButton.userInteractionEnabled = YES;
        self.registerButton.alpha = 1.0;
        self.registerButton.layer.cornerRadius = 8;
        self.registerButton.layer.borderWidth = 3;
        self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.registerButton setBackgroundColor:[UIColor whiteColor]];
    }
    
 
}

- (IBAction)registerButtonClick:(id)sender {
    if (self.userNameTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    
    if (self.userPasswordTextField.text.length < 6) {
        [MBProgressHUD showError:@"密码至少6位"];
        return;
    }
    
    RMUserInfo* user = [RMUserInfo sharedRMUserInfo];
    user.registerName = self.userNameTextField.text;
    user.registerPassword = self.userPasswordTextField.text;
    user.registerType = YES;
    
    // 向服务器 发起一个web注册 产生web账号
    [[RMWebRegister sharedRMWebRegister] webRegister];
    
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
    [NSThread sleepForTimeInterval:1.0];
    
    /**  保存信息 */
    RMUserInfo* user = [RMUserInfo sharedRMUserInfo];
    user.userName = self.userNameTextField.text;
    user.userPassword = self.userPasswordTextField.text;
    user.registerType = NO;
    [user saveUserInfoToSandbox];

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
            MYLog(@"注册网路错误");
            //注册失败 网络错误都跳到Login那里
        case RMXMPPResultTypeLoginFailure:
        {
            [MBProgressHUD showError:@"登录失败"];
            MYLog(@"注册登录失败");
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            break;
        }
        case RMXMPPResultTypeLoginSuccess:
        {
             MYLog(@"注册登录成功");
            [RMUserInfo sharedRMUserInfo].userEverLogin = YES;
            [[RMUserInfo sharedRMUserInfo] saveUserInfoToSandbox];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            [app setupNavigationController];
            break;
        }
        default:
            break;
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
   
    [UIView transitionWithView:self.bgImageView duration:3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.bgImageView.image = image;
    } completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
