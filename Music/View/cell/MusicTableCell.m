//
//  MusicTableCell.m
//  Music
//
//  Created by 吴昊原 on 2018/6/22.
//  Copyright © 2018 吴昊原. All rights reserved.
//

#import "MusicTableCell.h"

@implementation MusicTableCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.nameTextfield = [[NSTextField alloc] init];
    self.nameTextfield.backgroundColor = NSColor.clearColor;
    [self.nameTextfield setEditable:NO];
    [self.nameTextfield setBordered:NO];
    self.nameTextfield.frame = CGRectMake(0, 5, self.frame.size.width-20, 20);
    [self addSubview:self.nameTextfield];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
