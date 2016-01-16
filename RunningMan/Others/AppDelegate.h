//
//  AppDelegate.h
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, assign) BOOL isNotFirst;

@property (nonatomic, strong) BMKMapManager *manager;

- (void) setupNavigationController;

@end

