//
//  RMSetMyProfilesVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/20.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMSetMyProfilesVC.h"
#import "RMSetMyPofilesTableViewCell.h"

@interface RMSetMyProfilesVC ()<UITableViewDelegate,UITableViewDataSource>

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
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
     RMSetMyPofilesTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"SetMyPofilesCell" forIndexPath:indexPath];
    if (indexPath.section == 0 )
    {
        cell.label.text = self.firstArr[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.label.text = self.secondArr[indexPath.row];
    }
    else
    {
        cell.label.text = self.thirdArr[indexPath.row];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    return view;
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
