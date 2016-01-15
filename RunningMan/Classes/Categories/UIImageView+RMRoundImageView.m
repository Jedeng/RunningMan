//
//  UIImageView+RMRoundImageView.m
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "UIImageView+RMRoundImageView.h"

@implementation UIImageView (RMRoundImageView)

/** 圆头像的实现 */
- (void)setRoundLayer
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius      = self.bounds.size.width * 0.5;
    self.layer.borderWidth       = 1;
    self.layer.borderColor        = [UIColor whiteColor].CGColor;
}

@end
