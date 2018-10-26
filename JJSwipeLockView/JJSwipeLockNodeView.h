//
//  JJSwipeLockNodeView.h
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJSwipeHeader.h"

@interface JJSwipeLockNodeView : UIView
///设置状态
@property (nonatomic, assign) JJSwipeLockState nodeViewStatus;

///圆圈  默认颜色  蓝色
@property (nonatomic, strong) UIColor *nodeColor;
///圆圈  默认颜色  蓝色
@property (nonatomic, strong) UIColor *nodeSelectedColor;
///圆圈  错误密码颜色  红色
@property (nonatomic, strong) UIColor *nodeWarningColor;
///内部选中 圆圈大小(default 0 取默认值)
@property (nonatomic, assign) CGFloat innerCircleScale;
@end
