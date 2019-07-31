//
//  ViewController.h
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UserListView.h"
#import "NavigationBarView.h"

@interface ViewController : NSWindowController

@property (weak) IBOutlet UserListView *userListView;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *userInfoView;
@property (weak) IBOutlet NSView *rightView;
@property (weak) IBOutlet NavigationBarView *navigationView;
@property (weak) IBOutlet NSView *leftView;


@property (weak) IBOutlet NSTabView *tabView;



@end

