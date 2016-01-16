//
//  RMUserInfo.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMUserInfo.h"

#define UserKey @"userName"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"userPassword"
#define EverRegister @"everRegister"

@implementation RMUserInfo

singleton_implementation(RMUserInfo)

-(void)saveUserInfoToSandbox{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.userName forKey:UserKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults setObject:self.userPassword forKey:PwdKey];
    [defaults setBool:self.everRegister  forKey:EverRegister];
    [defaults synchronize];
    
}

-(void)loadUserInfoFromSandbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userName = [defaults objectForKey:UserKey];
    self.loginStatus = [defaults boolForKey:LoginStatusKey];
    self.userPassword = [defaults objectForKey:PwdKey];
    self.everRegister = [defaults boolForKey:EverRegister];
}


-(NSString *)jidStr{
    return [NSString stringWithFormat:@"%@@%@",self.userName,RMXMPPDOMAIN];
}



@end
