//
//  RMUserInfo.h
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


@interface RMUserInfo : NSObject
singleton_interface(RMUserInfo)

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userPassword;
@property (nonatomic, assign, getter=isRegisterType) BOOL registerType;


/** 用户注册信息 */
@property (nonatomic, copy) NSString *registerName;
@property (nonatomic, copy) NSString *registerPassword;
/** 获取用户对应的 jidStr */
@property (nonatomic, strong) NSString *jidStr;

/**  判断是否是注册成功过，是则从沙盒取密码，不用输密码 */
@property (nonatomic,assign,getter=isEverRegister) BOOL everRegister;


/** 新浪登陆 */
@property (nonatomic, copy) NSString *sinaToken;
@property (nonatomic, assign,getter=isSinaLogin) BOOL sinaLogin;

/** 判断用户是否已登录 */
@property (nonatomic, assign,getter=isOnLine) BOOL OnLine;

/**  登录的状态 YES 登录过/NO 注销 */
@property (nonatomic, assign) BOOL  loginStatus;

/**  从沙盒里获取用户数据  登录时使用 */
-(void)loadUserInfoFromSandbox;

/**   保存用户数据到沙盒  用户登录成功时和登出时使用 */
-(void)saveUserInfoToSandbox;


@end
