//
//  JJSwipeHeader.h
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#ifndef JJSwipeHeader_h
#define JJSwipeHeader_h


typedef NS_ENUM(NSUInteger, JJSwipeLockState) {
    JJSwipeLockStateNormal,
    JJSwipeLockStateWarning,
    JJSwipeLockStateSelected
};

typedef NS_ENUM(NSUInteger, JJSwipePasswordStyle) {
    ///创建密码
    JJSwipePasswordStyleCreate,
    ///验证密码
    JJSwipePasswordStyleVerify,
    ///修改密码
    JJSwipePasswordStyleChange,
    ///锁屏解锁
    JJSwipePasswordStyleLock,
};


#endif /* JJSwipeHeader_h */
