//
//  UserlistRowMenu.m
//  Music
//
//  Created by 吴昊原 on 2018/6/2.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "UserlistRowMenu.h"

@implementation UserlistRowMenu

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        
        self.textfield = [[NSTextField alloc] init];
        self.textfield.backgroundColor = NSColor.clearColor;
//        self.textfield.layer.borderColor = NSColor.clearColor.CGColor;
        [self.textfield setEditable:NO];
        [self.textfield setBordered:NO];
        self.textfield.font = [NSFont systemFontOfSize:17];
        self.textfield.layer.borderWidth = 1;
        self.textfield.textColor = NSColor.blackColor;
        
        [self addSubview:self.textfield];
        
        self.layer.backgroundColor = NSColor.whiteColor.CGColor;
    }
    return self;
}

- (void)layout{
    
    self.textfield.frame = CGRectMake(30, 5, self.frame.size.width, self.frame.size.height);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    
}

@end
