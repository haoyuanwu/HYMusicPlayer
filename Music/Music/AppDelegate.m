//
//  AppDelegate.m
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()<NSWindowDelegate>

@property (nonatomic,strong) NSWindow *window;
@property (nonatomic,strong) ViewController *viewController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.window = [NSApp windows].firstObject;
    self.window.delegate = self;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:musicData];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:lineMusicData];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EqualizerArr];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:EqualizerDic];
    
    self.viewController = [[ViewController alloc] initWithWindowNibName:@"ViewController"];
    [self.viewController.window center];
    [self.viewController.window orderFront:self];
    
    [[AAudioPlayerModule share] startEngine];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if (flag == NO) {
        [self.viewController.window makeKeyAndOrderFront:self];
    }
    return true;
}

@end
