//
//  RMFriendTableVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMFriendTableVC.h"
#import "RMUserInfo.h"
#import "RMXMPPTool.h"
#import "RMFriendCell.h"
#import "UIImageView+RMRoundImageView.h"

#import "UIViewController+MMDrawerController.h"
#import "UIBarButtonItem+Item.h"



/** 结果控制器代理 */
@interface RMFriendTableVC ()<NSFetchedResultsControllerDelegate>

/** 朋友数组 */
@property (nonatomic,strong) NSArray *friends;
/** 利用结果控制器代理处理数据,可以实现随时监听数据变更 */
@property (nonatomic,strong) NSFetchedResultsController *fetchController;



@end

@implementation RMFriendTableVC

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /** 加载好友列表:  */
//    [self loadFriendsList];
}

- (void) loadFriendsList
{
    /** 获取上下文对象 */
    NSManagedObjectContext *context = [[RMXMPPTool sharedRMXMPPTool].xmppRosterStore
                                                              mainThreadManagedObjectContext];
    
    /** 关联实体 */
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    /** 设置过滤条件, predicate: 谓语,叙述语,断定,  此处可以当做过滤用... */
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"streamBareJidStr = %@ and subscription!=%@",
                                                                                                 [RMUserInfo sharedRMUserInfo].jidStr,@"none"];
    
    request.predicate = predicate;
    
    /** 排序 */
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[nameSort];
    
    /** 获取数据 */
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest: request
                                                                                          managedObjectContext: context
                                                                                             sectionNameKeyPath: nil
                                                                                                            cacheName: nil];
    
    self.fetchController.delegate = self;

    NSError *error = nil;
    [self.fetchController performFetch:&error];
    if (error)
    {
        MYLog(@"好友列表加载失败:%@",error);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftBarBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.fetchController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *identifier = @"friendCell";
        RMFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        [cell.headerImage setRoundLayer];
        
        /** 从上面得到的对象中解析出朋友数据 */
        XMPPUserCoreDataStorageObject *friend = self.fetchController.fetchedObjects[indexPath.row];
        
        NSData *imageData = [[RMXMPPTool sharedRMXMPPTool].xmppvCardAvar photoDataForJID:friend.jid];
        
        if (imageData)
        {
            cell.headerImage.image = [UIImage imageWithData:imageData];
        }
        else
        {
            cell.headerImage.image = [UIImage imageNamed:@"icon1"];
        }
        
        cell.nikeNameLabel.text = friend.jidStr;
    
        switch ([friend.sectionNum intValue])
        {
            case 0:
                cell.onLineLabel.text = @"在线";
                break;
            case 1:
                cell.onLineLabel.text = @"离开";
                break;
            default:
                cell.onLineLabel.text = @"离线";
                break;
        }

        return cell;
}

/** 行高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


/** 添加删除模式 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPUserCoreDataStorageObject *friend = self.fetchController.fetchedObjects[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /** 删除模式下,删除好友 */
        [[RMXMPPTool sharedRMXMPPTool].xmppRoster removeUser:friend.jid];
    }
    else
    {
        
    }
}

/** 数据变化 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

- (void) setupLeftBarBtn
{
    XMPPvCardTemp *vCard = [RMXMPPTool sharedRMXMPPTool].xmppvCard.myvCardTemp;
    
    UIImage *headerImage = [[UIImage alloc]init];
    if (vCard.photo) {
       headerImage = [UIImage imageWithData:vCard.photo];
    }
    else
    {
        headerImage = [UIImage imageNamed:@"headImage"];
    }
    
    UIBarButtonItem *item = [UIBarButtonItem itemWithImage: headerImage
                                                                               highImage: nil
                                                                                      target: self
                                                                                     action: @selector(myPofilesBtn)
                                                                    forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item;
}
- (void) myPofilesBtn
{
    [[self mm_drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
#pragma mark - 朋友界面与聊天界面之间跳转的正向传值
@end
