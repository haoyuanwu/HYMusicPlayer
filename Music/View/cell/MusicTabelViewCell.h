//
//  MusicTabelViewCell.h
//  Music
//
//  Created by 吴昊原 on 2018/5/24.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MusicTabelViewCell : NSTableCellView

@property (nonatomic,strong) NSTextField *nameTextfield;

@property (nonatomic,assign) NSInteger index;
@property (weak) IBOutlet NSButton *moreBtn;
@property (weak) IBOutlet NSButton *updataBtn;
@property (weak) IBOutlet NSButton *downloadBtn;
@property (nonatomic,strong) MusicModel *model;
@property (nonatomic,assign) NSInteger row;
@property (weak) IBOutlet NSProgressIndicator *progressCtl;
@property (nonatomic,assign) TableViewMusicListStyle musicListStyle;

@property (nonatomic,strong) void (^uploadFileBlock)(MusicTabelViewCell *cell,MusicModel *model,NSInteger row);
@property (nonatomic,strong) void (^downloadFileBlock)(MusicTabelViewCell *cell,MusicModel *model,NSInteger row);
@property (nonatomic,strong) void (^playBlock)(MusicTabelViewCell *cell,MusicModel *model,NSInteger row);
@end
