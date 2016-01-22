//
//  RMMyMsgViewController.m
//  RMRunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/8.
//  Copyright © 2016年 RM. All rights reserved.
//

#import "RMMyMsgViewController.h"
#import "RMFriendTableVC.h"
#import "RMUserInfo.h"
#import "RMXMPPTool.h"
#import "UIImageView+RMRoundImageView.h"
#import "XMPPMessageArchiving.h"
#import "RMLastMsgTableViewCell.h"
//#import "RMChatViewController.h"

@interface RMMyMsgViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray  *friends;
@property (nonatomic,strong) NSArray  *friendNames;
@property (nonatomic,strong) NSArray  *lastMsgs;
@end

@implementation RMMyMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* 加载哪些人聊过 */
    [self loadMostMessage];
    
    
}
- (void) loadMostMessage
{
    NSManagedObjectContext *context = [[RMXMPPTool sharedRMXMPPTool].xmppMsgArchStorage mainThreadManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",[RMUserInfo sharedRMUserInfo].jidStr];
    request.predicate = pre;
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:NO];
    request.sortDescriptors = @[desc];
    NSError *error = nil;
    self.lastMsgs = [context executeFetchRequest:request error:&error];
    if (error)
    {
        MYLog(@"%@",error);
    }
}

/** 查询最后的信息 */
- (XMPPMessageArchiving_Message_CoreDataObject *) findLastMessage:(NSString*) bareJidStr
{
    for (int i=0; i<self.friends.count; i++) {
        XMPPMessageArchiving_Message_CoreDataObject *ma = self.friends[i];
        if ([ma.bareJidStr isEqualToString:bareJidStr]) {
            return ma;
        }
    }
    return nil;
}
#pragma mark -
- (IBAction)returnButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lastMsgs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RMLastMsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myMsgCell"];
    XMPPMessageArchiving_Contact_CoreDataObject *msg = self.lastMsgs[indexPath.row];
    cell.nikeNameLabel.text = msg.bareJidStr;
    /** 根据信息显示头像 */
    NSData *imageData = [[RMXMPPTool sharedRMXMPPTool].xmppvCardAvar photoDataForJID:[XMPPJID jidWithString:msg.bareJidStr]];
    [cell.headerImage setRoundLayer];
    if (imageData)
    {
        cell.headerImage.image = [UIImage imageWithData:imageData];
    }
    else
    {
        cell.headerImage.image = [UIImage imageNamed:@"人人"];
    }
    
    if ([msg.mostRecentMessageBody hasPrefix:@"image"])
    {
        cell.lastMsgLabel.text = @"图片";
    }
    else
    {
        NSString *base64Str = [msg.mostRecentMessageBody substringFromIndex:4];
        NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
        cell.lastMsgLabel.text = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd";
    cell.timeLabel.text = [format stringFromDate:msg.mostRecentMessageTimestamp];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
