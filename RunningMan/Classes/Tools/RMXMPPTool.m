//
//  RMXMPPTool.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMXMPPTool.h"
#import "RMUserInfo.h"

/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */

@interface RMXMPPTool () <XMPPStreamDelegate,XMPPRosterDelegate>
{
    RMResultBlock  _resultBlock;
//    XMPPReconnect *_reconnect;// 自动连接模块
}

/** 好友请求的用户的 Jid */
@property (nonatomic, strong) XMPPJID *fJid;

/** 设置 XMPP 流  */
- (void) setXmpp;

/** 链接服务器 */
- (void) connectHost;

/** 授权成功后,发送密码 */
- (void) sendPasswordToHost;

/** 连接成功 发送在线消息 */
- (void) sendOnLine;

/** 退出登录,发送离线消息 */
- (void) sendOffLine;

/** 清理资源 */
- (void) teardownXmpp;

@end

@implementation RMXMPPTool

singleton_implementation(RMXMPPTool)

#pragma mark - 私有方法
#pragma  mark - 初始化XMPP
- (void) setXmpp
{
    _xmppStream = [[XMPPStream alloc]init];
    /** 设置代理 */
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //自动连接模块
//    _reconnect = [[XMPPReconnect alloc] init];
//    [_reconnect activate:_xmppStream];
    
    /** 给电子名片模块和头像模块赋值 */
    self.xmppvCardStore = [XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:self.xmppvCardStore];
    self.xmppvCardAvar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.xmppvCard];
    
    /** 激活电子名片模块 和 头像模块 */
    [self.xmppvCard activate:self.xmppStream];
    [self.xmppvCardAvar activate:self.xmppStream];
    
    /**给好友列表和存储对象赋值*/
    self.xmppRosterStore = [XMPPRosterCoreDataStorage sharedInstance];
    self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:self.xmppRosterStore];
    /** 激活好友列表 */
    [self.xmppRoster activate:self.xmppStream];
    
    /**  初始化消息模块 */
    self.xmppMsgArchStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.xmppMsgArch = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:self.xmppMsgArchStorage];
    /**  激活消息模块 */
    [self.xmppMsgArch activate:self.xmppStream];
}

/** 连接到服务器 */
- (void) connectHost
{
    if (!self.xmppStream) {
        [self setXmpp];
    }
    /** 给xmppStream 做一些属性的赋值 */
    self.xmppStream.hostName = RMXMPPDOMAIN;
    self.xmppStream.hostPort = RMXMPPPOST;
    /** 构建一个jid 根据登录名还是注册名 */
    NSString *uname = nil;
    if ([RMUserInfo sharedRMUserInfo].isRegisterType) {
        /**  注册 */
        uname = [RMUserInfo sharedRMUserInfo].registerName;
    }else{
        /**  登录 */
        uname = [RMUserInfo sharedRMUserInfo].userName;
    }
    
    XMPPJID  *myJid = [XMPPJID jidWithUser:uname domain:RMXMPPDOMAIN resource:@"iphone"];
    self.xmppStream.myJID = myJid;
    
    /** 连接服务器 */
    NSError  *error = nil;
    [self.xmppStream  connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        MYLog(@"xmpp Stream connect error：%@",error);
    }
}

/** 连接成功 发送密码 */
- (void) sendPasswordToHost
{
    NSString *pwd = nil;
    NSError  *error = nil;
    if ([RMUserInfo sharedRMUserInfo].isRegisterType) {
        pwd = [RMUserInfo sharedRMUserInfo].registerPassword;
        /** 用密码进行注册 */
        [self.xmppStream registerWithPassword:pwd error:&error];
    }else{
        pwd = [RMUserInfo sharedRMUserInfo].userPassword;
        /** 用密码进行授权 */
        [self.xmppStream authenticateWithPassword:pwd error:&error];
    }
    if (error) {
        MYLog(@"xmpp Stream send password error:%@",error);
    }
}
/** 授权成功之后 发送在线消息 */
- (void) sendOnLine
{
    /** 默认代表在线 */
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
      MYLog(@"登录成功");
}

/** 退出登录,发送离线消息 */
- (void) sendOffLine
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

#pragma mark - 释放xmppStream相关的资源
-(void)teardownXmpp{
    
    // 移除代理
    [_xmppStream removeDelegate:self];
    
    // 停止模块
//    [_reconnect deactivate]; //自动连接
    [_xmppvCard deactivate];
    [_xmppvCardAvar deactivate];
    [_xmppRoster deactivate];
    [_xmppMsgArch deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
//    _reconnect = nil;
    _xmppvCard = nil;
    _xmppvCardStore = nil;
    _xmppvCardAvar = nil;
    _xmppRoster = nil;
    _xmppRosterStore = nil;
    _xmppMsgArch = nil;
    _xmppMsgArchStorage = nil;
    _xmppStream = nil;
}

#pragma mark - XMPPStream Delegate
/** 连接服务器成功 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    MYLog(@"连接服务器成功");
    /** 连接成功则发送密码 */
    [self sendPasswordToHost];
}
/** 连接服务器失败 */
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if (error && _resultBlock) {
        _resultBlock(RMXMPPResultTypeNetError);
        MYLog(@"连接服务器失败:%@",error);
    }
}

