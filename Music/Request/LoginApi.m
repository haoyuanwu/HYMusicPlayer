//
//  LoginApi.m
//  Music
//
//  Created by 吴昊原 on 2018/5/14.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "LoginApi.h"

@interface LoginApi()
{
    NSString *_UserTelephone;
    NSString *_UserPassword;
}
@end


@implementation LoginApi

- (instancetype)initWithPhone:(NSString *)phone pwd:(NSString *)pwd{
    if (self = [super init]) {
        _UserTelephone = phone;
        _UserPassword = pwd;
    }
    return self;
}

- (NSString *)serverUrl{
    return loginUrl;
}

- (NSDictionary *)parameters{
    return @{
             @"UserTelephone":_UserTelephone,
             @"UserPassword":_UserPassword
             };
}

- (BaseRequest *)requestWithObject:(id)Object{
    
    UserModel *model = [UserModel sharedInstance];
    [model setValuesForKeysWithDictionary:Object];
    
    return [BaseRequest new];
}

@end
