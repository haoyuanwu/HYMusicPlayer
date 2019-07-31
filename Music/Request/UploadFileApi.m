//
//  UploadFileApi.m
//  Music
//
//  Created by 吴昊原 on 2018/5/12.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "UploadFileApi.h"

@interface UploadFileApi()
{
    NSString *_song;
    NSString *_singer;
    NSString *_image;
    NSString *_albumName;
    NSString *_fileSize;
    NSString *_voiceStyle;
    NSString *_savePath;
    NSString *_pid;
    NSString *_fileStyle;
}
@end

@implementation UploadFileApi

- (instancetype)initWithSong:(NSString *)song singer:(NSString *)singer image:(NSString *)image albumName:(NSString *)albumName fileSize:(NSString *)fileSize voiceStyle:(NSString *)voiceStyle fileStyle:(NSString *)fileStyle savePath:(NSString *)savePath pid:(NSString *)pid{
    if (self = [super init]) {
        _song = song;
        _singer = singer;
        _image = image;
        _albumName = albumName;
        _fileSize = fileSize;
        _voiceStyle = voiceStyle;
        _savePath = savePath;
        _pid = pid;
        _fileStyle = fileStyle;
    }
    return self;
}

- (NSString *)serverUrl{
    return uploadMusicUrl;
}

- (NSDictionary *)parameters{
    return @{
             @"song":_song?_song:@"",
             @"singer":_singer?_singer:@"",
             @"image":_image?_image:@"",
             @"albumName":_albumName?_albumName:@"",
             @"fileSize":_fileSize?_fileSize:@"",
             @"voiceStyle":_voiceStyle?_voiceStyle:@"",
             @"savePath":_savePath?_savePath:@"",
             @"pid":_pid?_pid:@"",
             @"fileStyle":_fileStyle?_fileStyle:@""
             };
}

- (BaseRequest *)requestWithObject:(id)Object{
    BaseRequest *request = [BaseRequest new];
    
    MusicModel *model = [MusicModel new];
    [model setValuesForKeysWithDictionary:Object];
    request.responceObject = model;
    return request;
}

@end
