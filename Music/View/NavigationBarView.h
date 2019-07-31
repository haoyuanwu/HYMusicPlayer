//
//  NavigationBarView.h
//  Music
//
//  Created by 吴昊原 on 2018/6/4.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NavigationBarView : NSView

@property (weak) IBOutlet NSButton *loginBtn;
@property (weak) IBOutlet NSSecureTextField *pwdTextFile;
@property (weak) IBOutlet NSTextField *userName;
  
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSButton *portrait;
@property (strong) IBOutlet NSPanel *LoginPanel;

@property (nonatomic,strong)void (^searchBarBlock)(NSArray *musicArr);

@end
