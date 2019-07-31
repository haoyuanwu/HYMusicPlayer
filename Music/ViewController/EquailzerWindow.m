//
//  EquailzerPanel.m
//  Music
//
//  Created by 吴昊原 on 2018/8/14.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "EquailzerWindow.h"
#import "EquailzerView.h"

@interface EquailzerWindow()

@end

@implementation EquailzerWindow

- (void)awakeFromNib{
    [super awakeFromNib];
    
    NSArray *arr = [NSApp windows];
    for (NSWindow *window in arr) {
        if ([window isKindOfClass:[NSPanel class]]) {
            NSPanel *panel = (NSPanel *)window;
            if ([panel.title isEqualToString:@"添加预设"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [panel orderOut:self];
                });
            }
        }
    }
}

@end
