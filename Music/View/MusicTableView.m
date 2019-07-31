
//
//  MusicTableView.m
//  Music
//
//  Created by 吴昊原 on 2018/5/25.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "MusicTableView.h"
#import "MusicTabelViewCell.h"
#import "MusicRowView.h"
#import "DelegateMusicApi.h"
#import "MusicTableCell.h"

@interface MusicTableView()<NSTableViewDelegate,NSTableViewDataSource>
{
    NSMenuItem *item1;
    NSMenuItem *item2;
    NSMenuItem *item3;
    NSMenuItem *item4;
    NSMenuItem *item5;
    NSMenu *menu;
    
    NSInteger _index;
    NSInteger tmpIndex;
    
}

@end

@implementation MusicTableView

- (NSScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[NSScrollView alloc] initWithFrame:self.window.contentView.frame];
        _scrollView.hasVerticalScroller = YES;
        _scrollView.hasHorizontalScroller = YES;
        [_scrollView setFocusRingType:(NSFocusRingTypeNone)];
        [_scrollView setAutohidesScrollers:YES];
        [_scrollView setBorderType: NSBezelBorder];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView setDocumentView:self.tableView];
    }
    return _scrollView;
}

-(NSTableView *)tableView{
    if (!_tableView) {
        _tableView = [[NSTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTarget:self];
        
        [_tableView setDoubleAction:@selector(tableDoubleAction)];
        [_tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MusicTableViewCell" bundle:nil] forIdentifier:@"Columnid"];
        [_tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MusicTableCell" bundle:nil]forIdentifier:@"Coulumnid2"];
        [_tableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
        
        
        NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"name"];
        NSTableColumn *column2 = [[NSTableColumn alloc] initWithIdentifier:@"personName"];
        NSTableColumn *column3 = [[NSTableColumn alloc] initWithIdentifier:@"album"];
        NSTableColumn *column4 = [[NSTableColumn alloc] initWithIdentifier:@"size"];
        
        [column1 setTitle:@"歌名"];
        [column2 setTitle:@"歌手"];
        [column3 setTitle:@"专辑名"];
        [column4 setTitle:@"大小"];
        [column1 setWidth:240];
        [column2 setWidth:180];
        [column3 setWidth:180];
        [column4 setWidth:80];
        
        [_tableView addTableColumn:column1];
        [_tableView addTableColumn:column2];
        [_tableView addTableColumn:column3];
        [_tableView addTableColumn:column4];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
    
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
        }];
        
        tmpIndex = CGFLOAT_MAX;
        
        self.menu = [[NSMenu alloc] init];
        item1 = [[NSMenuItem alloc] initWithTitle:@"播放" action:@selector(rightMenu:) keyEquivalent:@""];
        item2 = [[NSMenuItem alloc] initWithTitle:@"从Finder打开" action:@selector(rightMenu:) keyEquivalent:@""];
        item3 = [[NSMenuItem alloc] initWithTitle:@"复制链接" action:@selector(rightMenu:) keyEquivalent:@""];
        item4 = [[NSMenuItem alloc] initWithTitle:@"上传" action:@selector(rightMenu:) keyEquivalent:@""];
        item5 = [[NSMenuItem alloc] initWithTitle:@"删除" action:@selector(rightMenu:) keyEquivalent:@""];
        item1.tag = 101;
        item2.tag = 102;
        item3.tag = 103;
        item4.tag = 104;
        item5.tag = 105;
        [self.menu addItem:item1];
        [item1 setKeyEquivalentModifierMask:NSEventModifierFlagShift];
        [self.menu addItem:item2];
        [self.menu addItem:item3];
        [self.menu addItem:item4];
        [self.menu addItem:item5];
        
        
        [self.tableView.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top).with.offset(0);
            make.left.equalTo(self.tableView.mas_left).with.offset(0);
        }];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.musicArr.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return  nil;
}

