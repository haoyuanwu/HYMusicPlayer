//
//  ViewController.m
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "ViewController.h"
#import "MusicTabelViewCell.h"
#import "MusicTableView.h"
#import "DelegateMusicApi.h"
#import "MusicListApi.h"

@interface ViewController()<NSSplitViewDelegate>
{
    NSInteger _index;
    NSString *_tmpUrl;
    NSTabViewItem *localItem;
    NSTabViewItem *lineItem;
    NSMenuItem *menuItem;
    BOOL _isUploaded;
}

@property (weak) IBOutlet BackGroundView *playBackgroundView;
@property (nonatomic,strong) MusicTableView *tableView;
@property (nonatomic,strong) MusicTableView *lineTableView;
@property (nonatomic,strong) NSTableHeaderView *headerView;
@property (nonatomic,assign) TableViewMusicListStyle musicMenuMode;
@end

@implementation ViewController

- (MusicTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MusicTableView alloc] initWithFrame: NSMakeRect(self.userListView.frame.size.width, self.playBackgroundView.frame.size.height, self.window.contentView.frame.size.width, self.window.contentView.frame.size.height - 64)];
        _tableView.musicListStyle = LocalMusicListStyle;
        _tableView.musicArr = [NSMutableArray arrayWithCapacity:1];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:musicData];
        if (data != nil) {
            _tableView.musicArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            [MusicModel sharedInstance].musicArray = _tableView.musicArr;
            [AAudioPlayerModule share].musicArr = _tableView.musicArr;
            
        }
        [_tableView.tableView reloadData];
    }
    return _tableView;
}

- (MusicTableView *)lineTableView{
    if (!_lineTableView) {
        _lineTableView = [[MusicTableView alloc] initWithFrame: NSMakeRect(self.userListView.frame.size.width, self.playBackgroundView.frame.size.height, self.window.contentView.frame.size.width, self.window.contentView.frame.size.height - 64)];
        _lineTableView.musicArr = [NSMutableArray arrayWithCapacity:1];
        _lineTableView.musicListStyle = lineMusicListStyle;
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:lineMusicData];
        if (data != nil) {
            _lineTableView.musicArr = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            [MusicModel sharedInstance].musicArray = _tableView.musicArr;
        }
        [_lineTableView.tableView reloadData];
    }
    return _lineTableView;
}



- (void)windowDidLoad {
    [super windowDidLoad];
    
    _isUploaded = YES;
    
    self.userInfoView.layer.backgroundColor = NSColor.grayColor.CGColor;
    self.userListView.layer.backgroundColor = NSColor.grayColor.CGColor;
    
    localItem = [[NSTabViewItem alloc] initWithIdentifier:@"local"];
    localItem.label = @"本地音乐";
    [localItem setView:self.tableView];
    [self.tabView addTabViewItem:localItem];
    
    lineItem = [[NSTabViewItem alloc] initWithIdentifier:@"line"];
    lineItem.label = @"在线音乐";
    [lineItem setView:self.lineTableView];
    [self.tabView addTabViewItem:lineItem];
    
    self.splitView.delegate = self;
    
    self.musicMenuMode = LocalMusicListStyle;
    
    [self viewBlockAction];

    
}

- (void)viewBlockAction{
    
    __weak typeof (self)wself = self;
    [self.tableView setMenuBlock:^(NSInteger tag, NSArray *array, NSInteger index) {
        [wself menuActionTag:tag array:array index:index];
    }];
    [self.lineTableView setMenuBlock:^(NSInteger tag, NSArray *array, NSInteger index) {
        [wself menuActionTag:tag array:array index:index];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataListStatus) name:@"playeredNSNotification" object:nil];
    
    self.userListView.refreshonLocalBlock = ^{
        wself.musicMenuMode = LocalMusicListStyle;
        [wself.tableView.tableView reloadData];
        [wself.tabView selectTabViewItemAtIndex:0];
    };
    
    self.userListView.refreshonLineBlock  = ^{
        wself.musicMenuMode = lineMusicListStyle;
        UserModel *model = [UserModel sharedInstance];
        if (model.userId != nil) {
            MusicListApi *api = [[MusicListApi alloc] initWithUserId:model.userId];
            [api httpRequestWithCompletion:^(BOOL isSuccessful, id responceObject, HYError *error) {
                if (isSuccessful) {
                    wself.lineTableView.musicArr = responceObject;
                    [wself.lineTableView.tableView reloadData];
                    [wself saveLineData];
                }else{
                    NSLog(@"%@",error.descr);
                }
                [wself.tableView.tableView reloadData];
                
            }];
            [wself.tabView selectTabViewItemAtIndex:1];
        }else{
            [wself.tableView.tableView reloadData];
            [wself.tabView selectTabViewItemAtIndex:1];
        }
    };
    
    self.navigationView.searchBarBlock = ^(NSArray *musicArr) {
        if (musicArr.count > 0) {
            self.tableView.musicArr = [NSMutableArray arrayWithArray:musicArr];
        }else{
            self.tableView.musicArr = [MusicModel sharedInstance].musicArray;
        }
        [self.tableView.tableView reloadData];
    };
}

