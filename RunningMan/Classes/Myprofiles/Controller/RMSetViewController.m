//
//  RMSetViewController.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/16.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMSetViewController.h"

@interface RMSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *secondArr;
@property (nonatomic, strong) NSArray *thirdArr;

@end

@implementation RMSetViewController
- (NSArray *)secondArr
{
    if ( _secondArr == nil)
    {
        self.secondArr = @[@"夜间模式",@"路过提醒",@"手动清理缓存"];
    }
    return _secondArr;
}
- (NSArray *)thirdArr
{
    if ( _thirdArr == nil)
    {
        _thirdArr = @[@"去评分",@"意见反馈",@"操作引导",@"关于我们"];
    }
    return _thirdArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor purpleColor];
//    UIBarButtonItem *barBtn = [UIBarButtonItem item]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
