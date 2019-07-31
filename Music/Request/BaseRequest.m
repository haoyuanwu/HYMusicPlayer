//
//  BaseRequest.m
//  Music
//
//  Created by 吴昊原 on 2018/5/11.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "BaseRequest.h"
#import <Cocoa/Cocoa.h>
#import "AFNetworking.h"

@implementation BaseRequest

- (void)httpRequestWithCompletion:(completionBlock)completion{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes= [NSSet setWithObjects:@"application/json",
                                                        @"text/json",
                                                        @"text/javascript",
                                                        @"text/html",
                                                        @"text/css",
                                                        @"text/plain",
                                                        @"charset/UTF-8", nil] ;
    //如果报接受类型不一致请替换一致text/html或别的
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *uuid = [NSString getUUID];
    
    [manager.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    [manager.requestSerializer setValue:des3key forHTTPHeaderField:@"headername"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self parameters]];
    
    NSString *jsonString = [NSString dictionaryToJsonString:dict];
    //base64
    NSString *base64Json = [Base64_string encodeBase64String:jsonString];
//    md5
//    NSString *md5String = [base64Json md5];
    
    NSDictionary *parameter = @{@"koow":base64Json};
    
    //3DES
    NSString *key = [des3key stringByAppendingString:[uuid substringWithRange:NSMakeRange(0, 8)]];
    NSString *DES3Str = [NSString TripleDES:[NSString dictionaryToJsonString:parameter] encryptOrDecrypt:0 key:key];
    NSDictionary *parameters = @{@"parameters":DES3Str};
    
    [manager POST:[[self BaseURL] stringByAppendingString:[self serverUrl]] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *des3 = [[NSString alloc] initWithData:[GTMBase64 decodeData:responseObject] encoding:NSUTF8StringEncoding];
        NSString *string = [NSString TripleDES:des3 encryptOrDecrypt:1 key:key];
        
        NSDictionary *dict = [NSString dictionaryWithJsonString:string];
        if ([dict[@"code"] isEqualToString:@"1000"]) {
            NSString *reqString = dict[@"data"];
            BaseRequest *request = [self requestWithObject:reqString];
            completion(YES,request.responceObject,nil);
        }else{
            HYError *error = [[HYError alloc] init];
            error.descr = dict[@"message"];
            error.code = dict[@"code"];
            completion(NO,nil,error);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HYError *hyerror = [[HYError alloc] init];
        hyerror.descr = error.description;
        hyerror.code = [NSString stringWithFormat:@"%ld",error.code];
        completion(NO,nil,hyerror);
    }];
    
}

- (void)httpRequestWithFileUpdataPath:(NSURL *)fileUrl Completion:(completionBlock)completion progress:(void (^)(float value))progress{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *uuid = [NSString getUUID];
    
    [manager.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    [manager.requestSerializer setValue:des3key forHTTPHeaderField:@"headername"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self parameters]];
    
    NSString *jsonString = [NSString dictionaryToJsonString:dict];
    //base64
    NSString *base64Json = [Base64_string encodeBase64String:jsonString];
    //    md5
    //    NSString *md5String = [base64Json md5];
    
    NSDictionary *parameter = @{@"koow":base64Json};
    
    //3DES
    NSString *key = [des3key stringByAppendingString:[uuid substringWithRange:NSMakeRange(0, 8)]];
    NSString *DES3Str = [NSString TripleDES:[NSString dictionaryToJsonString:parameter] encryptOrDecrypt:0 key:key];
    NSDictionary *parameters = @{@"parameters":DES3Str};
    
    [manager POST:[[self BaseURL] stringByAppendingString:[self serverUrl]] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        //              application/octer-stream   audio/mpeg video/mp4   application/octet-stream
        
            /* url      :  本地文件路径
         * name     :  与服务端约定的参数
         * fileName :  自己随便命名的
         * mimeType :  文件格式类型 [mp3 : application/octer-stream application/octet-stream] [mp4 : video/mp4]
         */
        NSString *fileName  = [[fileUrl.description componentsSeparatedByString:@"/"] lastObject];
        [formData appendPartWithFileURL:fileUrl name:@"video" fileName:fileName mimeType:@"application/octet-stream" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        float value = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        progress(value);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"上传成功 %@",responseObject);
        NSString *des3 = [[NSString alloc] initWithData:[GTMBase64 decodeData:responseObject] encoding:NSUTF8StringEncoding];
        NSString *string = [NSString TripleDES:des3 encryptOrDecrypt:1 key:key];
        
        NSDictionary *dict = [NSString dictionaryWithJsonString:string];
        if ([dict[@"code"] isEqualToString:@"1000"]) {
            NSString *reqString = dict[@"data"];
            BaseRequest *request = [self requestWithObject:reqString];
            completion(YES,request.responceObject,nil);
        }else{
            HYError *error = [[HYError alloc] init];
            error.descr = dict[@"message"];
            error.code = dict[@"code"];
            completion(NO,nil,error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@",error);
    }];
    
}

- (NSString *)BaseURL {
    return BaseUrl;
}

- (NSString *)serverUrl {
    return @"";
}

- (NSDictionary *)parameters{
    return @{};
}

- (BaseRequest *)requestWithObject:(id)Object{
    return [BaseRequest new];
}

@end