/**
 更新播放显示信息
 */
- (void)updataListStatus{
    MusicModel *model = [AAudioPlayerModule share].model;
    NSData *imageData = [GTMBase64 decodeString:model.image];
    [self.userListView.imageV setImage:[[NSImage alloc] initWithData:imageData]];
    self.userListView.name.stringValue = model.song?model.song:@"未知";
    self.userListView.singer.stringValue = model.singer?[NSString stringWithFormat:@" -- %@",model.singer]:@" -- 未知";
    [self.playBackgroundView.playBtn setImage:[NSImage imageNamed:@"pause"]];
    
}

/// 点击某一行
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    return YES;
}

/**
 打开文件
 */
- (IBAction)UploadFile:(NSButton *)sender {
    [self openFile];
}

///+++++++++++++++++++++NSMenuItemAction ++++++++++++++++///
- (IBAction)menuOpenFile:(NSMenuItem *)sender {
    [self openFile];
}
- (IBAction)localUpdata:(NSMenuItem *)sender {
    [self openFile];
}
- (IBAction)openUpdataFile:(NSMenuItem *)sender {
    [self openFile];
}
- (IBAction)player:(NSMenuItem *)sender {
    [[AAudioPlayerModule share] playAction];
}
- (IBAction)prevMusic:(NSMenuItem *)sender {
    [[AAudioPlayerModule share] prevAction];
}
- (IBAction)nextMusic:(NSMenuItem *)sender {
    [[AAudioPlayerModule share] nextAction];
}
- (IBAction)sequencePlayer:(NSMenuItem *)sender {
    
    sender.state = NSControlStateValueOn;
    [AAudioPlayerModule share].playerModel = sequencePlayerModel;
    [self.playBackgroundView.playModelBtn setImage:[NSImage imageNamed:@"sequencePlayer"]];
}
- (IBAction)randomPlayer:(NSMenuItem *)sender {
    sender.state = NSControlStateValueOn;
    [AAudioPlayerModule share].playerModel = randomPlayerModel;
    [self.playBackgroundView.playModelBtn setImage:[NSImage imageNamed:@"randomplayer"]];
}
- (IBAction)circulationPlayer:(NSMenuItem *)sender {
    sender.state = NSControlStateValueOn;
    [AAudioPlayerModule share].playerModel = circulationPlayerModel;
    [self.playBackgroundView.playModelBtn setImage:[NSImage imageNamed:@"singleCyclePlayer"]];
}

- (IBAction)playerModelchange:(NSButton *)sender {
    if ([AAudioPlayerModule share].playerModel == sequencePlayerModel) {
        /// 随机
        [AAudioPlayerModule share].playerModel = randomPlayerModel;
        [self.playBackgroundView.playModelBtn setImage:[NSImage imageNamed:@"randomplayer"]];
    }else if ([AAudioPlayerModule share].playerModel == randomPlayerModel){
        // 单曲
        [AAudioPlayerModule share].playerModel = circulationPlayerModel;
        [self.playBackgroundView.playModelBtn setImage:[NSImage imageNamed:@"singleCyclePlayer"]];
    }else{
        // 顺序
        [AAudioPlayerModule share].playerModel = sequencePlayerModel;
        [self.playBackgroundView.playModelBtn setImage:[NSImage imageNamed:@"sequencePlayer"]];
    }
}

- (void)openFile{
    
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = YES;
    openPanel.allowsMultipleSelection = YES;
    openPanel.allowedFileTypes = @[@"mp3"];
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        
        if (result == 1) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSArray *array = [openPanel URLs];
                for (NSURL *url in array) {
                    NSError *error;
                    NSString * string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
                    if (!error) {
                        NSLog(@"%@",string);
                    }else{
                        
                    }
                }
                NSMutableArray *urlArr = [NSMutableArray arrayWithArray:array];
                for (MusicModel *model in self.tableView.musicArr) {
                    for (NSURL *url in array) {
                        if ([model.savePath isEqualToString:[url.description stringByRemovingPercentEncoding]]) {
                            [urlArr removeObject:url];
                        }
                    }
                }
                for (NSURL *url in urlArr) {
                    [self.tableView.musicArr addObject:[Function getMusicInfoUrl:url]];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self saveData];
                    [self.tableView.tableView reloadData];
                });
            });
        }
    }];
}

