//
//  UserModel.m
//  Music
//
//  Created by 吴昊原 on 2018/6/4.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static UserModel *_obj;
    dispatch_once(&onceToken, ^{
        _obj = [[self alloc] init];
    });
    return _obj;
}

@end
