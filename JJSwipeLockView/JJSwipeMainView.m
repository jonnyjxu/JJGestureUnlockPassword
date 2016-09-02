//
//  JJSwipeMainView.m
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import "JJSwipeMainView.h"
#import "JJSwipeLockView.h"

@interface JJSwipeMainView () <JJSwipeLockViewDelegate>

@property (nonatomic, weak) IBOutlet JJSwipeLockView *lockView;

@end

@implementation JJSwipeMainView

+ (instancetype)defaultMainViewWithNoNavigation
{
    CGRect frame = [UIScreen mainScreen].bounds;
    JJSwipeMainView *view = [JJSwipeMainView xibView];
    view.frame = frame;
    
    return view;
}
+ (instancetype)defaultMainViewWithNavigation
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 64;
    JJSwipeMainView *view = [JJSwipeMainView xibView];
    view.frame = frame;
    
    return view;
}


- (void)awakeFromNib
{
    self.lockView.delegate = self;
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)/2;
    self.imageView.layer.masksToBounds = YES;
}

- (JJSwipeLockState)swipeView:(JJSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    if ([self.delegate respondsToSelector:@selector(swipeView:didEndSwipeWithPassword:)]) {
        return [self.delegate swipeView:self didEndSwipeWithPassword:password];
    }
    return JJSwipeLockStateNormal;
}


@end
