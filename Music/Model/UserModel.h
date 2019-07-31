//
//  UserModel.h
//  Music
//
//  Created by 吴昊原 on 2018/6/4.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic,strong) NSString *UserName;

@property (nonatomic,strong) NSString *UserPassword;

@property (nonatomic,strong) NSString *UserTelephone;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *portrait;

+ (instancetype)sharedInstance;

@end
