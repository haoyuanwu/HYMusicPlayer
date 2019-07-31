//
//  MusicListApi.m
//  Music
//
//  Created by 吴昊原 on 2018/6/6.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "MusicListApi.h"

@interface MusicListApi()
{
    NSString *_userId;
}
@end

@implementation MusicListApi

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

- (NSString *)serverUrl{
    return getMusicUrl;
}

- (NSDictionary *)parameters{
    return @{
             @"userId":_userId,
             };
}

- (BaseRequest *)requestWithObject:(id)Object{
    BaseRequest *request = [[BaseRequest alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSDictionary *dict in (NSArray *)Object) {
        MusicModel *model = [MusicModel new];
        [model setValuesForKeysWithDictionary:dict];
        [array addObject:model];
    }
    request.responceObject = array;
    
    return request;
}

@end
