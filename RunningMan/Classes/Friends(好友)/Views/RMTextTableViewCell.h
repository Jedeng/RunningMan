//
//  RMTextTableViewCell.h
//  RunningMan
//
//  Created by tarena on 16/1/21.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *chatTextLable;
@property (weak, nonatomic) IBOutlet UIImageView *popImageView;

@end
