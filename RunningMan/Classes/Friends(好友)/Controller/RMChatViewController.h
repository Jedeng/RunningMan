//
//  RMChatViewController.h
//  RunningMan
//
//  Created by tarena on 16/1/21.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
@interface RMChatViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForBottom;
@property (strong,nonatomic) XMPPJID *friendJid;
@end
