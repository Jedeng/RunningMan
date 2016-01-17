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
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.text = @"返回";
    backBtn.frame = CGRectMake(40, 40, 60, 40);
    [self.view addSubview:backBtn];
    
    [self createTableView];
    
}

- (void) createTableView
{
    _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width,
                                                                                                          self.view.bounds.size.height)
                                                                      style: UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate      = self;
    
    [self.view addSubview:_tableView];
}


#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if( section == 1)
    {
        return 3;
    }
    else if ( section == 2)
    {
        return 4;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (indexPath.section == 0) {
        cell.textLabel.text = @"个人资料";
    }
    if (indexPath.section == 1) {
        
        cell.textLabel.text = self.secondArr[indexPath.row];
    }
    if (indexPath.section == 2) {
        
        cell.textLabel.text = self.thirdArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIViewController *aboutUS = [[UIViewController alloc]init];
        [self.navigationController pushViewController:aboutUS animated:YES];
    }

    //让点击状态自动消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 左导航栏按钮方法实现
- (void)dismissVC{
    
    [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
