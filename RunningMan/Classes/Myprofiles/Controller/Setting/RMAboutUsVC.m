//
//  RMAboutUsVC.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/21.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMAboutUsVC.h"

@interface RMAboutUsVC ()

@end

@implementation RMAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    [self setupAboutUs];
}

- (void) setupAboutUs
{
    
    /** 添加背景图片 */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImage *image = [UIImage imageNamed:@"背景图"];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    
    /** 设置文字 */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20,width - 40, height - 40)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor purpleColor];
    label.numberOfLines = 0;
    label.text = @"    这是WindManTeam创建以来第一次做得比较完整的项目,仅以此记录团队成员踏入IOS编程界。,我们尽自己最大的努力把用户体验做得最好。 FIGHTING, KEEP MOVING, DAY DAY UP.DO NOT LAZY,YOU ARE THE BEST";
    [self.view addSubview:label];
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
