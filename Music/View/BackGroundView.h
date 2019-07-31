//
//  BackGroundView.h
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

@interface BackGroundView : NSView
@property (weak) IBOutlet NSButton *prevBtn;
@property (weak) IBOutlet NSButton *playBtn;
@property (weak) IBOutlet NSButton *nextBtn;
@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSSlider *volumeSlider;
@property (weak) IBOutlet NSTextField *durationLabel;
@property (weak) IBOutlet NSButton *volumeBtn;
@property (weak) IBOutlet NSButton *playModelBtn;

- (void)playerWithArr:(NSArray *)array toIndex:(NSInteger)index;


@end
