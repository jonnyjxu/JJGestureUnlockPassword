//
//  AESDESCrypt.h
//  Kurrent
//
//  Created by xujun on 15/12/16.
//  Copyright © 2015年 Kurrent. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface AESDESCrypt : NSObject

///文字加解密
+ (NSString *)encryptWithText:(NSString *)plainText;
+ (NSString *)decryptWithText:(NSString *)chiperText;

//数据加解密
+ (NSData *)encryptWithData:(NSData *)plainData;
+ (NSData *)decryptWithData:(NSData *)chiperData;

///字典加解密
+ (NSData *)encryptWithJsonDictionary:(NSDictionary *)jsonDictionary;
+ (NSDictionary *)decryptWithJsonChiperData:(NSData *)chiperData;

///自定义密钥 加密文字
+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;
+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
