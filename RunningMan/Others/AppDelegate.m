//
//  AppDelegate.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "RMMyProfilesVC.h"
#import "MMDrawerController.h"  /** 侧滑三方 */
#import "RMUserInfo.h"

#import "RMXMPPTool.h"

/**  qq登录 */
#import <TencentOpenAPI/TencentOAuth.h>

/**  手机短信验证注册 */
#import <SMS_SDK/SMSSDK.h>
#define appKey    @"e8a9b25abf88"
#define appSecret @"d5fc7fd3604b73c27f3156be12d7525b"


@interface AppDelegate () <BMKGeneralDelegate>

@property (nonatomic, strong) MMDrawerController *drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册应用接收通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert|
                                                                                                                                         UIUserNotificationTypeBadge|
                                                                                                                                         UIUserNotificationTypeSound
                                                                                                                       categories: nil];
        [application registerUserNotificationSettings:settings];
    }
    /**  注册应用 */
    [SMSSDK registerApp:appKey withSecret:appSecret];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"userEverLogin"])
    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        self.window.rootViewController = storyboard.instantiateInitialViewController;
//        [self setupNavigationController];
    }
    else
    {
        [[RMUserInfo sharedRMUserInfo] loadUserInfoFromSandbox];
        __weak typeof(self) loginVC = self;
        [[RMXMPPTool sharedRMXMPPTool] userLogin:^(RMXMPPResultType type) {
            [loginVC handleLoginResult:type];
        }];
    }
    /** 统一导航栏风格 */
    [self setThem];
    
    /** 地图验证 */
    _manager = [[BMKMapManager alloc]init];
    BOOL isSucces = [_manager start:@"IYG515yBgoVRmatEjzp0Rd7l" generalDelegate:self];
    if (isSucces)
    {
        MYLog(@"百度地图验证成功!");
    }
    return YES;
}

-(void)handleLoginResult:(RMXMPPResultType)type
{
    switch (type) {
        case RMXMPPResultTypeLoginSuccess:
            [self setupNavigationController];
            break;
        case RMXMPPResultTypeLoginFailure:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
            self.window.rootViewController = storyboard.instantiateInitialViewController;
            break;
        }
        default:
            break;
    }
    
}

- (void) setThem
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"矩形"] forBarMetrics:UIBarMetricsDefault];
    bar.barStyle = UIBarStyleBlack;
    bar.tintColor = [UIColor purpleColor];
}

- (void)setupNavigationController
{
    /** 主视图实例对象 */
    UIStoryboard *MainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mainVC = [MainSB instantiateInitialViewController];
    
    /** 左边视图实例对象 */
    UIStoryboard *myPofileSB = [UIStoryboard storyboardWithName:@"MyPofiles" bundle:nil];
    RMMyProfilesVC *leftVC = [myPofileSB instantiateInitialViewController];
    
    /** 使用抽屉第三方框架绑定视图控制器 */
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:mainVC leftDrawerViewController:leftVC];
    [self.drawerController setShowsShadow:NO];
    
    /** 设置滑动边距大小 */
    self.drawerController.maximumLeftDrawerWidth = 280;
    self.drawerController.statusBarViewBackgroundColor = [UIColor redColor];
    
    /** 设置抽屉模式打开和关闭的手势监听模式 */
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    
    _window.rootViewController = _drawerController;
}

#pragma mark - QQ登录注册
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [TencentOAuth HandleOpenURL:url];
}

@end

