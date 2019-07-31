//
//  PlayerModule.h
//  Music
//
//  Created by 吴昊原 on 2018/6/19.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, MusicPlayerModel) {
//    sequencePlayerModel = 0,
//    randomPlayerModel,
//    circulationPlayerModel,
//};

@protocol PlayerModuleDelegate;

@interface PlayerModule : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) AVPlayerItem * songItem;
@property (nonatomic,assign) BOOL isReadToPlay;
@property (nonatomic,strong) NSTimer *timr;
@property (nonatomic,strong) AVAsset *asset;
@property (nonatomic,strong) NSArray *musicArr;

@property (nonatomic,assign) MusicPlayerModel playerModel;

@property (nonatomic,strong) MusicModel *model;

@property (nonatomic,strong) id <PlayerModuleDelegate>delegate;

- (void)playerWithArr:(NSArray *)array toIndex:(NSInteger)index;
- (void)prevAction;
- (void)nextAction;
- (void)playAction;

@end

@protocol PlayerModuleDelegate <NSObject>

- (void)playerModulePlayAction:(PlayerModule *)PlayerModule player:(AVPlayer *)player;

- (void)playerModulePreviousAction:(PlayerModule *)PlayerModule dataSource:(NSArray *)dataSource index:(NSInteger)index;

- (void)playerModuleNextAction:(PlayerModule *)PlayerModule dataSource:(NSArray *)dataSource index:(NSInteger)index;

- (void)playerModuleChangeProgress:(PlayerModule *)PlayerModule volume:(double)volume current:(Float64)current total:(Float64)total ProgressTitle:(NSString *)ProgressTitle;
@end
