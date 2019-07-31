//
//  Function.h
//  Music
//
//  Created by 吴昊原 on 2018/5/25.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject

+ (MusicModel *)getMusicInfoUrl:(NSURL *)url;
+ (void)uploadFile:(MusicModel *)model progress:(void(^)(float value))progress completionHandler:(void (^)(MusicModel *model))completionHandler;
+ (BOOL)isLogin;
+ (void)showAlertMessage:(NSString *)message desc:(NSString *)desc showInWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse returnCode))completionHandler;
@end
