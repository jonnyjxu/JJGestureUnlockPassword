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
///内部选中 圆圈大小(default 0 取默认值)
@property (nonatomic, assign) CGFloat innerCircleScale;

//default YES
@property (nonatomic,assign) BOOL showLine;

///设置密码 可用于传递(上一个页面的 传递到下一个页面)
@property NSString *lockPassword;

@end


@protocol JJSwipeLockViewDelegate<NSObject>
@optional
- (void)swipeView:(JJSwipeLockView *)swipeView didSwipingWithPassword:(NSString *)password;//正在绘制
- (JJSwipeLockState)swipeView:(JJSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password;//结果绘制
@end
