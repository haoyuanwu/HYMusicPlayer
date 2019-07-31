//
//  UserListView.m
//  Music
//
//  Created by 吴昊原 on 2018/5/12.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "UserListView.h"
#import "LoginApi.h"
#import "ListViewModel.h"
#import "UserListRowView.h"
#import "UserlistRowMenu.h"
#import "MusicListApi.h"
#import "UserListCellView.temp_caseinsensitive_rename.h"

@interface UserListView()<NSOutlineViewDelegate,NSOutlineViewDataSource>
{
    NSMutableArray *dataArr;
    NSTableRowView *rowView;
}
@property (nonatomic,strong) NSScrollView *scrollView;
@property (weak) IBOutlet  NSOutlineView *outlineView;
@end

@implementation UserListView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.backgroundColor = NSColor.whiteColor.CGColor;
    
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.masksToBounds = YES;
    
    dataArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0 ; i<2; i++) {
        ListViewModel *model = [[ListViewModel alloc] init];
        model.title = @[@"歌曲管理",@"用户"][i];
        model.array = @[@[@"本地列表",@"网络列表",@"下载列表"],@[@"个人信息",@"设置"]][i];
        [dataArr addObject:model];
    }
    [self.outlineView reloadData];
    
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if (!item) {
        return dataArr.count;
    }else{
        ListViewModel *model = item;
        return model.array.count;
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if (!item) {
        return dataArr[index];
    }else{
        ListViewModel *model = item;
        return model.array[index];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    if (!item) {
        return YES;
    }else{
        if ([item isKindOfClass:[ListViewModel class]]) {
            ListViewModel *model = item;
            if (model.array.count>0) {
                return YES;
            }
            return NO;
        }else{
            return NO;
        }
    }
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView sizeToFitWidthOfColumn:(NSInteger)column{
    return  25;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
    if ([item isKindOfClass:[ListViewModel class]]) {
        return 25;
    }else{
        return 30;
    }
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item{
    
    NSTableRowView *row;
    ListViewModel *model = item;
    if ([item isKindOfClass:[ListViewModel class]]) {
        UserListRowView *view = [[UserListRowView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        view.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        view.textfield.stringValue = model.title;
        row = view;
    }else{
        UserlistRowMenu *menu = [[UserlistRowMenu alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        menu.textfield.stringValue = item;
        menu.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        row = menu;
    }
    return row;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    return @"";
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    UserListCellView *view = (UserListCellView *)[outlineView makeViewWithIdentifier:tableColumn.identifier owner:self];
    if (!view) {
        view = [[UserListCellView alloc] initWithFrame:CGRectMake(0, 0, outlineView.frame.size.width, 30)];
    }
    return  view;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item{
    NSCell *cell = [tableColumn dataCell];
    
    return  cell;
    
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification{
    
    switch (self.outlineView.selectedRow) {
        case 1:
        {
            if (self.refreshonLocalBlock) {
                self.refreshonLocalBlock();
            }
        }
            break;
        case 2:
        {
            if (self.refreshonLineBlock) {
                self.refreshonLineBlock();
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    UserlistRowMenu *view;
    if (outlineView.clickedRow > 0) {
        view = [outlineView rowViewAtRow:outlineView.clickedRow makeIfNecessary:YES];
        if ([view isKindOfClass:[UserlistRowMenu class]]) {
            if (rowView) {
                rowView.layer.backgroundColor = NSColor.clearColor.CGColor;
            }
            view.layer.backgroundColor = NSColor.grayColor.CGColor;
            rowView = view;
        }
        return YES;
    }else{
        return NO;
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    self.wantsLayer = YES;
    
    
    // Drawing code here.
}

@end
