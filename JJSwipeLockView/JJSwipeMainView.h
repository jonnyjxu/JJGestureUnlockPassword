//
//  JJSwipeMainView.h
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import "BaseView.h"
#import "JJSwipeHeader.h"

@protocol JJSwipeMainViewDelegate;
@interface JJSwipeMainView : BaseView

+ (instancetype)defaultMainViewWithNoNavigation;
+ (instancetype)defaultMainViewWithNavigation;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@property (nonatomic, assign) id<JJSwipeMainViewDelegate> delegate;

@end




@protocol JJSwipeMainViewDelegate <NSObject>
- (JJSwipeLockState)swipeView:(JJSwipeMainView *)swipeView didEndSwipeWithPassword:(NSString *)password;

@end