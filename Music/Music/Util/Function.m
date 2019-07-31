//
//  Function.m
//  Music
//
//  Created by 吴昊原 on 2018/5/25.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "Function.h"

@implementation Function

+ (MusicModel *)getMusicInfoUrl:(NSURL *)url {
    
    MusicModel *model = [[MusicModel alloc] init];
    NSDate *date = [NSDate date];
    model.creatDate = [date stringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *filePath = [url.description stringByRemovingPercentEncoding];
    model.savePath = filePath;
    NSLog(@"%@",filePath);
    
    NSData *urlData = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:nil];
    if (urlData == nil) {
        urlData = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:nil];
    }
    model.urlData = urlData;
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:nil];
    model.fileSize = [NSString stringWithFormat:@"%.2fMB",(CGFloat)fileAttributes.fileSize/1000/1000];
    
    NSString *fileName = [filePath componentsSeparatedByString:@"/"].lastObject;
    NSString *nameStr = [fileName componentsSeparatedByString:@"."].firstObject;
    model.song = nameStr;
    
    
    //文件管理，取得文件属性
    NSDictionary *dictAtt = [[NSFileManager defaultManager] attributesOfItemAtPath:[url path] error:nil];
    
    //取得音频数据
    AVURLAsset *mp3Asset=[AVURLAsset URLAssetWithURL:url options:nil];
    
    NSString *singer;//歌手
    NSString *song;//歌曲名
    //    NSImage *image;//图片
    NSString *albumName;//专辑名
    NSString *fileSize;//文件大小
    NSString *voiceStyle;//音质类型
    NSString *fileStyle;//文件类型
    NSString *creatDate;//创建日期
    NSString *savePath; //存储路径
    
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            if([metadataItem.commonKey isEqualToString:@"title"]){
                song = (NSString *)metadataItem.value;//歌曲名
                model.song = song;
                NSLog(@"歌曲名称:%@",song);
            }else if ([metadataItem.commonKey isEqualToString:@"artist"]){
                singer = (NSString *)metadataItem.value;//歌手
                model.singer = singer;
                NSLog(@"歌手:%@",singer);
            }
            //            专辑名称
            else if ([metadataItem.commonKey isEqualToString:@"albumName"])
            {
                albumName = (NSString *)metadataItem.value;
                model.albumName = albumName;
            }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                
                model.image = [((NSData *)metadataItem.value) base64EncodedStringWithOptions:(NSDataBase64EncodingEndLineWithLineFeed)];
                
            }
            
            savePath = filePath;
            if (dictAtt != nil) {
                float tempFlo = [[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024);
                fileSize = [NSString stringWithFormat:@"%.2fMB",[[dictAtt objectForKey:@"NSFileSize"] floatValue]/(1024*1024)];
                model.fileSize = fileSize;
                NSLog(@"文件大小：%@",fileSize);
                NSString *tempStrr  = [NSString stringWithFormat:@"%@", [dictAtt objectForKey:@"NSFileCreationDate"]] ;
                
                creatDate = [tempStrr substringToIndex:19];
                fileStyle = [filePath substringFromIndex:[filePath length]-3];
                NSLog(@"文件格式：%@",fileStyle);
                model.fileStyle = fileStyle;
                if(tempFlo <= 2){
                    voiceStyle = @"普通";
                }else if(tempFlo > 2 && tempFlo <= 5){
                    voiceStyle = @"良好";
                }else if(tempFlo > 5 && tempFlo < 10){
                    voiceStyle = @"标准";
                }else if(tempFlo > 10){
                    voiceStyle = @"高品质";
                }
                model.voiceStyle = voiceStyle;
                NSLog(@"文件品质：%@",voiceStyle);
                
                if (![model.fileStyle isEqualToString:@"mp3"]) {
                    NSString *fileNames = [filePath componentsSeparatedByString:@"/"].lastObject;
                    model.singer = [fileNames componentsSeparatedByString:@" - "].firstObject;
                    NSString *songName = [fileNames componentsSeparatedByString:@" - "].lastObject;
                    model.song = [songName substringWithRange:(NSMakeRange(0, songName.length - 5))];
                } 
            }
        }
    }
    if (!model.fileStyle || [model.fileStyle isEqualToString:@""]) {
        model.fileStyle = @"mp3";
    }
    
    return model;
}

+ (BOOL)isLogin{
    UserModel *model = [UserModel sharedInstance];
    if (![model.userId isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)showAlertMessage:(NSString *)message desc:(NSString *)desc showInWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse returnCode))completionHandler{
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:message];
    [alert setInformativeText:desc];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
        completionHandler(returnCode);
    }];
}

/**
 上传文件
 */
+ (void)uploadFile:(MusicModel *)model progress:(void(^)(float value))progress completionHandler:(void (^)(MusicModel *model))completionHandler{
    NSURL *url =  [NSURL URLByResolvingBookmarkData:model.urlData options:NSURLBookmarkResolutionWithSecurityScope|NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:nil error:nil];
    // 开启权限
    [url startAccessingSecurityScopedResource];
    
    UploadFileApi *api =  [[UploadFileApi alloc] initWithSong:model.song singer:model.singer image:model.image albumName:model.albumName fileSize:model.fileSize voiceStyle:model.voiceStyle fileStyle:model.fileStyle  savePath:model.savePath pid:[UserModel sharedInstance].userId];
    [api httpRequestWithFileUpdataPath:url Completion:^(BOOL isSuccessful, id responceObject, HYError *error) {
        if (isSuccessful) {
            completionHandler(responceObject);
        }else{
            NSLog(@"%@",error.description);
            completionHandler(responceObject);
        }
    } progress:^(float value) {
        NSLog(@"上传进度%f",value);
        progress(value);
    }];
}

@end
