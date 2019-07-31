//
//  LocalPlayerModule.h
//  Music
//
//  Created by 吴昊原 on 2018/8/8.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicModel.h"
#import "Music-Swift.h"

@protocol LocalPlayerModuleDelegate;

@interface LocalPlayerModule : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,assign)double startTime;
@property (nonatomic,strong) NSArray *musicArr;
@property (nonatomic,strong)AVURLAsset *audioAsset;
@property (nonatomic,assign)MusicPlayerModel playerModel;

@property (nonatomic,strong)id<LocalPlayerModuleDelegate> delegate;
/**
 播放文件
 */
@property (nonatomic,strong)AVAudioFile *internalAudioFile;

/**
 均衡器
 */
@property (nonatomic,strong)AVAudioUnitEQ *eq;

/**
 节点
 */
@property (nonatomic,strong)AVAudioEngine *engine;

/**
 播放器
 */
@property (nonatomic,strong)AVAudioPlayerNode *player;

/**
 进度条计时器
 */
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)MusicModel *model;

- (void)playerWithArr:(NSArray *)array toIndex:(NSInteger)index path:(NSString *)path;

- (void)updateEQWithBandIndex:(int)BandIndex gain:(float)gain;

- (void)updateEQgains:(NSArray<NSString *> *)gains;

- (void)prevAction;
- (void)nextAction;
- (void)playAction;

- (void)seekTotime:(double)time;

@end

@protocol LocalPlayerModuleDelegate <NSObject>

- (void)playerModulePlayAction:(LocalPlayerModule *)PlayerModule player:(AVAudioPlayerNode *)player;

- (void)playerModulePreviousAction:(LocalPlayerModule *)PlayerModule dataSource:(NSArray *)dataSource index:(NSInteger)index;

- (void)playerModuleNextAction:(LocalPlayerModule *)PlayerModule dataSource:(NSArray *)dataSource index:(NSInteger)index;

- (void)playerModuleChangeProgress:(LocalPlayerModule *)PlayerModule volume:(double)volume current:(Float64)current total:(Float64)total ProgressTitle:(NSString *)ProgressTitle;

@end

