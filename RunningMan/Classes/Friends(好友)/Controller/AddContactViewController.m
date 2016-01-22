//
//  AddContactViewController.m
//  RunningMan
//
//  Created by tarena on 16/1/21.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "AddContactViewController.h"
#import "RMXMPPTool.h"
#import "XMPPJID.h"
#import "RMUserInfo.h"
#import "MBProgressHUD+KR.h"
@interface AddContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *JidTextField;

- (IBAction)back:(id)sender;
@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)Check:(id)sender {
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",self.JidTextField.text,RMXMPPDOMAIN];
    XMPPJID  *jid = [XMPPJID jidWithString:jidStr];
    MYLog(@"%@",jid);
    if ([[RMXMPPTool sharedRMXMPPTool].xmppRosterStore userExistsWithJID:jid xmppStream:[RMXMPPTool sharedRMXMPPTool].xmppStream]) {
        [MBProgressHUD showError:@"对方已经是你的好友"];
    }
    if ([jidStr isEqualToString:[RMUserInfo sharedRMUserInfo].jidStr]) {
        [MBProgressHUD showError:@"不能添加自己"];
        return;
    }
    [[RMXMPPTool sharedRMXMPPTool].xmppRoster subscribePresenceToUser:jid];
    [[RMXMPPTool sharedRMXMPPTool].xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
      //  [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

   
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