- (void)menuActionTag:(NSInteger)tag array:(NSArray *)musicArray index:(NSInteger)index {
    MusicModel *musicModel = self.tableView.musicArr[index];
    if (self.musicMenuMode == lineMusicListStyle) {
        musicModel = self.lineTableView.musicArr[index];
    }
    switch (tag-100) {
        case 1:
        {
            [[AAudioPlayerModule share] playerWithArr:musicArray to:index path:nil];
            [self updataListStatus];
        }
            break;
        case 2:
        {
            NSOpenPanel * openPanel = [NSOpenPanel openPanel];
            [openPanel setCanChooseDirectories:YES]; //可以打开目录
            [openPanel setCanChooseFiles:YES]; //不能打开文件(我需要处理一个目录内的所有文件)
            [openPanel setAllowedFileTypes:@[]];
            [openPanel setDirectoryURL:[NSURL fileURLWithPath:[musicModel.savePath substringFromIndex:5]]];
            [openPanel runModal];
        }
            break;
        case 3:
        {
            NSPasteboard *board = [NSPasteboard generalPasteboard];
            [board clearContents];
            [board writeObjects:@[musicModel.savePath]];
        }
            break;
        case 4:
        {
            //上传文件
            NSTableRowView *column = [self.tableView.tableView rowViewAtRow:index makeIfNecessary:YES];
            MusicTabelViewCell * cell = [column viewAtColumn:0];
            if ([Function isLogin]) {
                [cell.progressCtl setHidden:NO];
                [[MusicModel sharedInstance].downloadArray addObject:@[musicModel,cell]];
                if (_isUploaded) {
                    _isUploaded = NO;
                    [self uploadFiledActionWithModel:musicModel showfoCell:cell];
                }
            }
        }
            break;
        case 5:
        {
            if (self.musicMenuMode == lineMusicListStyle) {
                [Function showAlertMessage:@"警告" desc:@"确定要删除吗？" showInWindow:self.window completionHandler:^(NSModalResponse returnCode) {
                    if(returnCode == NSAlertFirstButtonReturn){
                        [self deleteMuiscModel:musicModel index:index];
                    }else if(returnCode == NSAlertSecondButtonReturn){
                        NSLog(@"删除");
                    }
                }];
            }
            if (musicModel.isUpdata == 0) {
                [self.tableView.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideUp];
                [self.tableView.musicArr removeObject:musicModel];
                [[MusicModel sharedInstance].musicArray removeObject:musicModel];
                [self saveData];
            }else{
                [Function showAlertMessage:@"已上传" desc:@"是要删除已上传的文件吗？" showInWindow:self.window completionHandler:^(NSModalResponse returnCode) {
                    if(returnCode == NSAlertFirstButtonReturn){
                        [self deleteMuiscModel:musicModel index:index];
                    }else if(returnCode == NSAlertSecondButtonReturn){
                        NSLog(@"删除");
                    }
                }];
            }
        }
            break;
        default:
            break;
    };
}

/**
 上传方法
 */
- (void)uploadFiledActionWithModel:(MusicModel *)musicModel showfoCell:(MusicTabelViewCell *)cell{
    
    [Function uploadFile:musicModel progress:^(float value) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.progressCtl.doubleValue = value;
        });
    } completionHandler:^(MusicModel *model) {
        [cell.progressCtl setHidden:YES];
        [self.tableView.musicArr removeObject:musicModel];
        model.isUpdata = 1;
        model.urlData = musicModel.urlData;
        [self.tableView.musicArr insertObject:model atIndex:cell.index];
        [self saveData];
        [self.tableView.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:cell.index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
        
        self->_isUploaded = YES;
//        [[MusicModel sharedInstance].downloadArray removeObjectAtIndex:0];
        
//        if ([MusicModel sharedInstance].downloadArray.count > 0) {
//            NSArray *arr = [MusicModel sharedInstance].downloadArray.firstObject;
//            MusicModel *model = arr[0];
//            MusicTabelViewCell *tmpcell = arr[1];
//            [self uploadFiledActionWithModel:model showfoCell:tmpcell];
//        }
    }];
}

- (void)deleteMuiscModel:(MusicModel *)musicModel index:(NSInteger)index{
    DelegateMusicApi *api = [[DelegateMusicApi alloc] initWithMusicId:musicModel.musicId];
    [api httpRequestWithCompletion:^(BOOL isSuccessful, id responceObject, HYError *error) {
        if (isSuccessful) {
            NSTableRowView *column = [self.tableView.tableView rowViewAtRow:index makeIfNecessary:YES];
            MusicTabelViewCell * cell = [column viewAtColumn:0];
            MusicModel *model = self.tableView.musicArr[index];
            [self.tableView.musicArr removeObject:model];
            model.isUpdata = 0;
            model.url = nil;
            model.musicId = nil;
            [self.tableView.musicArr insertObject:model atIndex:index];
            [cell.updataBtn setImage:[NSImage imageNamed:@"commit"]];
        }else{
            NSLog(@"%@",error.descr);
        }
    }];
}
/**
保存本地列表数据
 */
- (void)saveData{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[MusicModel sharedInstance].musicArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:musicData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.musicMenuMode == LocalMusicListStyle) {
        [AAudioPlayerModule share].musicArr = [MusicModel sharedInstance].musicArray;
    }else{
         
    }
    
}

/**
 保存在线音乐列表数据
 */
- (void)saveLineData{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.lineTableView.musicArr];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:lineMusicData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
    return 200;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex{
    return 200;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
