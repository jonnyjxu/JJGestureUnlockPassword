//
//  JJSwipePasswordData.m
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import "JJSwipePasswordData.h"
#import "UICKeyChainStore.h"
#import "AESDESCrypt.h"


#define kLoginVIPInfoIdentifier @"com.xujun.loginVIPInfoIdentifier"
#define kSwipePasswordDataKey   @"SwipePasswordDataKey"

static JJSwipePasswordData *__g_userPrivateInfo__;
@interface JJSwipePasswordData ()
@property (nonatomic,strong) NSDate *lastModifyDate;
@end

@implementation JJSwipePasswordData

+ (instancetype)share
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __g_userPrivateInfo__ = [JJSwipePasswordData readLoginVIPInfo];
    });
    return __g_userPrivateInfo__;
}

+ (void)_updateSwipePasswordData:(JJSwipePasswordData *)pwdData
{
    //[_UserPrivateInfo _updateLoginVIPInf:pwdData];
    __g_userPrivateInfo__ = pwdData;
}

///这个函数 自己用别的开源库 替换吧  就不引入了
- (NSDictionary *)jsonDictionary
{
    return @{@"type":@(_type),
             @"password":_password ?:@"",
             @"failedCounter":@(_failedCounter),
             @"password":_lastModifyDate ?:@"",};
}


+ (void)saveSwipePasswordData:(JJSwipePasswordData *)pwdData
{
    [pwdData save];
}

- (void)save
{
    self.lastModifyDate = [NSDate date];
    [JJSwipePasswordData _updateSwipePasswordData:self];
    
    NSData *data = [AESDESCrypt encryptWithJsonDictionary:self.jsonDictionary];
    
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:kLoginVIPInfoIdentifier];
    [keyChain setData:data ? : [NSData new] forKey:kSwipePasswordDataKey];
}

+ (void)deleteLoginVIPInf
{
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:kLoginVIPInfoIdentifier];
    [keyChain removeItemForKey:kSwipePasswordDataKey];
}

+ (JJSwipePasswordData *)readLoginVIPInfo
{
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:kLoginVIPInfoIdentifier];
    NSData *data = [keyChain dataForKey:kSwipePasswordDataKey];
    NSDictionary *dic = [AESDESCrypt decryptWithJsonChiperData:data];
    
    ///这个函数 自己用别的开源库 替换吧  就不引入了
    JJSwipePasswordData *pwdData = [JJSwipePasswordData new];
    pwdData.type =  [dic[@"type"] integerValue];
    pwdData.password =  dic[@"password"];
    pwdData.failedCounter =  [dic[@"failedCounter"] integerValue];
    pwdData.lastModifyDate = dic[@"lastModifyDate"];
    
    return pwdData;//[LoginVIPInf objectWithKeyValues:dic];
}

- (void)setPassword:(NSString *)password
{
    _password = [AESDESCrypt encryptWithText:password];
}


@end
