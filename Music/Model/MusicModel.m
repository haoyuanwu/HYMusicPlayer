//
//  MusicModel.m
//  Music
//
//  Created by 吴昊原 on 2018/5/17.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static MusicModel *_obj;
    dispatch_once(&onceToken, ^{
        _obj = [[self alloc] init];
        _obj.downloadArray = [[NSMutableArray alloc] initWithCapacity:1];
    });
    return _obj;
}

-  (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"musicId"] && [value isKindOfClass:[NSNumber class]]){
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:@"musicid"];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
}

@end
