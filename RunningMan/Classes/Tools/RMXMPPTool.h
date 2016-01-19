//
//  RMXMPPTool.h
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Singleton.h"
#import "XMPPFramework.h"

#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"



/** 定义一些枚举代表登录和注册的状态 */
typedef enum
{
    RMXMPPResultTypeLoginSuccess,
    RMXMPPResultTypeLoginFailure,
    RMXMPPResultTypeNetError,
    RMXMPPResultTypeRegisterSuccess,
    RMXMPPResultTypeRegisterFailure,
}RMXMPPResultType;

typedef void(^RMResultBlock)(RMXMPPResultType type);

@interface RMXMPPTool : NSObject
singleton_interface(RMXMPPTool)

#pragma mark - 链接服务器类
/** 负责和服务器经行交互的主要对象 */
@property (nonatomic, strong) XMPPStream *xmppStream;

#pragma mark -用户登录
/** 用户登录 */
- (void) userLogin: (RMResultBlock) block;
/** 用户登出 */
-(void) userLogout;
/** 用户注册 */
- (void) userRegister:(RMResultBlock) block;


#pragma makr - 电子名片
/** 增加电子名片模块 和 头像模块 */
@property (nonatomic, strong) XMPPvCardTempModule *xmppvCard;
@property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvar;
/** 对电子名片模块 和 头像模块进行管理的对象 */
@property (nonatomic, strong) XMPPvCardCoreDataStorage *xmppvCardStore;


#pragma mark - 好友列表
/** 增加好友列表模块 和 对象的存储 */
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStore;

#pragma mark - 聊天消息
@property (nonatomic, strong) XMPPMessageArchiving *xmppMsgArch;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMsgArchStorage;



@end
