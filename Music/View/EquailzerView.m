//
//  EquailzerView.m
//  Music
//
//  Created by 吴昊原 on 2018/8/22.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "EquailzerView.h"

@interface EquailzerView()

@property (nonatomic,strong)NSMutableDictionary *scenePresetDict;
@property (nonatomic,strong)NSMutableArray *itemArr;
@property (nonatomic,strong)NSDictionary *environmentDict;
@end

@implementation EquailzerView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.slider1.tag = 100 + 0;
    self.slider2.tag = 100 + 1;
    self.slider3.tag = 100 + 2;
    self.slider4.tag = 100 + 3;
    self.slider5.tag = 100 + 4;
    self.slider6.tag = 100 + 5;
    self.slider7.tag = 100 + 6;
    self.slider8.tag = 100 + 7;
    self.slider9.tag = 100 + 8;
    self.slider10.tag = 100 + 9;
    
    self.value1.tag = 200 + 0;
    self.value2.tag = 200 + 1;
    self.value3.tag = 200 + 2;
    self.value4.tag = 200 + 3;
    self.value5.tag = 200 + 4;
    self.value6.tag = 200 + 5;
    self.value7.tag = 200 + 6;
    self.value8.tag = 200 + 7;
    self.value9.tag = 200 + 8;
    self.value10.tag = 200 + 9;
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:EqualizerDic];
    if (dict) {
        self.scenePresetDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:EqualizerArr];
        self.itemArr =  [NSMutableArray arrayWithArray:arr];
    }else{
        self.scenePresetDict = [NSMutableDictionary dictionaryWithDictionary:@{@"正常":@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",],
                                                                               @"超重低音":@[@"9",@"9",@"6",@"5",@"4",@"0",@"0",@"4",@"5",@"8"],
                                                                               @"完美低音":@[@"6",@"4",@"-5",@"2",@"3",@"4",@"4",@"5",@"5",@"6"],
                                                                               @"极致摇滚":@[@"6",@"4",@"0",@"-2",@"-6",@"1",@"4",@"6",@"7",@"9"],
                                                                               @"通透人声":@[@"4",@"0",@"1",@"2",@"3",@"4",@"5",@"4",@"3",@"3"],
                                                                               }];
        
        self.itemArr = [NSMutableArray arrayWithArray:@[@"正常",@"超重低音",@"完美低音",@"极致摇滚",@"通透人声"]];
    }
    [self.preinstallBtn addItemsWithTitles:self.itemArr];
    [self.preinstallBtn setTarget:self];
    
    self.environmentDict = @{@"小房间":[NSNumber numberWithInteger:AVAudioUnitReverbPresetSmallRoom],
                             @"中等房间":[NSNumber numberWithInteger:AVAudioUnitReverbPresetMediumRoom],
                             @"大房间":[NSNumber numberWithInteger:AVAudioUnitReverbPresetLargeRoom],
                             @"中厅":[NSNumber numberWithInteger:AVAudioUnitReverbPresetMediumHall],
                             @"大厅":[NSNumber numberWithInteger:AVAudioUnitReverbPresetLargeHall],
                             @"原声":[NSNumber numberWithInteger:AVAudioUnitReverbPresetPlate],
                             @"中等卧室":[NSNumber numberWithInteger:AVAudioUnitReverbPresetMediumChamber],
                             @"大卧室":[NSNumber numberWithInteger:AVAudioUnitReverbPresetLargeChamber],
                             @"大教堂":[NSNumber numberWithInteger:AVAudioUnitReverbPresetCathedral],
                             @"大房间2":[NSNumber numberWithInteger:AVAudioUnitReverbPresetLargeRoom2],
                             @"小厅2":[NSNumber numberWithInteger:AVAudioUnitReverbPresetMediumHall2],
                             @"小厅3":[NSNumber numberWithInteger:AVAudioUnitReverbPresetMediumHall3],
                             @"大厅2":[NSNumber numberWithInteger:AVAudioUnitReverbPresetLargeHall2],
                             };
    [self.environmentBtn addItemsWithTitles:@[@"小房间",@"中等房间",@"大房间",@"中厅",@"大厅",@"原声",@"中等卧室",@"大卧室",@"大教堂",@"大房间2",@"小厅2",@"小厅3",@"大厅2"]];
    [self.environmentBtn setTarget:self];
    
}

