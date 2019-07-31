//
//  MusicListApi.h
//  Music
//
//  Created by 吴昊原 on 2018/6/6.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "BaseRequest.h"

/**
 用户音乐列表
 */
@interface MusicListApi : BaseRequest

- (instancetype)initWithUserId:(NSString *)userId;

@end
