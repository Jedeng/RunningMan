//
//  RMSetMyProfilesVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/20.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMSetMyProfilesVC.h"

@interface RMSetMyProfilesVC ()
@property (nonatomic, strong) NSArray *firstArr;
@property (nonatomic, strong) NSArray *secondArr;
@property (nonatomic, strong) NSArray *thirdArr;
@end

@implementation RMSetMyProfilesVC
-(NSArray *)firstArr
{
    if (_firstArr)
    {
        _firstArr = @[@"昵称",@"性别",@"生日",@"邮箱"];
    }
    return _firstArr;
}
- (NSArray *)secondArr
{
    if (_secondArr)
    {
        _secondArr = @[@"职业",@"公司",@"学校",@"故乡"];
    }
    return _secondArr;
}
- (NSArray *)thirdArr
{
    if (_thirdArr)
    {
        _thirdArr = @[@"个性签名"];
    }
    return _thirdArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        return self.firstArr.count;
    }
    else if(section == 1)
    {
        return self.secondArr.count;
    }
    else
    {
        return self.thirdArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
#pragma TODO: 自定义修改界面的 cell
    cell.textLabel.text = @"test";
    
    return cell;
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