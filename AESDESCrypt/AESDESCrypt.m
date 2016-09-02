//
//  AESDESCrypt.m
//  Kurrent
//
//  Created by xujun on 15/12/16.
//  Copyright © 2015年 Kurrent. All rights reserved.
//

#import "AESDESCrypt.h"

#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"

#define kAESDESCryptPasswordKey @"com.xujun.JJSwipeLockViewDemoKey"

@implementation AESDESCrypt

+ (NSString *)encryptWithText:(NSString *)plainText
{
    return [AESDESCrypt encrypt:plainText password:kAESDESCryptPasswordKey];
}

+ (NSString *)decryptWithText:(NSString *)chiperText
{
    return [AESDESCrypt decrypt:chiperText password:kAESDESCryptPasswordKey];
}

+ (NSData *)encryptWithData:(NSData *)plainData
{
    if (plainData.length == 0) return nil;
    NSData *encryptedData = [plainData AES256EncryptedDataUsingKey:[[kAESDESCryptPasswordKey dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    return encryptedData;
}
+ (NSData *)decryptWithData:(NSData *)chiperData
{
    if (chiperData.length == 0) return nil;
    NSData *encryptedData = [chiperData decryptedAES256DataUsingKey:[[kAESDESCryptPasswordKey dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    return encryptedData;
}

+ (NSData *)encryptWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    if (![jsonDictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:jsonDictionary];
    
    data = [AESDESCrypt encryptWithData:data];
    
    return data;
}

+ (NSDictionary *)decryptWithJsonChiperData:(NSData *)chiperData
{
    NSDictionary *dic = nil;
    
    if (![chiperData isKindOfClass:[NSData class]]) {
        return dic;
    }
    
    chiperData = [AESDESCrypt decryptWithData:chiperData];
    
    if (chiperData) {
        dic = [NSKeyedUnarchiver unarchiveObjectWithData:chiperData];
    }
    
    return dic;
}

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password {
    if (message.length == 0 || password.length == 0) return nil;
    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *base64EncodedString = [NSString base64StringFromData:encryptedData length:[encryptedData length]];
    return base64EncodedString;
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password {
    if (base64EncodedString.length == 0 || password.length == 0) return nil;
    NSData *encryptedData = [NSData base64DataFromString:base64EncodedString];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

@end
