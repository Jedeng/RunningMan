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

@interface AppDelegate ()<BMKGeneralDelegate>
@property (nonatomic, strong) MMDrawerController *drawerController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    /** This is a test */
    
    _isNotFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirst"];
    
    if (_isNotFirst)
    {
        /** 暂时不会进入 */
        [self setupNavigationController];
    }
    else
    {
        /** 注释下面代码并 添加启动页面 */
        [self setupNavigationController];
    }
    
    /** 统一导航栏风格 */
    [self setThem];
    
    /** 地图验证 */
    _manager = [[BMKMapManager alloc]init];
    [_manager start:@"2mzXGZnNcV98dd8Mg4pNslRr" generalDelegate:self];
    
    return YES;
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

/** 统一导航栏风格 */
- (void) setThem
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"矩形"] forBarMetrics:UIBarMetricsDefault];
    bar.barStyle = UIBarStyleBlack;
    bar.tintColor = [UIColor whiteColor];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
