//
//  RMSportCircleTableVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/19.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMSportCircleTableVC.h"
#import "RMXMPPTool.h"
#import "UIBarButtonItem+Item.h"
#import "UIViewController+MMDrawerController.h"


@interface RMSportCircleTableVC ()

@end

@implementation RMSportCircleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLeftBarBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
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

@end
