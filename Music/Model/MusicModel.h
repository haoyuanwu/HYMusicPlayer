//
//  MusicModel.h
//  Music
//
//  Created by 吴昊原 on 2018/5/17.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface MusicModel : BaseModel
+ (instancetype)sharedInstance;

@property (nonatomic,strong) NSString *musicId; //  歌曲id
@property (nonatomic,strong) NSString *singer;//歌手
@property (nonatomic,strong) NSString *song;//歌曲名
@property (nonatomic,strong) NSString *image;//图片
@property (nonatomic,strong) NSString *albumName;//专辑名
@property (nonatomic,strong) NSString *fileSize;//文件大小
@property (nonatomic,strong) NSString *voiceStyle;//音质类型
@property (nonatomic,strong) NSString *fileStyle;//文件类型
@property (nonatomic,strong) NSString *creatDate;//创建日期
@property (nonatomic,strong) NSString *savePath; //存储路径
@property (nonatomic,strong) NSString *url;//文件路径
@property (nonatomic,strong) NSString *createTime; // 上传的时间
@property (nonatomic,strong) NSData *urlData; // 沙盒授权数据
@property (nonatomic,assign) NSInteger isUpdata;//是否上传
@property (nonatomic,assign) NSInteger isDownloaded;//是否已下载


@property (nonatomic,strong) NSMutableArray *musicArray;
@property (nonatomic,strong) NSMutableArray *downloadArray;

@end
