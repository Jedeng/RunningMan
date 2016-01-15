//
//  Singleton.h
//  RunningMan
//
//  Created by 纵使寂寞开成海 on 16/1/15.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

/** .h 文件 */
#define singleton_interface(class) + (instancetype) shared##class;

/** .m 文件 */
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id) allocWithZone: (struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone: zone]; \
    }); \
    return _instance; \
} \
\
+ (instancetype) shared##class \
{ \
    if ( _instance == nil ) { \
        _instance = [[class alloc] init]; \
    } \
    return _instance; \
}



