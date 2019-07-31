//
//  Header.h
//  Music
//
//  Created by 吴昊原 on 2018/5/16.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define BaseUrl  @"http://10.68.136.168:8080"
#define des3key @"wwuhaoyuan860752"
#define EqualizerDic @"equalizerDic"
#define EqualizerArr @"equalizerArr"

static NSString *loginUrl = @"/MusicJava/LoginApi";
static NSString *getMusicUrl = @"/MusicJava/GetUserMusicApi";
static NSString *uploadMusicUrl = @"/MusicJava/UploadMusicApi";
static NSString *delegateMusicUrl = @"/MusicJava/DelegateMusicApi";

typedef NS_ENUM(NSUInteger, MusicPlayerModel) {
    sequencePlayerModel = 0,
    randomPlayerModel,
    circulationPlayerModel,
};

typedef NS_ENUM(NSUInteger, TableViewMusicListStyle) {
    LocalMusicListStyle = 0,
    lineMusicListStyle,
    downMusicListStyle,
};

#endif /* Header_h */
