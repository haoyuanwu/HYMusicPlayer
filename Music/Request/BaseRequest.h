//
//  BaseRequest.h
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import <COCOAKit/COCOAKit.h>
#import "NSString+DES3.h"

typedef void (^completionBlock)(BOOL isSuccessful,id responceObject,HYError *error);

@interface BaseRequest : NSObject

@property (nonatomic,strong) id responceObject;

- (NSString *)serverUrl;

- (NSDictionary *)parameters;

- (BaseRequest *)requestWithObject:(id)Object;

- (void)httpRequestWithCompletion:(completionBlock)completion;

- (void)httpRequestWithFileUpdataPath:(NSURL *)fileUrl Completion:(completionBlock)completion progress:(void (^)(float value))progress;

@end
