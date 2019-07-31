//
//  DelegateMusicApi.m
//  Music
//
//  Created by 吴昊原 on 2018/6/8.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "DelegateMusicApi.h"

@interface DelegateMusicApi()
{
    NSString *_musicId;
}
@end

@implementation DelegateMusicApi

- (instancetype)initWithMusicId:(NSString *)musicId{
    if (self = [super init]) {
        _musicId = musicId;
    }
    return self;
}

- (NSString *)serverUrl{
    return delegateMusicUrl;
}

- (NSDictionary *)parameters{
    return @{
             @"musicId":_musicId,
             };
}

- (BaseRequest *)requestWithObject:(id)Object{
    BaseRequest *request = [BaseRequest new];
    
    return request;
}

@end
