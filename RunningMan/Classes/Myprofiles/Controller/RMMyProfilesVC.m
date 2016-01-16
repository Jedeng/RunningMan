//
//  MyProfilesVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMMyProfilesVC.h"
#import "RMUserInfo.h"
#import "RMXMPPTool.h"
#import "XMPPvCardTemp.h"
#import "UIImageView+RMRoundImageView.h"
//#import "<#header#>"


@interface RMMyProfilesVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;

@end

@implementation RMMyProfilesVC
//
///** 显示个人信息 */
//- (void)viewWillAppear:(BOOL)animated
//{
//    XMPPvCardTemp *vCardTemp = [RMXMPPTool sharedRMXMPPTool] .xmppvCard.myvCardTemp;
//    self.userNameLabel.text = [RMUserInfo sharedRMUserInfo].userNmae;
//    self.nikeNameLabel.text = vCardTemp.nickname;
//    
//    if (vCardTemp.photo)
//    {
//        self.headerImageView.image = [UIImage imageWithData:vCardTemp.photo];
//    }
//    else
//    {
//        self.headerImageView.image = [UIImage imageNamed:@"icon"];
//        /** 如果用户没有头像,将本地的 icon 作为该用户的头像并储存 */
//        vCardTemp.photo = UIImagePNGRepresentation(self.headerImageView.image);
//    }
//    [self.headerImageView setRoundLayer];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutBtn:(id)sender
{
    [[RMUserInfo sharedRMUserInfo] saveUserInfoToSandbox];
    [[RMXMPPTool sharedRMXMPPTool] sedOffLine];
    [RMUserInfo sharedRMUserInfo].jidStr = nil;
    
    if ([RMUserInfo sharedRMUserInfo].sinaLogin)
    {
        [RMUserInfo sharedRMUserInfo].sinaLogin = NO;
        [RMUserInfo sharedRMUserInfo].userName = nil;
    }
    
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainSB instantiateInitialViewController];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}




@end