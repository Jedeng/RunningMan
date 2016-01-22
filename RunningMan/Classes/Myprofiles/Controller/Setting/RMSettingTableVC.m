//
//  RMSettingTableVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/20.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMSettingTableVC.h"
#import "RMSetMyProfilesVC.h"
#import "RMAboutUsVC.h"


@interface RMSettingTableVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *thirdArr;

@end

@implementation RMSettingTableVC

#pragma mark - 懒加载
- (NSArray *)thirdArr
{
    if (!_thirdArr)
    {
        _thirdArr = @[@"去评分",@"建议反馈",@"关于我们"];
    }
    return _thirdArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self setupLeftBarBtn];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return self.thirdArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = @"个人资料";
    }
    else
    {
        cell.textLabel.text = self.thirdArr[indexPath.row];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        RMSetMyProfilesVC *MyPofiles = [[RMSetMyProfilesVC alloc]init];
        [self.navigationController pushViewController:MyPofiles animated:YES];
    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        RMAboutUsVC *aboutUS = [RMAboutUsVC new];
        [self.navigationController pushViewController:aboutUS animated:YES];
    }
    //让点击状态自动消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 左导航栏按钮方法实现

- (void) setupLeftBarBtn
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemReply
                                                                              target: self
                                                                              action: @selector(dismissLastView)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)dismissLastView{
    
//    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


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

@end
