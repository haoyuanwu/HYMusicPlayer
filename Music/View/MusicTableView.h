//
//  MusicTableView.h
//  Music
//
//  Created by 吴昊原 on 2018/5/25.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MusicTableView : NSView<NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic,strong) NSTableView *tableView;
@property (nonatomic,strong) NSScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *musicArr;
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,strong) void (^menuBlock)(NSInteger tag,NSArray *array,NSInteger index);

@property (nonatomic,assign) TableViewMusicListStyle musicListStyle;

@end
