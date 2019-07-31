//
//  EquailzerView.h
//  Music
//
//  Created by 吴昊原 on 2018/8/22.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EquailzerView : NSView

@property (weak) IBOutlet NSSlider *slider1;
@property (weak) IBOutlet NSSlider *slider2;
@property (weak) IBOutlet NSSlider *slider3;
@property (weak) IBOutlet NSSlider *slider4;
@property (weak) IBOutlet NSSlider *slider5;
@property (weak) IBOutlet NSSlider *slider6;
@property (weak) IBOutlet NSSlider *slider7;
@property (weak) IBOutlet NSSlider *slider8;
@property (weak) IBOutlet NSSlider *slider9;
@property (weak) IBOutlet NSSlider *slider10;
@property (weak) IBOutlet NSView *backView;


@property (weak) IBOutlet NSTextField *value1;
@property (weak) IBOutlet NSTextField *value2;
@property (weak) IBOutlet NSTextField *value3;
@property (weak) IBOutlet NSTextField *value4;
@property (weak) IBOutlet NSTextField *value5;
@property (weak) IBOutlet NSTextField *value6;
@property (weak) IBOutlet NSTextField *value7;
@property (weak) IBOutlet NSTextField *value8;
@property (weak) IBOutlet NSTextField *value9;
@property (weak) IBOutlet NSTextField *value10;

@property (weak) IBOutlet NSPopUpButton *preinstallBtn;
@property (weak) IBOutlet NSPopUpButton *environmentBtn;
@property (weak) IBOutlet NSSlider *environmentSlider;

@property (weak) IBOutlet NSButton *equlierBtn;
@property (weak) IBOutlet NSButton *enuironmentBtn;

@property (strong) IBOutlet NSPanel *addPresetPanel;
@property (weak) IBOutlet NSTextField *nameTF;
@end

NS_ASSUME_NONNULL_END
