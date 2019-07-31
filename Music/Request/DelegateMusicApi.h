//
//  DelegateMusicApi.h
//  Music
//
//  Created by 吴昊原 on 2018/6/8.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "BaseRequest.h"

@interface DelegateMusicApi : BaseRequest

- (instancetype)initWithMusicId:(NSString *)musicId;
@end
