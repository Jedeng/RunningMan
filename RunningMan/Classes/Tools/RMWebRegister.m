//
//  RMWebRegister.m
//  RunningMan
//
//  Created by tarena01 on 16/1/16.
//  Copyright © 2016年 WindManTeam. All rights reserved.
//

#import "RMWebRegister.h"
#import "RMUserInfo.h"
#import "NSString+md5.h"
#import "AFNetworking.h"

@implementation RMWebRegister

singleton_implementation(RMWebRegister);

-(void)webRegister
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://%@:8080/allRunServer/register.jsp",RMXMPPHOSTNAME];
    /**  准备参数 */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"username"] = [RMUserInfo sharedRMUserInfo].registerName;
    parameters[@"md5password"] = [[RMUserInfo sharedRMUserInfo].registerPassword md5StrXor];
    parameters[@"nickname"] = [RMUserInfo sharedRMUserInfo].registerName;

    /**  发送请求 */
    [manager POST:baseUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = [UIImage imageNamed:@"headImage"];
        NSData *data = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"headImage.png" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         MYLog(@"webRegister success and return obj:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MYLog(@"webRegister error:%@",error);
    }];
    
}

@end
