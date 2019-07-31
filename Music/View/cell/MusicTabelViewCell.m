//
//  MusicTabelViewCell.m
//  Music
//
//  Created by 吴昊原 on 2018/5/24.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "MusicTabelViewCell.h"
#import "MusicTableView.h"

@interface MusicTabelViewCell()
{
    NSMenuItem *item1;
    NSMenuItem *item2;
    NSMenuItem *item3;
    NSMenuItem *item4;
    
    NSMenu *menu;
}

@end

@implementation MusicTabelViewCell

- (void)setModel:(MusicModel *)model{
    
    _model = model;
    self.nameTextfield.stringValue = model.song?model.song:@"";
    if (self.musicListStyle != lineMusicListStyle) {
        [self.downloadBtn setImage:[NSImage imageNamed:@"notDownload"]];
        [self.downloadBtn setEnabled:NO];
        [self.updataBtn setImage:[NSImage imageNamed:@"commit"]];
    }else{
        [self.downloadBtn setImage:[NSImage imageNamed:@"download"]];
        [self.updataBtn setImage:[NSImage imageNamed:@"notcCommit"]];
        [self.updataBtn setEnabled:NO];
    }
    if (model.isUpdata == 1) {
        [self.updataBtn setImage:[NSImage imageNamed:@"commited"]];
        [self.updataBtn setHidden:NO];
    }else{
        [self.updataBtn setImage:[NSImage imageNamed:@"commit"]];
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    //监听鼠标悬浮状态  一定要加上NSTrackingActiveInKeyWindow
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:CGRectMake(0, 0, self.frame.size.width, 30) options:NSTrackingActiveInKeyWindow | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved owner:self userInfo:nil]];
    
    [self.moreBtn setHidden:YES];
    [self.updataBtn setHidden:YES];
    [self.downloadBtn setHidden:YES];
    [self.progressCtl setHidden:YES];
    self.progressCtl.maxValue = 1;
    self.progressCtl.minValue = 0;
    
    self.menu = [[NSMenu alloc] init];
    item1 = [[NSMenuItem alloc] initWithTitle:@"播放" action:@selector(rightMenu:) keyEquivalent:@""];
    item2 = [[NSMenuItem alloc] initWithTitle:@"从Finder打开" action:@selector(rightMenu:) keyEquivalent:@""];
    item3 = [[NSMenuItem alloc] initWithTitle:@"复制链接" action:@selector(rightMenu:) keyEquivalent:@""];
    item4 = [[NSMenuItem alloc] initWithTitle:@"上传" action:@selector(rightMenu:) keyEquivalent:@""];
    item1.tag = 101;
    item2.tag = 102;
    item3.tag = 103;
    item4.tag = 104;
    [self.menu addItem:item1];
    [item1 setKeyEquivalentModifierMask:NSShiftKeyMask];
    [self.menu addItem:item2];
    [self.menu addItem:item3];
    [self.menu addItem:item4];
    
    self.nameTextfield = [[NSTextField alloc] init];
    self.nameTextfield.backgroundColor = NSColor.clearColor;
    [self.nameTextfield setEditable:NO];
    [self.nameTextfield setBordered:NO];
    self.nameTextfield.frame = CGRectMake(10, 5, self.frame.size.width-20, 20);
    [self addSubview:self.nameTextfield];
}

- (void)rightMenu:(NSMenuItem *)item{
    
}

- (IBAction)openMore:(NSButton *)sender {
    
    NSTableView *tableView = (NSTableView *)self.superview.superview;
    
//    CGPoint point = [NSEvent mouseLocation];
    
    CGRect tableRect = [self convertRect:sender.frame toView:tableView];
    self.row = [tableView rowAtPoint:tableRect.origin];
    
    [tableView deselectRow:tableView.selectedRow];
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.row] byExtendingSelection:YES];
    
    if (self.playBlock) {
        self.playBlock(self,self.model,self.row);
    }
}

- (IBAction)commitFile:(NSButton *)sender {
    if (self.uploadFileBlock) {
        self.uploadFileBlock(self,self.model, self.row);
    }
}

- (IBAction)downloadFile:(NSButton *)sender {
    if (self.downloadFileBlock) {
        self.downloadFileBlock(self,self.model, self.row);
    }
}

- (void)mouseEntered:(NSEvent *)event{
    [self.moreBtn setHidden:NO];
    [self.updataBtn setHidden:NO];
    [self.downloadBtn setHidden:NO];
    self.nameTextfield.frame = CGRectMake(10, 5, self.moreBtn.frame.origin.x - 20, 20);
}

- (void)mouseExited:(NSEvent *)event{
    if (self.model.isUpdata != 1) {
        [self.updataBtn setHidden:YES];
    }
    [self.moreBtn setHidden:YES];
    [self.downloadBtn setHidden:YES];
    self.nameTextfield.frame = CGRectMake(10, 5, self.frame.size.width-self.progressCtl.frame.size.width - 20, 20);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
