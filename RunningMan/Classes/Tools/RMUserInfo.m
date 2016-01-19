//
//  RMUserInfo.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMUserInfo.h"

#define UserKey @"userName"
#define PwdKey @"userPassword"
#define UserEverLogin @"userEverLogin"

@implementation RMUserInfo

singleton_implementation(RMUserInfo)

-(void)saveUserInfoToSandbox{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName forKey:UserKey];
    [defaults setObject:self.userPassword forKey:PwdKey];
    [defaults setBool:self.userEverLogin forKey:UserEverLogin];
    [defaults synchronize];
    
}

-(void)loadUserInfoFromSandbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName = [defaults objectForKey:UserKey];
    self.userPassword = [defaults objectForKey:PwdKey];
    self.userEverLogin = [defaults boolForKey:UserEverLogin];
}

-(NSString *)jidStr{
    return [NSString stringWithFormat:@"%@@%@",self.userName,RMXMPPDOMAIN];
}



@end
