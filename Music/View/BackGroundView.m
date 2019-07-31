//
//  BackGroundView.m
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "BackGroundView.h"
#import "LoginApi.h"

@interface BackGroundView()<AAudioPlayerModuleDelegate>
{
    CGFloat volume;
//    NSInteger _playIndex;
    NSArray *_musicArr;
//    NSURL *_playerUrl;
    double _duration;
}
//@property (nonatomic,strong) LocalPlayerModule *playeModule;
@property (nonatomic,strong)AAudioPlayerModule *playerModule;
@end

@implementation BackGroundView

- (instancetype)initWithCoder:(NSCoder *)decoder{
    
    self.layer.masksToBounds = NO;
    
    return [super initWithCoder:decoder];
}

- (void)awakeFromNib{
    
    self.playerModule = [AAudioPlayerModule share];
    self.playerModule.delegate = self;
    
    volume = [[NSUserDefaults standardUserDefaults] floatForKey:@"volume"];
    
    self.volumeSlider.minValue = 0;
    self.volumeSlider.maxValue = 1;
    self.volumeSlider.floatValue = volume;
    
    
    self.slider.maxValue = 1;
    self.slider.minValue = 0;
    self.slider.floatValue = 0;
    
    [self changeVolume:self.volumeSlider];
    self.playerModule.player.volume = self.volumeSlider.floatValue;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:musicData];
    if (data != nil) {
        _musicArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    }
    
    [super awakeFromNib];
    
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        [self keyDown:aEvent];
        
        NSString *character = aEvent.characters;
        if (aEvent.window == self.window  && [character isEqualToString:@" "]) {
            if (self.playerModule._playerUrl) {
                [self play:nil];
            }else{
                [self playerWithArr:self->_musicArr toIndex:0];
            }
        }
        
        NSString *key = [aEvent.characters stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        // 右
        if (aEvent.isCommandDown && [key isEqualToString:@"%EF%9C%83"]) {
            [self.playerModule nextAction];
        }
        // 左
        if (aEvent.isCommandDown && [key isEqualToString:@"%EF%9C%82"]) {
            [self.playerModule prevAction];
        }
        // 上
        if (aEvent.isCommandDown && [key isEqualToString:@"%EF%9C%80"]) {
            if (self.volumeSlider.doubleValue < 1) {
                self.volumeSlider.doubleValue += 0.1;
                self.playerModule.player.volume = self.volumeSlider.doubleValue;
                self->volume = self.volumeSlider.doubleValue;
            }
        }
        // 下
        if (aEvent.isCommandDown && [key isEqualToString:@"%EF%9C%81"]) {
            if (self.volumeSlider.doubleValue > 0) {
                self.volumeSlider.doubleValue -= 0.1;
                self.playerModule.player.volume = self.volumeSlider.doubleValue;
                self->volume = self.volumeSlider.doubleValue;
            }
        }
        if (self->volume >= 0.6) {
            [self.volumeBtn setImage:[NSImage imageNamed:@"bigVolume"]];
        }else if (self->volume > 0.3) {
            [self.volumeBtn setImage:[NSImage imageNamed:@"mediumVolume"]];
        }else if (self->volume > 0 ){
            [self.volumeBtn setImage:[NSImage imageNamed:@"smallVolume"]];
        }else{
            [self.volumeBtn setImage:[NSImage imageNamed:@"closeVolume"]];
        }
        if (aEvent.isCommandDown && [key isEqualToString:@"q"]) {
            exit(1);
        }
        
        return aEvent;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSoundFormat:) name:@"changeSoundFormat" object:nil];
}

- (void)changeSoundFormat:(NSNotification *)sender{
    NSString *format = sender.object;
    if ([format isEqualToString:@"environment"]) {
        [[AAudioPlayerModule share] openEnvironment:self.slider.doubleValue];
    }else{
        [[AAudioPlayerModule share] openEqulier:self.slider.doubleValue];
    }
}

/**
 播放
 */
- (IBAction)volumeBtn:(NSButton *)sender {
    
}

- (void)playerWithArr:(NSArray *)array toIndex:(NSInteger)index{
    
//    [self.playerModule playerWithArr:array toIndex:index path:nil];
    [self.playerModule playerWithArr:array to:index path:nil];
    [self.playBtn setImage: [NSImage imageNamed:@"pause"]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (BOOL)performKeyEquivalent:(NSEvent *)event{
    
    return  YES;
}

- (void)playerModuleChangeProgress:(AAudioPlayerModule *)PlayerModule volume:(double)volume current:(double)current total:(double)total progressTitle:(NSString *)ProgressTitle{
    self.slider.doubleValue = volume;
    self.durationLabel.stringValue = ProgressTitle;
}

- (void)playerModulePlayAction:(AAudioPlayerModule *)PlayerModule player:(AVAudioPlayerNode *)player{
    if (player.playing) {
        [self.playBtn setImage: [NSImage imageNamed:@"pause"]];
    }else{
        [self.playBtn setImage:[NSImage imageNamed:@"play"]];
    }
}

/**
 上一曲
 */
- (IBAction)prev:(NSButton *)sender {
    if (self.playerModule._playerUrl) {
        [self.playerModule prevAction];
    }else{
        [self playerWithArr:self->_musicArr toIndex:0];
    }
    
}

/**
 播放音乐
 */
- (IBAction)play:(NSButton *)sender {
    if (self.playerModule._playerUrl) {
        [self.playerModule playAction];
    }else{
        [self playerWithArr:self->_musicArr toIndex:0];
    }
}


/**
 下一曲
 */
- (IBAction)next:(NSButton *)sender {
    if (self.playerModule._playerUrl) {
        [self.playerModule nextAction];
    }else{
        [self playerWithArr:self->_musicArr toIndex:0];
    }
}

/**
 声音开启关闭
 */
- (IBAction)openVolume:(id)sender {
    if (self.playerModule.player.volume == 0) {
        self.playerModule.player.volume = volume;
        self.volumeSlider.floatValue = volume;
    }else{
        self.playerModule.player.volume = 0;
        self.volumeSlider.floatValue = 0;
    }
}

/**
 调整音量
 */
- (IBAction)changeVolume:(NSSlider *)sender {
    self.playerModule.player.volume = sender.floatValue;
    volume = sender.floatValue;
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:@"volume"];
    if (volume >= 0.6) {
        [self.volumeBtn setImage:[UIImage imageNamed:@"bigVolume"]];
    }else if (volume > 0.3) {
        [self.volumeBtn setImage:[UIImage imageNamed:@"mediumVolume"]];
    }else if (volume > 0 ){
        [self.volumeBtn setImage:[UIImage imageNamed:@"smallVolume"]];
    }else{
        [self.volumeBtn setImage:[UIImage imageNamed:@"closeVolume"]];
    }
}

/**
 跳转到指定进度
 */
- (IBAction)processValue:(NSSlider *)sender {
    
//    _duration = CMTimeGetSeconds([LocalPlayerModule shareInstance].audioAsset.duration);
//    [[LocalPlayerModule shareInstance] seekTotime:sender.floatValue];
    [self.playerModule seekTotime:sender.floatValue];
    
 }

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
