//
//  UploadFileApi.h
//  Music
//
//  Created by 吴昊原 on 2018/5/12.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadFileApi : BaseRequest

- (instancetype)initWithSong:(NSString *)song singer:(NSString *)singer image:(NSString *)image albumName:(NSString *)albumName fileSize:(NSString *)fileSize voiceStyle:(NSString *)voiceStyle fileStyle:(NSString *)fileStyle savePath:(NSString *)savePath pid:(NSString *)pid;

@end
