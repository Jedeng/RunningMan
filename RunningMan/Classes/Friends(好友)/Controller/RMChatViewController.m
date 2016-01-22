//
//  RMChatViewController.m
//  RunningMan
//
//  Created by tarena on 16/1/21.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMChatViewController.h"
#import "RMXMPPTool.h"
#import "RMUserInfo.h"
#import "RMTextTableViewCell.h"
#import "RMOtherTableViewCell.h"
#import "XMPPMessage.h"
#import "XMPPvCardTemp.h"
#import "UIImageView+RMRoundImageView.h"
//#import "XMPPJID.h"
@interface RMChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  设置三个聊天的相关属性 1.tableView
 *                     2.输入的要发送的消息
 *                     3.设置键盘开启关闭时的tableView的高度约束（公开）
 */
@property (weak, nonatomic) IBOutlet UITextField *sentMessageTextFeild;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSFetchedResultsController  *fetechCol;
@property (strong,nonatomic) UIImage *meImage;
@property (strong,nonatomic) UIImage *friendImage;
@end

@implementation RMChatViewController

/** 两个方法，发送图片和消息  */

- (IBAction)sendImage:(id)sender {
    UIImagePickerController *picVc = [[UIImagePickerController alloc]init];
    picVc.delegate = self;
    picVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picVc animated:YES completion:nil];

    
}

/* UIImagePickerController 代理方法 */

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *newImage = [self thumbnailWithImage:image size:CGSizeMake(100, 100)];
    NSData  *data = UIImageJPEGRepresentation(image, 0.05);
    
    MYLog(@"---------%ld",data.length);
    NSData  *data2 = UIImageJPEGRepresentation(newImage,0.05);
    MYLog(@"---------%ld",data2.length);
    
    [self sendMessageWithData:data2 bodyName:@"image"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }else{
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;

}

/** 发送(文本 图片或者声音) */
- (void)sendMessageWithData:(NSData *)data bodyName:(NSString *)name
{
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.friendJid ];
    // 转换成base64的编码
    NSString *base64str = [data base64EncodedStringWithOptions:0];
    [message addBody:[name stringByAppendingString:base64str]];
    // 发送消息
    [[RMXMPPTool sharedRMXMPPTool].xmppStream sendElement:message];
}
/** 发送文本信息  */
- (IBAction)sendText:(id)sender {
    NSString *msg = self.sentMessageTextFeild.text;
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self sendMessageWithData:data bodyName:@"text"];
    [self.tableView reloadData];
}

/** 视图即将显示，注册键盘相关的通知  */
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[self.tabBarController hidesBottomBarWhenPushed];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    self.tableView.rowHeight = 120.0f;
    /* 适应自动布局 */
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 80.0;

}

/** 键盘显示时  */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self scrollTabel];
}
-(void)scrollTabel{
    NSInteger  index = self.fetechCol.fetchedObjects.count -1;
    if (index < 0) {
        return;
    }
    NSIndexPath  *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    /* 适应自动布局 */
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80.0;
    [self loadMsg];
    NSData *data = [RMXMPPTool sharedRMXMPPTool].xmppvCard.myvCardTemp.photo;
    if (data == nil) {
        self.meImage = [UIImage imageNamed:@"headImage"];
    }else{
        self.meImage = [UIImage imageWithData:data];
    }
    NSData *fdata = [[RMXMPPTool sharedRMXMPPTool].xmppvCardAvar photoDataForJID:self.friendJid];
    if (fdata == nil) {
        self.friendImage = [UIImage imageNamed:@"headImage"];
    }else{
        self.friendImage = [UIImage imageWithData:fdata];
    }
}
/** 加载消息  */
- (void) loadMsg
{
    // 获得上下文
    NSManagedObjectContext *context = [[RMXMPPTool sharedRMXMPPTool].xmppMsgArchStorage mainThreadManagedObjectContext];
    // 请求对象关联实体
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 请求对象设置过滤条件 和 排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:
                        @"bareJidStr=%@ and streamBareJidStr=%@",
                        [self.friendJid bare],[RMUserInfo sharedRMUserInfo].jidStr];
    
    request.predicate = pre;
    NSSortDescriptor *sortdes = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sortdes];
    // 提取数据
    self.fetechCol = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetechCol.delegate = self;
    NSError *error = nil;
    [self.fetechCol performFetch:&error];
    if (error) {
        MYLog(@"提取数据失败");
    }
}
/** 移除通知  */

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma marek -- 键盘监听的方法
/** 键盘打开 */
- (void) openKeyboard:(NSNotification *)notification{
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    self.heightForBottom.constant = keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self scrollTabel];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
/** 键盘关闭 */
- (void) closeKeyboard:(NSNotification *)notification{
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    self.heightForBottom.constant = 0;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark -tableview代理方法
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetechCol.fetchedObjects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XMPPMessageArchiving_Message_CoreDataObject *message = self.fetechCol.fetchedObjects[indexPath.row];
    
    if ([message.body hasPrefix:@"text"]) {
        if (message.isOutgoing) {
            RMTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meTextCell"];
            cell.headImageView.image = self.meImage;
            [cell.headImageView setRoundLayer];
            NSString *base64Str = [message.body substringFromIndex:4];
            NSData * base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.popImageView.image = nil;
            cell.chatTextLable.text = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
            cell.nikeNameLable.text = [RMUserInfo sharedRMUserInfo].userName;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.timeLable.text = [formater stringFromDate: message.timestamp];
            return cell;
        }else{
            RMOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherTextCell"];
            cell.headImageView.image = self.friendImage;
            [cell.headImageView setRoundLayer];
            cell.popImageView.image = nil;
            NSString *base64Str = [message.body substringFromIndex:4];
            NSData * base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.chatTextLable.text = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
            cell.nikeNameLable.text = self.friendJid.user;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.timeTextLable.text = [formater stringFromDate: message.timestamp];
            
            return cell;
        }
    }
    if ([message.body hasPrefix:@"image"]) {
        
        if (message.isOutgoing) {
            RMTextTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"meTextCell"];
            cell.headImageView.image = self.meImage;
            [cell.headImageView setRoundLayer];
            NSString *base64Str = [message.body substringFromIndex:5];
            NSData * base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.chatTextLable.text = nil;
            // 处理图片数据 完成
            cell.popImageView.image = [UIImage imageWithData:base64Data];
            cell.nikeNameLable.text = [RMUserInfo sharedRMUserInfo].userName;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.nikeNameLable.text = [formater stringFromDate: message.timestamp];
            return cell;
        }else{
            RMOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherTextCell"];
            cell.headImageView.image = self.friendImage;
            [cell.headImageView setRoundLayer];
            cell.detailTextLabel.text = @"";
            cell.popImageView.image = nil;
            NSString *base64Str = [message.body substringFromIndex:5];
            NSData * base64Data = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
            cell.popImageView.image = [UIImage imageWithData:base64Data];
            cell.nikeNameLable.text = self.friendJid.user;
            NSDateFormatter *formater = [[NSDateFormatter alloc]init];
            formater.dateFormat = @"yyyy-MM-dd";
            cell.timeTextLable.text = [formater stringFromDate: message.timestamp];
            return cell;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    return cell;

}
#pragma mark--结果控制器发送改变触发的方法
-  (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
    [self scrollTabel];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
