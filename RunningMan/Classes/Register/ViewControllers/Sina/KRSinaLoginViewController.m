//
//  KRSinaLoginViewController.m
//  CoolRun
//
//  Created by tarena01 on 16/1/10.
//  Copyright © 2016年 qt. All rights reserved.
//
//
#define APPKEY @"2075708624"
#define APPSECRET  @"36a3d3dec55af644cd94a316fdd8bfd8"
#define  REDIRECT_URI @"http://www.tedu.cn"

//#define  APPKEY        @"3562333159"
//#define  REDIRECT_URI  @"http://www.baidu.com"
//#define  APPSECRET     @"d59b60576d9d948bb1ab3ed3f04000c5"

#import "KRSinaLoginViewController.h"
#import "AFNetworking.h"
#import "RMUserInfo.h"
#import "MBProgressHUD+KR.h"
#import "RMXMPPTool.h"
#import "RMWebRegister.h"
#import "NSString+md5.h"

@interface KRSinaLoginViewController()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation KRSinaLoginViewController

/**  返回按钮 */
- (IBAction)comebackButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidLoad
{
    
    self.webView.delegate = self;
    NSString  *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@"
                         ,APPKEY,REDIRECT_URI];
    NSURL  *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString  *urlPath =request.URL.absoluteString;
    MYLog(@"urlPath=%@",urlPath);
    NSRange range = [urlPath rangeOfString:
                     [NSString stringWithFormat:@"%@%@",REDIRECT_URI,@"/?code="]];
    NSString *code = nil;
    if (range.length > 0) {
        code = [urlPath substringFromIndex:range.length];
        MYLog(@"code:%@",code);
        [self accesTokenWithCode:code];
        return NO;
    }
    return YES;
}

/**  2.获取授权 获取授权过的Access Token */
- (void) accesTokenWithCode:(NSString*) code
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager  manager];
    NSString *urlStr = @"https://api.weibo.com/oauth2/access_token";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /*
     必选	类型及范围	说明
     client_id	true	string	申请应用时分配的AppKey。
     client_secret	true	string	申请应用时分配的AppSecret。
     grant_type	true	string	请求的类型，填写authorization_code
     
     grant_type为authorization_code时
     必选	类型及范围	说明
     code	true	string	调用authorize获得的code值。
     redirect_uri	true	string	回调地址，需需与注册应用里的回调地址一致。
     */
    parameters[@"client_id"] = APPKEY;
    parameters[@"client_secret"] = APPSECRET;
    parameters[@"grant_type"] = @"authorization_code";
    parameters[@"code"] = code;
    parameters[@"redirect_uri"] = REDIRECT_URI;
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MYLog(@"获取token成功");
        /* 根据返回数据的uid生成系统内部帐号 之前生成过就使用帐号登录*/
        MYLog(@"%@",responseObject);
        NSString *innerName = [NSString stringWithFormat:@"sina%@",responseObject[@"uid"]];
        [RMUserInfo sharedRMUserInfo].registerName = innerName;
        [RMUserInfo sharedRMUserInfo].registerPassword = responseObject[@"access_token"];
        [RMUserInfo sharedRMUserInfo].registerType = YES;

        /* 成功之后赋值 token */
        [RMUserInfo sharedRMUserInfo].sinaToken = responseObject[@"access_token"];
     
        __weak typeof(self) sinaVc = self;
        [[RMXMPPTool sharedRMXMPPTool] userRegister:^(RMXMPPResultType type) {
            MYLog(@"type:%u",type);
            [sinaVc handleRegisterResultType:type];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MYLog(@"获取token失败");
        [self dismissViewControllerAnimated:self completion:nil];
    }];
}

/** 处理注册的逻辑 */
- (void) handleRegisterResultType:(RMXMPPResultType) type
{
    
    switch (type) {
        case RMXMPPResultTypeRegisterSuccess:
            /** 如果需要web账号也应该注册一个*/
//            [[RMWebRegister sharedRMWebRegister] webRegister];
        case RMXMPPResultTypeRegisterFailure:
        {
            /** 无论注册成功与否都登录 */
            [RMUserInfo sharedRMUserInfo].userName = [RMUserInfo sharedRMUserInfo].registerName;
            [RMUserInfo sharedRMUserInfo].userPassword = [RMUserInfo sharedRMUserInfo].registerPassword;
            [RMUserInfo sharedRMUserInfo].registerType = NO;
            [[RMXMPPTool sharedRMXMPPTool]userLogin:^(RMXMPPResultType type) {
                [self handleLoginResultType:type];
            }];
            break;
        }
        case  RMXMPPResultTypeNetError:
            MYLog(@"sina register net error");
            break;
        default:
            break;
    }
}
/** 处理登录的返回 */
- (void) handleLoginResultType:(RMXMPPResultType) type
{
       MYLog(@"type:%u",type);
    switch (type) {
        case RMXMPPResultTypeLoginSuccess:
        {
            [RMUserInfo sharedRMUserInfo].sinaLogin = YES;
            UIStoryboard *stroyborad =
            [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = stroyborad.instantiateInitialViewController;
            break;
        }
        case RMXMPPResultTypeLoginFailure:
            [MBProgressHUD showError:@"登录失败"];
            break;
        case RMXMPPResultTypeNetError:
            [MBProgressHUD showError:@"网络错误"];
            break;
        default:
            break;
    }
}

@end
