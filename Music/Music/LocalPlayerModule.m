//
//  LocalPlayerModule.m
//  Music
//
//  Created by 吴昊原 on 2018/8/8.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "LocalPlayerModule.h"
#import "Music-Swift.h"

@interface LocalPlayerModule()
{
    CGFloat volume;
    NSInteger _playIndex;
    NSURL *_playerUrl;
    double _duration;
    NSFileHandle *fileHandle_read;
    NSFileHandle *fileHandle_write;
    long long playLenght;
    double _startTime;
//    QSAAudioPlayer *AAudioPlayer;
}

@end

@implementation LocalPlayerModule

+ (instancetype)shareInstance
{
    static LocalPlayerModule* _instance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance ;
}

- (instancetype)init{
    if (self = [super init]) {
        self.eq = [[AVAudioUnitEQ alloc] initWithNumberOfBands:10];
        self.player = [[AVAudioPlayerNode alloc] init];
        self.engine = [[AVAudioEngine alloc] init];
        self.playerModel = sequencePlayerModel;
        [self startEngine];
        _startTime = 0;
        volume = 1;
        
//        AAudioPlayer = [QSAAudioPlayer shared];
//        [AAudioPlayer startEngine];
    }
    return self;
}

- (void)startEngine{
    float frequencys[10] = {31.0, 62.0, 125.0, 250.0, 500.0, 1000.0, 2000.0, 4000.0, 8000.0, 16000.0};
    for (int i  = 0; i < 9; i++) {
       AVAudioUnitEQFilterParameters *filterParams = self.eq.bands[i];
        filterParams.bandwidth = 1.0;
        filterParams.bypass = YES;
        filterParams.frequency = frequencys[i];
    }
    AVAudioFormat *format = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:44100.0 channels:2];
    [self connectNodeformat:format];
    if (!self.engine.running) {
        NSError *error;
        [self.engine startAndReturnError:&error];
        if (error) {
            NSLog(@"启动错误 %@",error);
        }
    }
}

- (void)connectNodeformat:(AVAudioFormat *)format{
    
    [self.engine attachNode:self.player];
    [self.engine attachNode:self.eq];
    [self.engine connect:self.player to:self.eq format:format];
    [self.engine connect:self.eq to:self.engine.mainMixerNode format:format];
}


- (void)playerWithArr:(NSArray *)array toIndex:(NSInteger)index path:(NSString *)path{
    self.musicArr = array;
    _playIndex = index;
    
    [self timerOut];
    
    if (!path) {
        self.model = array[index];
        
        _startTime = 0;
        _playerUrl =  [NSURL URLByResolvingBookmarkData:self.model.urlData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:nil error:nil];
        // 开启权限
        [_playerUrl startAccessingSecurityScopedResource];
        _audioAsset = [AVURLAsset URLAssetWithURL:_playerUrl options:nil];
        
    }else{
        _playerUrl = [NSURL URLWithString:path];
    }
    
    
    [self openPlayer];
}

- (void)openPlayer{
    NSError *error;
    
    if (self.player.isPlaying) {
        [self timerOut];
    }
    
    self.internalAudioFile = [[AVAudioFile alloc] initForReading:_playerUrl error:&error];
    if (error) {
        NSLog(@"读取文件初始化错误 %@",error);
        return;
    }
    [self.player scheduleFile:self.internalAudioFile atTime:nil completionHandler:^{
        
    }];
    
    if (!self.engine.isRunning) {
        NSError *error;
        [self.engine startAndReturnError:&error];
        if (error) {
            NSLog(@"启动错误 %@",error);
        }
    }
    if (self.engine.isRunning) {
        [self.player play];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playeredNSNotification" object:nil];
        [self timerUp];
    }
}

