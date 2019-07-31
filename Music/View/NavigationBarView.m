//
//  NavigationBarView.m
//  Music
//
//  Created by 吴昊原 on 2018/6/4.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "NavigationBarView.h"
#import <UIImageView+WebCache.h>
#import "LoginApi.h"
#import "EquailzerWindow.h"

@interface NavigationBarView()<NSSearchFieldDelegate>
@property (nonatomic,strong)EquailzerWindow *equalizerWindow;

@end

@implementation NavigationBarView

- (EquailzerWindow *)equalizerWindow{
    if (!_equalizerWindow) {
        
        NSNib *nib = [[NSNib alloc] initWithNibNamed:@"EquailzerWindow" bundle:[NSBundle mainBundle]];
        if (nib)
        {
            NSArray *objs = nil;
            BOOL flag = NO;
#if __MAC_10_8
            flag = [nib instantiateWithOwner:self topLevelObjects:&objs];
#else
            flag = [nib instantiateNibWithOwner:self topLevelObjects:&objs];
#endif
            if (flag && objs)
            {
                for (NSObject *obj in objs)
                {
                    if ([obj isKindOfClass:[EquailzerWindow class]])
                    {
                        _equalizerWindow = (EquailzerWindow *)obj;
                        _equalizerWindow.title = @"均衡器";
                        
                        return _equalizerWindow;
                    }
                }
            }
        }
    }
    return _equalizerWindow;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadUserInfo) name:loginNotificationName object:nil];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userlogin"];
    if (!dict) {
        
    }else{
        [self loginName:dict[@"name"] pwd:dict[@"pwd"]];
    }
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:^NSEvent * _Nullable(NSEvent * _Nonnull aEvent) {
        [self keyDown:aEvent];
        
        if (aEvent.window == self.LoginPanel && [aEvent.characters isEqualToString:@"\r"]) {
            [self loginAction:self.loginBtn];
        }
        NSString *key = [aEvent.characters stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];

        if ([aEvent.window.firstResponder isKindOfClass:[NSTextView class]] && [key isEqualToString:@"%0D"]) {
            
            NSArray *musicArr = [AAudioPlayerModule share].musicArr;
            NSMutableArray *songArr = [[NSMutableArray alloc] initWithCapacity:1];
            NSMutableArray *singArr = [[NSMutableArray alloc] initWithCapacity:1];
            for (MusicModel *model in musicArr) {
                if ([model.song containsString:self.searchField.stringValue]) {
                    [songArr addObject:model];
                }
            }
            for (MusicModel *model in musicArr) {
                if ([model.singer containsString:self.searchField.stringValue]) {
                    [singArr addObject:model];
                }
            }
            [songArr addObjectsFromArray:singArr];

            if (self.searchBarBlock) {
                self.searchBarBlock(songArr);
            }
        }
        
        return aEvent;
    }];
    
    if (@available(macOS 10.11, *)) {
        self.searchField.delegate = self;
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)uploadUserInfo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        UserModel *model = [UserModel sharedInstance];
        NSString *pic = @"http://aipai.sina.com.cn/activity/detail/510/";//model.portrait;
        NSURL *picUrl = [NSURL URLWithString:pic];
        NSData *data = [NSData dataWithContentsOfURL:picUrl];
        NSImage *image = [[NSImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.portrait setImage:image];
        });
    });
}

- (IBAction)login:(NSButton *)sender{
    if ([sender.title isEqualToString:@"注销"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userlogin"];
        [sender setTitle:@"登录"];
        UserModel *model = [UserModel sharedInstance];
        model = nil;
    }else if ([sender.title isEqualToString:@"登录"]){
        [self.window beginSheet:self.LoginPanel completionHandler:^(NSModalResponse returnCode) {
            if (returnCode == NSModalResponseAbort) {
                [self loginName:self.userName.stringValue pwd:self.pwdTextFile.stringValue];
            }
        }];
    }
}

- (void)loginName:(NSString *)name pwd:(NSString *)pwd{
    LoginApi *api = [[LoginApi alloc] initWithPhone:name pwd:pwd];
    [api httpRequestWithCompletion:^(BOOL isSuccessful, id responceObject, HYError *error) {
        if (isSuccessful) {
            if (![self.userName.stringValue isEqualToString:@""]) {
                NSDictionary *dict = @{@"name":self.userName.stringValue,@"pwd":self.pwdTextFile.stringValue};
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userlogin"];
            }
            [self.loginBtn setTitle:@"注销"];
        }else{
//            [FuncTools showAlertWarningWithTitle:@"发生错误" msg:error.descr];
        }
    }];
}
- (IBAction)openEqualizer:(NSButton *)sender {
    
    [self.equalizerWindow makeKeyAndOrderFront:self];
    [self.equalizerWindow orderFront:self];
    
}

- (IBAction)closeLogin:(NSButton *)sender {
    [self.window endSheet:self.LoginPanel];
    self.userName.stringValue = @"";
    self.pwdTextFile.stringValue = @"";
}

- (IBAction)loginAction:(NSButton *)sender {
    LoginApi *api = [[LoginApi alloc] initWithPhone:self.userName.stringValue pwd:self.pwdTextFile.stringValue];
    [api httpRequestWithCompletion:^(BOOL isSuccessful, id responceObject, HYError *error) {
        if (isSuccessful) {
            [[NSNotificationCenter defaultCenter] postNotificationName:loginNotificationName object:nil];
            [self.window endSheet:self.LoginPanel returnCode:(NSModalResponseAbort)];
        }
    }];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)searchField:(NSSearchField *)sender {
    if ([sender.stringValue isEqualToString:@""]) {
        if (self.searchBarBlock) {
            self.searchBarBlock(@[]);
        }
    }
}

@end
