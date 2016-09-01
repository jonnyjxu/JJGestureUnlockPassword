//
//  JJSwipeLockView.h
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJSwipeHeader.h"


@protocol JJSwipeLockViewDelegate;

@interface JJSwipeLockView : UIView
@property (nonatomic, assign) id<JJSwipeLockViewDelegate> delegate;

///圆圈  默认颜色  蓝色
@property (nonatomic, strong) UIColor *nodeColor;
///圆圈  默认颜色  蓝色
@property (nonatomic, strong) UIColor *nodeSelectedColor;
///圆圈  错误密码颜色  红色
@property (nonatomic, strong) UIColor *nodeWarningColor;

//default YES
@property (nonatomic,assign) BOOL showLine;
@end


@protocol JJSwipeLockViewDelegate<NSObject>
@optional
- (JJSwipeLockState)swipeView:(JJSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password;
@end