- (IBAction)preinstallAction:(NSPopUpButton *)sender {
    
    NSArray *arr = self.scenePresetDict[sender.title];
    [[AAudioPlayerModule share] updateEQgains:arr];
    for (int i = 0 ; i<arr.count; i++) {
        
        NSSlider *slider = (NSSlider *)[self viewWithTag:100+i];
        [[slider animator] setIntValue:[arr[i] intValue]];
        
        NSTextField *textfield = (NSTextField *)[self viewWithTag:200+i];
        textfield.stringValue = [NSString stringWithFormat:@"%@db",arr[i]];
    }
}
- (IBAction)environmentChange:(NSSlider *)sender {
    [AAudioPlayerModule share].reverb.wetDryMix = sender.doubleValue;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)sliderChangeValues:(NSSlider *)sender {
    [[AAudioPlayerModule share] updateEQWithBandIndex:(int)sender.tag - 100 gain:sender.floatValue];
    
    NSTextField *value = [self viewWithTag:200+sender.tag-100];
    value.stringValue = [NSString stringWithFormat:@"%lddb",sender.integerValue];
//    [QSAAudioPlayer.shared updateEQWithBandIndex:(int)sender.tag - 100 gain:sender.floatValue];
}
- (IBAction)environmentAction:(NSPopUpButton *)sender {
    
    [[AAudioPlayerModule share].reverb loadFactoryPreset:(AVAudioUnitReverbPreset)self.environmentDict[sender.title]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSoundFormat" object:@"environment"];
}

- (IBAction)equalierSwitch:(NSButton *)sender {
    if (sender.state >= NSControlStateValueOff) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSoundFormat" object:@"equalier"];
        self.enuironmentBtn.state = NSControlStateValueOff;
        sender.state = NSControlStateValueOn;
    }else{
        sender.state = NSControlStateValueOff;
    }
}
- (IBAction)environmentSwitch:(NSButton *)sender {
    if (sender.state >= NSControlStateValueOff) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSoundFormat" object:@"environment"];
        self.equlierBtn.state = NSControlStateValueOff;
        sender.state = NSControlStateValueOn;
    }else{
        sender.state = NSControlStateValueOff;
    }
}

- (IBAction)createEqulierAction:(NSButton *)sender {
    if (self.equlierBtn.state >= NSControlStateValueOn) {
        [self.window beginSheet:self.addPresetPanel completionHandler:^(NSModalResponse returnCode) {
            
        }];
    }else{
        
        [FuncTools showAlertWarningWithTitle:@"提示" msg:@"环境效果不能添加自定义"];
    }
    
}
- (IBAction)addEqulierAction:(NSButton *)sender {
    [self.preinstallBtn addItemWithTitle:self.nameTF.stringValue];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0 ; i<10; i++) {
        NSSlider *slider = [self viewWithTag:100 + i];
        [arr addObject:[NSString stringWithFormat:@"%ld",slider.integerValue]];
    }
    [self.scenePresetDict addEntriesFromDictionary:@{self.nameTF.stringValue:arr}];
    [self.itemArr addObject:self.nameTF.stringValue];
    [self.preinstallBtn selectItemAtIndex:self.itemArr.count-1];
    [self.window endSheet:self.addPresetPanel returnCode:NSModalResponseAbort];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.scenePresetDict forKey:EqualizerDic];
    [[NSUserDefaults standardUserDefaults] setValue:self.itemArr forKey:EqualizerArr];
    
}

- (IBAction)closeEqulier:(NSButton *)sender {
    [self.addPresetPanel orderOut:self];
    [self.window endSheet:self.addPresetPanel returnCode:(NSModalResponseAbort)];
}

- (IBAction)deleteEqualizer:(NSButton *)sender {
    
    NSString *nameKey = self.preinstallBtn.selectedItem.title;
    [self.itemArr removeObject:nameKey];
    [self.preinstallBtn removeItemWithTitle:nameKey];
    [self.scenePresetDict removeObjectForKey:nameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.scenePresetDict forKey:EqualizerDic];
    [[NSUserDefaults standardUserDefaults] setObject:self.itemArr forKey:EqualizerArr];
    
}

@end
