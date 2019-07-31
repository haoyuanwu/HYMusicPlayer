//
//  LoginApi.h
//  Music
//
//  Created by 吴昊原 on 2018/5/14.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginApi : BaseRequest

- (instancetype)initWithPhone:(NSString *)phone pwd:(NSString *)pwd;
@end
