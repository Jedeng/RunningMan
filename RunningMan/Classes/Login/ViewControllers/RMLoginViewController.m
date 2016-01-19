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
#import <TencentOpenAPI/TencentOAuth.h>

@interface RMLoginViewController ()<TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSArray *_permissions;
    NSArray *_bgImageArray;
    NSInteger index; //更换图片索引
}
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;


- (IBAction)loginButtonClick:(id)sender;
- (IBAction)forgetPasswordButtonClick:(id)sender;
- (IBAction)registerButtonClick:(id)sender;



@end

@implementation RMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**  1.初始化 tecentOAuth 对象 */
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1105056612" andDelegate:self];
    
    /**  2.设置需要的权限列表，此处使用什么就写什么 */
    _permissions = [NSArray arrayWithObjects:@"get_user_info",@"list_album",@"get_vip_info",@"get_info",nil];
    
    /** 背景图片动画部分 */
    _bgImageArray = @[[UIImage imageNamed:@"image1.jpg"],
                                  [UIImage imageNamed:@"image2.jpg"],
                                  [UIImage imageNamed:@"image3.jpg"],
                                  [UIImage imageNamed:@"image4.jpg"],];
    self.bgImageView.image = _bgImageArray[2];
    /**  定时更换 图片 */
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeBackGroundImage:) userInfo:nil repeats:YES];
    /**  如果登录过则记住密码 */
    if ([RMUserInfo sharedRMUserInfo].isUerEverLogin) {
        self.userNameTextField.text = [RMUserInfo sharedRMUserInfo].userName;
        self.userPasswordTextField.text = [RMUserInfo sharedRMUserInfo].userPassword;
    }

    
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
    
    [MBProgressHUD showMessage:@"正在登录..."];
    
    RMUserInfo *userInfo = [RMUserInfo sharedRMUserInfo];
    userInfo.userName = self.userNameTextField.text;
    userInfo.userPassword = self.userPasswordTextField.text;
    userInfo.registerType = NO;
    userInfo.userEverLogin = YES;
    
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


#pragma mark - QQ Login
- (IBAction)QQlogionBtn:(id)sender
{
    [_tencentOAuth authorize:_permissions inSafari:NO];
}
- (void)tencentDidLogin
{
    [MBProgressHUD showSuccess:@"登录成功!"];
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        /** 记录用户的 OpenID,Token 以及过期时间 */
        [_tencentOAuth getUserInfo];
        MYLog(@"%@",_tencentOAuth.accessToken);
    }
    else
    {
        [MBProgressHUD showError:@"登录不成功,没有获取 accesstoken"];
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        MYLog(@"用户取消登录");
    }else{
        MYLog(@"登录失败");
    }
}

/** 网络错误导致登录失败 */
- (void)tencentDidNotNetWork
{
    NSLog(@"%s",__func__);
    
    MYLog(@"网络连接失败,请检测网络设置");
}



- (void)getUserInfoResponse:(APIResponse *)response
{
    MYLog(@"response: %@",response.jsonResponse);
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


@end
