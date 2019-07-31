//
//  UserListView.h
//  Music
//
//  Created by 吴昊原 on 2018/5/12.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void (^refreshonDataBlock)(void);

@interface UserListView : NSView

@property (weak) IBOutlet NSButton *imageV;
@property (weak) IBOutlet NSTextField *name;
@property (weak) IBOutlet NSTextField *singer;

@property (nonatomic,strong) refreshonDataBlock refreshonLineBlock;
@property (nonatomic,strong) refreshonDataBlock refreshonLocalBlock;

@end
