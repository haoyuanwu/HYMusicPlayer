//
//  NSString+DES3.m
//  DDMoney
//
//  Created by 吴昊原 on 2017/8/22.
//  Copyright © 2017年 wuhaoyuan. All rights reserved.
//

#import "NSString+DES3.h"

@implementation NSString (DES3)

/**
 字符串MD5加密
 */
- (NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 3DES加密和解密
 
 @param plainText        加密字符串
 @param encryptOrDecrypt 0 加密 1 解密
 @param key              加密的可key
 ！！！！！！！  使用此方法需要GTMBase64文件  cocoapods引用
 */
+ (NSString *)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    NSString *initVec = @"01234567";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding]
        ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

+ (NSString *)getUUID
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/sbin/ioreg"];
    
    //ioreg -rd1 -c IOPlatformExpertDevice | grep -E '(UUID)'
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: @"-rd1", @"-c",@"IOPlatformExpertDevice",nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    //NSLog (@"grep returned:n%@", string);
    
    NSString *key = @"IOPlatformUUID";
    NSRange range = [string rangeOfString:key];
    
    NSInteger location = range.location + [key length] + 5;
    NSInteger length = 32 + 4;
    range.location = location;
    range.length = length;
    
    NSString *UUID = [string substringWithRange:range];
    
    
    UUID = [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //NSLog(@"UIID:%@",UUID);
    
    return UUID;
}

@end
