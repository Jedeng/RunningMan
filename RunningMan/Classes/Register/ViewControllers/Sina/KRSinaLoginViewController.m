//
//  KRSinaLoginViewController.m
//  CoolRun
//
//  Created by tarena01 on 16/1/10.
//  Copyright © 2016年 qt. All rights reserved.
//

#define APPKEY @"3562333159"
#define APPSECRET  @"d59b60576d9d948bb1ab3ed3f04000c5"
#define  REDIRECT_URI @"http://www.baidu.com"

#import "KRSinaLoginViewController.h"
#import "AFNetworking.h"
#import "RMUserInfo.h"
#import "MBProgressHUD+KR.h"
#import "RMXMPPTool.h"

@interface KRSinaLoginViewController()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation KRSinaLoginViewController

/**  返回按钮 */
- (IBAction)comebackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    /**  1.请求授权 请求用户授权Token */
    NSString *urlPath = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",APPKEY,REDIRECT_URI];
    NSURL *url = [NSURL URLWithString:urlPath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.delegate = self;
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlPath = request.URL.absoluteString;
    MYLog(@"urlPath:%@",urlPath);
    NSRange range = [urlPath rangeOfString:[NSString stringWithFormat:@"%@%@",REDIRECT_URI,@"?code="]];
    NSString *code = nil;
    if (range.length > 0) {
        code = [urlPath substringToIndex:range.location];
        MYLog(@"code:%@",code);
        [self accessTokenWithCode:code];
    }
    return NO;
}
/**  2.获取授权 获取授权过的Access Token */
-(void)accessTokenWithCode:(NSString*)code
{
    /**
     请求部分：
     URL
     https://api.weibo.com/oauth2/access_token
     HTTP请求方式
     POST
     请求参数
     必选	类型及范围	说明
     client_id	true	string	申请应用时分配的AppKey。
     client_secret	true	string	申请应用时分配的AppSecret。
     grant_type	true	string	请求的类型，填写authorization_code
     grant_type为authorization_code时:
     必选	类型及范围	说明
     code	true	string	调用authorize获得的code值。
     redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
     */
    /**  响应部分：
     返回数据
     {
     "access_token": "ACCESS_TOKEN",
     "expires_in": 1234,
     "remind_in":"798114",
     "uid":"12341234"
     }
     返回值字段	字段类型	字段说明
     access_token	string	用于调用access_token，接口获取授权后的access token。
     expires_in	string	access_token的生命周期，单位是秒数。
     remind_in	string	access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
     uid	string	当前授权用户的UID。
     */
    /**  创建Manager，设置请求参数，发送post请求 */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = @" https://api.weibo.com/oauth2/access_token";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"client_id"]       = APPKEY;
    parameters[@"client_secret"] = APPSECRET;
    parameters[@"grant_type"]    = @"authorization_code";
    parameters[@"code"]             = code;
    parameters[@"redirect_uri"]  = REDIRECT_URI;
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MYLog(@"获取token成功,responseObject:%@",responseObject);
        /* 根据返回数据的uid生成系统内部帐号 之前生成过就使用帐号登录*/
        NSString *innerName = [NSString stringWithFormat:@"sina%@",responseObject[@"uid"]];
        [RMUserInfo sharedRMUserInfo].userName = innerName;
        [RMUserInfo sharedRMUserInfo].userPassword = responseObject[@"access_token"];
        [RMUserInfo sharedRMUserInfo].registerName = innerName;
        [RMUserInfo sharedRMUserInfo].registerPassword = responseObject[@"access_token"];
        [RMUserInfo sharedRMUserInfo].sinaToken = responseObject[@"access_token"];
        [RMUserInfo sharedRMUserInfo].registerType = YES;
        
        __weak typeof(self) sinaVC = self;
        [[RMXMPPTool sharedRMXMPPTool] userRegister:^(RMXMPPResultType type) {
            [sinaVC handleRegisterResult:type];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"微博登录失败"];
        MYLog(@"sinaLogin error:%@",error);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}
/**  3.处理注册结果 */
-(void)handleRegisterResult:(RMXMPPResultType)type
{
    [RMUserInfo sharedRMUserInfo].registerType = NO;
    /**  无论是注册成功还是失败都直接登录 */
    [[RMXMPPTool sharedRMXMPPTool] userLogin:^(RMXMPPResultType type) {
        [self handleLoginResult:type];
    }];
}
/**  4。处理登录结果 注册成功则跳转 */
-(void)handleLoginResult:(RMXMPPResultType)type
{
    switch (type) {
        case RMXMPPResultTypeNetError:
            [MBProgressHUD   showError:@"网路错误"];
            break;
        case RMXMPPResultTypeLoginFailure:
            [MBProgressHUD showError:@"登录失败"];
            break;
        case RMXMPPResultTypeLoginSuccess:
        {
            
            [RMUserInfo sharedRMUserInfo].sinaLogin = YES;
            [RMUserInfo sharedRMUserInfo].userEverLogin = YES;
            [MBProgressHUD showSuccess:@"登录成功"];
            [[RMUserInfo sharedRMUserInfo] saveUserInfoToSandbox];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
            break;
        }
        default:
            break;
    }
    
}


@end