/** 注册成功 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
   
    if (_resultBlock) {
        _resultBlock(RMXMPPResultTypeRegisterSuccess);
         MYLog(@"注册成功");
    }
}
/** 注册失败 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    if (_resultBlock && error) {
        MYLog(@"XMPPStream 注册失败：%@",error);
        _resultBlock(RMXMPPResultTypeRegisterFailure);
    }
}

/** 授权成功的方法 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    _resultBlock(RMXMPPResultTypeLoginSuccess);
    MYLog(@"授权成功");
    /** 授权成功则 发送在线消息 */
    [self sendOnLine];
}
/** 授权失败的方法 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if (error && _resultBlock) {
         MYLog(@"授权失败:%@",error);
        _resultBlock(RMXMPPResultTypeLoginFailure);
    }
}

#pragma mark - 后台接收到好友消息 推送
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    MYLog(@"后台接收到好友消息:%@",message);
    
    //如果当前程序不在前台，发出一个本地通知
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive){
        MYLog(@"在后台");
        
        //本地通知
        UILocalNotification *localNoti = [[UILocalNotification alloc] init];
        
        // 设置内容
        localNoti.alertBody = [NSString stringWithFormat:@"%@\n%@",message.fromStr,message.body];
        
        // 设置通知执行时间
        localNoti.fireDate = [NSDate date];
        
        //声音
        localNoti.soundName = @"default";
        
        //执行
        [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
        
        //{"aps":{'alert':"zhangsan\n have dinner":'sound':'default',badge:'12'}}
    }
}

//-(void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
//    //XMPPPresence 在线 离线
//    
//    //presence.from 消息是谁发送过来
//}

-(void)dealloc{
//    [self teardownXmpp];
}

#pragma  mark - 公用方法
#pragma  mark - 用户登录方法
- (void) userLogin: (RMResultBlock) block
{
    _resultBlock = block;
    [self.xmppStream disconnect];
    [self connectHost];
}

#pragma  mark - 用户注册方法
/** 用户注册调用的方法 要得到注册的状态 传入一个block 即可 */
- (void) userRegister:(RMResultBlock) block
{
    _resultBlock = block;
    /** 无论之前 xmppStream 有没有连接 都直接断开上一次连接 */
    [self.xmppStream disconnect];
    [self connectHost];
}

#warning  用户退出登录
-(void) userLogout{
    // 1." 发送 "离线" 消息"
    [self sendOffLine];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    [RMUserInfo sharedRMUserInfo].jidStr = nil;
    if ([RMUserInfo sharedRMUserInfo].sinaLogin)
    {
        [RMUserInfo sharedRMUserInfo].sinaLogin = NO;
        [RMUserInfo sharedRMUserInfo].userName = nil;
    }
    
    //3.更新用户的登录状态
    [[RMUserInfo sharedRMUserInfo] saveUserInfoToSandbox];
    
}

//处理加好友
#pragma mark 处理加好友回调,加好友

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]];
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    
    MYLog(@"-----presenceType:%@",presenceType);
    MYLog(@"-----presence2:%@  sender2:%@",presence,sender);
    MYLog(@"-----fromUser:%@",presenceFromUser);
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",presenceFromUser,RMXMPPDOMAIN];
    XMPPJID *jid     = [XMPPJID jidWithString:jidStr];
    self.fJid              = jid;
    NSString *title    = [NSString stringWithFormat:@"%@想申请加好友",jidStr];
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle: title
                                                                                        delegate: self
                                                                         cancelButtonTitle: @"取消"
                                                                  destructiveButtonTitle: @"同意"
                                                                         otherButtonTitles: @"同意并添加对方为好友", nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]];
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];

    MYLog(@"-----presenceType:%@",presenceType);
    MYLog(@"-----presence2:%@  sender2:%@",presence,sender);
    MYLog(@"-----fromUser:%@",presenceFromUser);
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",presenceFromUser,RMXMPPDOMAIN];
    XMPPJID *jid     = [XMPPJID jidWithString:jidStr];
    self.fJid              = jid;
    UIActionSheet *actionSheet =[[UIActionSheet alloc]initWithTitle: [NSString stringWithFormat:@"%@想申请加好友",jidStr]
                                                                                        delegate: self
                                                                         cancelButtonTitle: @"取消"
                                                                  destructiveButtonTitle: @"同意"
                                                                          otherButtonTitles: @"同意并添加对方为好友", nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MYLog(@"index====%ld",buttonIndex);
    if (0 == buttonIndex)
    {
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:self.fJid andAddToRoster:NO];
    }
    else if(1== buttonIndex)
    {
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:self.fJid andAddToRoster:YES];
    }
    else
    {
        [self.xmppRoster  rejectPresenceSubscriptionRequestFrom:self.fJid];
    }
}

@end