- (void)seekTotime:(double)time{
    
    [self timerOut];
    
    _startTime = time * CMTimeGetSeconds(self.audioAsset.duration);
    
    _playerUrl =  [NSURL URLByResolvingBookmarkData:self.model.urlData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:nil error:nil];
    // 开启权限
    [_playerUrl startAccessingSecurityScopedResource];
    playLenght = [self getMusicSize:[_playerUrl path]] * time;
    
    fileHandle_read = [NSFileHandle fileHandleForReadingAtPath:[_playerUrl path]];
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/play.%@",self.model.fileStyle]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExists = [manager fileExistsAtPath:path isDirectory:&isDir];
    if (isExists) {
        [manager removeItemAtPath:path error:nil];
    }
    [manager createFileAtPath:path contents:nil attributes:nil];
    fileHandle_write = [NSFileHandle fileHandleForWritingAtPath:path];
    uint64 fileSize = [self getMusicSize:[_playerUrl path]];
    while (playLenght != fileSize) {
        [fileHandle_read seekToFileOffset:playLenght];
        NSData *data = [fileHandle_read readDataOfLength:1048576];
        [fileHandle_write seekToEndOfFile];
        [fileHandle_write writeData:data];
        playLenght += [data length];
    }
    
    [self playerWithArr:_musicArr toIndex:_playIndex path:path];
}

- (long long)getMusicSize:(NSString *)path{
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return fileAttributes.fileSize;
}

/**
 启动定时
 */
- (void)timerUp{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        AVAudioTime *nodeTime = self.player.lastRenderTime;
        if (nodeTime) {
            AVAudioTime *playerTime = [self.player playerTimeForNodeTime:nodeTime];
            CMTime audioDuration = self.audioAsset.duration;
            double audioDurationSeconds = CMTimeGetSeconds(audioDuration);
            double current = playerTime.sampleTime / playerTime.sampleRate + self->_startTime;
            double total = audioDurationSeconds;
            
            NSString *obj = [NSString stringWithFormat:@"%d:%02d/%d:%02d", (int)current / 60, (int)current % 60, (int)total/60, (int)total % 60, nil];
            
            Float64 value = current / audioDurationSeconds;
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerModuleChangeProgress:volume:current:total:ProgressTitle:)]) {
                [self.delegate playerModuleChangeProgress:self volume:value current:current total:total ProgressTitle:obj];
            }
            
            if (value >= 1) {
                [self timerOut];
                [self nextAction];
            }
        }
    }];
}

/**
 关闭定时
 */
- (void)timerOut{
    [self.engine stop];
    [self.player stop];
    [self.timer invalidate]; 
    self.timer = nil;
}

- (void)updateEQWithBandIndex:(int)BandIndex gain:(float)gain{
    AVAudioUnitEQFilterParameters *filterParams = self.eq.bands[BandIndex];
    filterParams.gain = gain;
}

- (void)updateEQgains:(NSArray<NSString *> *)gains{
    
    for (int i = 0 ; i < 9; i++) {
        AVAudioUnitEQFilterParameters *filterParams = self.eq.bands[i];
        filterParams.gain = [gains[i] floatValue];
    }
}

- (void)prevAction{
    [self timerOut];
    if (_playIndex > 0) {
        _playIndex -= 1;
        
    }else{
        _playIndex = _musicArr.count - 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerModulePreviousAction:dataSource:index:)]) {
        [self.delegate playerModulePreviousAction:self dataSource:_musicArr index:_playIndex];
    }
    [self playerWithArr:_musicArr toIndex:_playIndex path:nil];
}

- (void)nextAction{
    [self timerOut];
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
    [self playerWithArr:_musicArr toIndex:_playIndex path:nil];
}

- (void)playAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playeredNSNotification" object:nil];
    if (self.player.isPlaying) {
        [self.player pause];
//                [self.playBtn setImage: [NSImage imageNamed:@"play"]];
        [self.timer invalidate];
    }else{
        [self.player play];
        [self timerUp];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerModulePlayAction:player:)]) {
        [self.delegate playerModulePlayAction:self player:self.player];
    }
}

@end
