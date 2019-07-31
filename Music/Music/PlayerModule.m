//
//  PlayerModule.m
//  Music
//
//  Created by 吴昊原 on 2018/6/19.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "PlayerModule.h"

@interface PlayerModule()
{
    CGFloat volume;
    NSInteger _playIndex;
    NSURL *_playerUrl;
    double _duration;
}
@end

@implementation PlayerModule

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static PlayerModule *_obj;
    dispatch_once(&onceToken, ^{
        _obj = [[self alloc] init];
    });
    return _obj;
}

- (void)setMusicArr:(NSArray *)musicArr{
    _musicArr = musicArr;
    if (self.player == nil) {
        self.model = musicArr[_playIndex];
        [self setPlayerdata];
    }
}

- (instancetype)init{
    if (self = [super init]) {
        
        volume = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        self.playerModel = sequencePlayerModel;
        
    }
    return self;
}

- (NSArray *)getMusicfrequencydbValue{
    return [[NSArray alloc] init];
}

/**
 播放
 */
- (void)playerWithArr:(NSArray *)array toIndex:(NSInteger)index{
     
    _playIndex = index;
    _musicArr = array;
    self.model = array[index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playeredNSNotification" object:nil];
    
    [self setPlayerdata];
//    @finally {
//        [playUrl stopAccessingSecurityScopedResource];
//    }
    
    [self.player play];
    
    [self openTimr];
    
}

- (void)setPlayerdata{
    
    if (self.player) {
        [_playerUrl stopAccessingSecurityScopedResource];
        [self.player pause];
        self.player = nil;
    }
    
    // 对沙盒以外的URL路径授权
    if (self.model.urlData != nil) {
        _playerUrl =  [NSURL URLByResolvingBookmarkData:self.model.urlData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:nil error:nil];
        // 开启权限
        [_playerUrl startAccessingSecurityScopedResource];
    }else{
        //utf8编码  使用 [str stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        NSString *urlstr = [[BaseUrl stringByAppendingString:self.model.url] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        _playerUrl = [NSURL URLWithString:urlstr];
    }
    self.asset = [AVAsset assetWithURL:_playerUrl];
    self.songItem = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player = [AVPlayer playerWithPlayerItem:self.songItem];
    self.player.volume = volume;
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    [self nextAction];
}

/**
 打开计时
 */
- (void)openTimr{
    
    if (@available(macOS 10.12, *)) {
        self.timr = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            Float64 value = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
//            self.slider.doubleValue = value;
            
            int current = (int)CMTimeGetSeconds(self.player.currentItem.currentTime);
            int total = (int)CMTimeGetSeconds(self.player.currentItem.duration);
            NSString *obj = [NSString stringWithFormat:@"%d:%02d/%d:%02d", current / 60, current % 60, total/60, total % 60, nil];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerModuleChangeProgress:volume:current:total:ProgressTitle:)]) {
                [self.delegate playerModuleChangeProgress:self volume:value current:current total:total ProgressTitle:obj];
            }
            
            [self getMusicfrequencydbValue];
        }];
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)prevAction{
    if (_playIndex > 0) {
        _playIndex -= 1;
        
    }else{
        _playIndex = _musicArr.count - 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerModulePreviousAction:dataSource:index:)]) {
        [self.delegate playerModulePreviousAction:self dataSource:_musicArr index:_playIndex];
    }
    [self playerWithArr:_musicArr toIndex:_playIndex];
}

- (void)nextAction{
    if (self.playerModel == randomPlayerModel) {
        _playIndex = arc4random()%_musicArr.count;
    }else if (self.playerModel == sequencePlayerModel){
        if (_playIndex < _musicArr.count-1) {
            _playIndex += 1;
        }else{
            _playIndex = 0;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerModuleNextAction:dataSource:index:)]) {
        [self.delegate playerModuleNextAction:self dataSource:_musicArr index:_playIndex];
    }
    [self playerWithArr:_musicArr toIndex:_playIndex];
}

- (void)playAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playeredNSNotification" object:nil];
    if (self.player.rate == 1) {
        [self.player pause];
//        [self.playBtn setImage: [NSImage imageNamed:@"play"]];
        [self.timr invalidate];
    }else{
        [self.player play];
        [self openTimr];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerModulePlayAction:player:)]) {
        [self.delegate playerModulePlayAction:self player:self.player];
    }
}

@end
