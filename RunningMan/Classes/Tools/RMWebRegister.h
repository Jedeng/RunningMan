//
//  RMWebRegister.h
//  RunningMan
//
//  Created by tarena01 on 16/1/16.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface RMWebRegister : NSObject

singleton_interface(RMWebRegister);

/**  用来产生一个web账号的注册方法 */
-(void)webRegister;
@end
