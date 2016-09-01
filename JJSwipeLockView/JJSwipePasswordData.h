//
//  JJSwipePasswordData.h
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JJSwipePasswordType) {
    JJSwipePasswordTypeNone,//无密码
    JJSwipePasswordTypeGesture,//手势
    JJSwipePasswordTypeFingerprint,//指纹
};

@interface JJSwipePasswordData : NSObject

+ (instancetype)share;
///类型
@property (nonatomic,assign) JJSwipePasswordType type;
///明文传入手势密码AES  内部会加密
@property (nonatomic,copy) NSString *password;
///失败次数
@property (nonatomic,assign) NSUInteger failedCounter;

///上次修改的时间
@property (nonatomic,strong,readonly) NSDate *lastModifyDate;

///是否显示手势线条 default YES
@property (nonatomic,assign) BOOL showLineGesture;

- (void)save;

@end
