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


#define kSwipePasswordDataIdentifier @"com.xujun.swipePasswordDataIdentifier"
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
        __g_userPrivateInfo__ = [JJSwipePasswordData readSwipePasswordData];
    });
    return __g_userPrivateInfo__;
}

+ (void)_updateSwipePasswordData:(JJSwipePasswordData *)pwdData
{
    //[_UserPrivateInfo _updateLoginVIPInf:pwdData];
    __g_userPrivateInfo__ = pwdData;
}

- (id)init
{
    if (self = [super init]) {
        self.showLineGesture = YES;
    }
    return self;
}

///这个函数 自己用别的开源库 替换吧  就不引入了
- (NSDictionary *)jsonDictionary
{
    return @{@"type":@(_type),
             @"password":_password ?:@"",
             @"failedCounter":@(_failedCounter),
             @"password":_lastModifyDate ?:@"",
             @"showLineGesture":@(_showLineGesture)};
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
    
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:kSwipePasswordDataIdentifier];
    [keyChain setData:data ? : [NSData new] forKey:kSwipePasswordDataKey];
}

+ (void)deleteSwipePasswordData
{
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:kSwipePasswordDataIdentifier];
    [keyChain removeItemForKey:kSwipePasswordDataKey];
}

+ (JJSwipePasswordData *)readSwipePasswordData
{
    UICKeyChainStore *keyChain = [UICKeyChainStore keyChainStoreWithService:kSwipePasswordDataIdentifier];
    NSData *data = [keyChain dataForKey:kSwipePasswordDataKey];
    NSDictionary *dic = [AESDESCrypt decryptWithJsonChiperData:data];
    
    ///这个函数 自己用别的开源库 替换吧  就不引入了
    JJSwipePasswordData *pwdData = [JJSwipePasswordData new];
    pwdData.type =  [dic[@"type"] integerValue];
    pwdData.password =  dic[@"password"];
    pwdData.failedCounter =  [dic[@"failedCounter"] integerValue];
    pwdData.lastModifyDate = dic[@"lastModifyDate"];
    pwdData.showLineGesture = [dic[@"showLineGesture"] integerValue];
    
    return pwdData;//[LoginVIPInf objectWithKeyValues:dic];
}

- (void)setPassword:(NSString *)password
{
    _password = [AESDESCrypt encryptWithText:password];
}


@end