- (CGFloat)tableView:(NSTableView *)tableView sizeToFitWidthOfColumn:(NSInteger)column{
    return  20;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return  30;
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
    
    NSTableRowView *cell = [tableView makeViewWithIdentifier:@"row" owner:self];
    if (cell == nil) {
        cell = [[MusicRowView alloc] init];
        cell.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        cell.identifier = @"row";
    }
    _index = 0;
    return cell;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    MusicModel *musicModel = self.musicArr[row];
    NSString *identfiter = tableColumn.identifier;
    MusicTableCell *view;
    MusicTabelViewCell *columnView;
    if (([identfiter isEqualToString:@"name"])) {
        view = [tableView makeViewWithIdentifier:@"Columnid" owner:self];
        columnView = (MusicTabelViewCell *)view;
        columnView.index = row;
        columnView.musicListStyle = self.musicListStyle;
        columnView.model = musicModel;
        columnView.row = row;
        __weak typeof (self)wself = self;
        columnView.downloadFileBlock = ^(MusicTabelViewCell *cell, MusicModel *model, NSInteger row) {
            // 下载
        };
        columnView.uploadFileBlock = ^(MusicTabelViewCell *cell, MusicModel *model, NSInteger row) {
            // 上传文件
            if ([Function isLogin]) {
                if (model.isUpdata != 1) {
                    if (self.menuBlock) {
                        self.menuBlock(104, self.musicArr,row);
                    }
                }else{
                    if (self.menuBlock) {
                        self.menuBlock(105,self.musicArr, row);
                    }
                }
            }
        };
        columnView.playBlock = ^(MusicTabelViewCell *cell, MusicModel *model, NSInteger row) {
            wself.row = row;
            [wself rightMenu:self->item1];
        };
    }else{
        view = [tableView makeViewWithIdentifier:@"Coulumnid2" owner:self];
    }
    
    NSTextField *textfield;
    textfield = view.nameTextfield;
    
    switch (_index) {
        case 0:
            textfield.stringValue = musicModel.song?musicModel.song:@"";
            break;
        case 1:
            textfield.stringValue = musicModel.singer?musicModel.singer:@"未知";
            break;
        case 2:
            textfield.stringValue = musicModel.albumName?musicModel.albumName:@"未知";
            break;
        case 3:
            textfield.stringValue = musicModel.fileSize;
            break;
        default:
            break;
    }
    _index += 1;
    
    return view;
}

-(NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation{
    if (self.musicListStyle == LocalMusicListStyle) {
        return NSDragOperationEvery;
    }else{
        return NSDragOperationNone;
    }
    
}

-(BOOL)tableView:(NSTableView *)tableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation{
    
    
    NSPasteboard *pasteBoard = [info draggingPasteboard];
    
    if ([[pasteBoard types]containsObject:NSFilenamesPboardType]) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            NSArray *arrayURL = [pasteBoard propertyListForType:NSFilenamesPboardType];
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:1];
            for (NSString *strURL in arrayURL) {
                
                NSURL *URL = [NSURL fileURLWithPath:strURL];
                [array addObject:URL];

            }
            if ([[pasteBoard types]containsObject:NSFilenamesPboardType]) {
                
                NSMutableArray *urlArr = [NSMutableArray arrayWithArray:array];
                for (MusicModel *model in self.musicArr) {
                    for (NSURL *url in array) {
                        if ([model.savePath isEqualToString:[url.description stringByRemovingPercentEncoding]]) {
                            [urlArr removeObject:url];
                        }
                    }
                }
                for (NSURL *url in urlArr) {
                    [self.musicArr insertObject:[Function getMusicInfoUrl:url] atIndex:row];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self saveData];
                    if (urlArr.count > 0) {
                        [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row] withAnimation:(NSTableViewAnimationSlideUp)];
                    }
                    [self.tableView reloadData];
                });
            }
        });
    
        return YES;
    }else{
        return NO;
    }
    
}

- (void)saveData{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.musicArr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:musicData];
}

- (void)rightMouseDown:(NSEvent *)event{
    [[self window] makeFirstResponder:self];
    
    NSPoint tablePoint = [self.tableView convertPoint:[event locationInWindow] fromView:nil];
    self.row = [self.tableView rowAtPoint:tablePoint];
    [self.tableView deselectRow:self.tableView.selectedRow];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.row] byExtendingSelection:YES];
    if (self.row >= 0) {
        [self.menu popUpMenuPositioningItem:item1 atLocation:tablePoint inView:self.tableView];
    }
    
}

/**
 双击方法
 */
- (void)tableDoubleAction{
    if (self.tableView.selectedRow >= 0) {
        
//        MusicModel *model = self.musicArr[self.tableView.selectedRow];
//
//        NSURL *url =  [NSURL URLByResolvingBookmarkData:model.urlData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:nil error:nil];
//        // 开启权限
//        [url startAccessingSecurityScopedResource];
//        [QSAAudioPlayer.shared playWithStartTime:0 endTime:0 path:url];
        [[AAudioPlayerModule share] playerWithArr:self.musicArr to:self.tableView.selectedRow path:nil];
    }
}

- (void)rightMenu:(NSMenuItem *)item{
    if (self.menuBlock) {
        self.menuBlock(item.tag,self.musicArr,self.row);
    }
}

@end
