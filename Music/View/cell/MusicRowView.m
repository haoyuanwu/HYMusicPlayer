//
//  MusicRowView.m
//  Music
//
//  Created by 吴昊原 on 2018/5/25.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "MusicRowView.h"

@implementation MusicRowView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)drawSelectionInRect:(NSRect)dirtyRect{
    
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSInsetRect(self.bounds, 1, 1);
        [[NSColor colorWithWhite:0.9 alpha:1] setStroke]; //设置边框颜色
        [[NSColor colorWithWhite:0.5 alpha:0.5] setFill]; //设置填充背景颜色
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:selectionRect];
        [path fill];
        [path stroke];
    }
}

@end
