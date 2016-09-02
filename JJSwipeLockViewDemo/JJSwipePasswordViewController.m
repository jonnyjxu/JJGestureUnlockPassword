//
//  JJSwipePasswordViewController.m
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/9/1.
//  Copyright © 2016年 xujun. All rights reserved.
//

#import "JJSwipePasswordViewController.h"
#import "JJSwipeMainView.h"
#import "JJSwipePasswordData.h"
#import "AESDESCrypt.h"


typedef NS_ENUM(NSUInteger, JJSwipeStepPassword) {
    JJSwipeStepPasswordUnknown, //默认
    
    JJSwipeStepPasswordCreate1,//创建密码---输入密码
    JJSwipeStepPasswordCreate2,//创建密码---验证密码
    
    JJSwipeStepPasswordVerifyOnly,//修改设置---验证原始密码
    
    JJSwipeStepPasswordVerifyLock,//锁屏---验证原始密码
    
    JJSwipeStepPasswordChangeVerifyOldPwd,//修改密码--验证旧密码
    JJSwipeStepPasswordChange1,//修改密码--输入新密码
    JJSwipeStepPasswordChange2,//修改密码--验证新密码
    
    
};


@interface JJSwipePasswordViewController () <JJSwipeMainViewDelegate>

@property (nonatomic, assign) JJSwipePasswordStyle style;

@property (nonatomic, assign) JJSwipeStepPassword step;

@property (nonatomic, weak) JJSwipeMainView *mainView;
///上次保存的密码
@property (nonatomic, copy) NSString *passwordString;
///失败次数
@property (nonatomic, assign) NSUInteger failedCounter;

@end

@implementation JJSwipePasswordViewController

+ (instancetype)defaultViewControllerWithStyle:(JJSwipePasswordStyle)style
{
    JJSwipePasswordViewController *vc = [JJSwipePasswordViewController new];
    vc.style = style;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _failedCounter = [JJSwipePasswordData share].failedCounter;
    
    [self _setupMainView];
    
    [self _debugSetupCloseButton];
    
}

- (void)_setupMainView
{
    JJSwipeMainView *mainView = nil;
    
    if (self.style == JJSwipePasswordStyleLock) {
        mainView = [JJSwipeMainView defaultMainViewWithNoNavigation];
    }
    else {
        mainView = [JJSwipeMainView defaultMainViewWithNavigation];
    }
    
    mainView.delegate = self;
    
    [self.view addSubview:mainView];
    
    self.mainView = mainView;
    
    
    ///首次更新步骤状态
    [self swipeView:mainView didEndSwipeWithPassword:nil];
}


- (void)_debugSetupCloseButton
{
#ifdef DEBUG
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 20, 50, 30);
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
#endif
}

- (JJSwipeLockState)_swipeView:(JJSwipeMainView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    UILabel *titleLabel = swipeView.titleLabel;
    ///这里要读写数据库
    if (self.failedCounter >= 10) {
        titleLabel.text = @"你都试了10次了...找回密码去吧";
        //TODO: 弹出框
        
        return JJSwipeLockStateWarning;
    }
    
    ///至少四位密码
    if (self.step != JJSwipeStepPasswordUnknown && password.length < 4) {
        titleLabel.text = @"请输入至少4位手势密码";
        return JJSwipeLockStateWarning;
    }
    
    ///创建密码
    if (self.style == JJSwipePasswordStyleCreate) {
        if (self.step == JJSwipeStepPasswordUnknown) {
            self.step = JJSwipeStepPasswordCreate1;
            titleLabel.text = @"请输入手势密码";
            return JJSwipeLockStateNormal;
        }
        else if (self.step == JJSwipeStepPasswordCreate1) {
            self.passwordString = password;
            self.step = JJSwipeStepPasswordCreate2;
            titleLabel.text = @"请再次输入手势密码";
        }
        else if (self.step == JJSwipeStepPasswordCreate2) {
            return [self _swipeView:swipeView updateLastInputPassword:password dismiss:YES];
        }
    }
    
    ///验证密码
    else if (self.style == JJSwipePasswordStyleVerify) {
        
        if (self.step == JJSwipeStepPasswordUnknown) {
            self.step = JJSwipeStepPasswordVerifyOnly;
            self.mainView.titleLabel.text = @"请输入手势密码";
        }
        else if (self.step == JJSwipeStepPasswordVerifyOnly) {
            return [self _swipeView:swipeView updateVerfityDataBasePassword:password dismiss:YES];
        }
    }
    
    ///修改密码
    else if (self.style == JJSwipePasswordStyleChange) {
        
        if (self.step == JJSwipeStepPasswordUnknown) {
            self.step = JJSwipeStepPasswordChangeVerifyOldPwd;
            titleLabel.text = @"请输入原手势密码";
        }
        else if (self.step == JJSwipeStepPasswordChangeVerifyOldPwd) {
            
            JJSwipeLockState state = [self _swipeView:swipeView updateVerfityDataBasePassword:password dismiss:NO];
            if (state == JJSwipeLockStateNormal) {
                self.step = JJSwipeStepPasswordChange1;
                titleLabel.text = @"请输入新的手势密码";
            }
            return state;
        }
        else if (self.step == JJSwipeStepPasswordChange1) {
            self.passwordString = password;
            self.step = JJSwipeStepPasswordChange2;
            titleLabel.text = @"请再次输入新的手势密码";
        }
        else if (self.step == JJSwipeStepPasswordChange2) {
            return [self _swipeView:swipeView updateLastInputPassword:password dismiss:YES];
        }
    }
    
    
    ///锁屏解锁
    else if (self.style == JJSwipePasswordStyleLock) {
        
        if (self.step == JJSwipeStepPasswordUnknown) {
            self.step = JJSwipeStepPasswordVerifyLock;
            self.mainView.titleLabel.text = @"请输入手势密码解锁";
        }
        else if (self.step == JJSwipeStepPasswordVerifyLock) {
            return [self _swipeView:swipeView updateVerfityDataBasePassword:password dismiss:YES];
        }
    }
    
    return JJSwipeLockStateNormal;

}


- (JJSwipeLockState)swipeView:(JJSwipeMainView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    JJSwipeLockState state = [self _swipeView:swipeView didEndSwipeWithPassword:password];
    
    if (state == JJSwipeLockStateWarning) {
        self.mainView.titleLabel.textColor = [UIColor redColor];
    }
    else {
        self.mainView.titleLabel.textColor = [UIColor lightGrayColor];
    }
    
    return state;
}



#pragma mark - update

- (JJSwipeLockState)_swipeView:(JJSwipeMainView *)swipeView updateVerfityDataBasePassword:(NSString *)password dismiss:(BOOL)dismiss
{
    UILabel *titleLabel = swipeView.titleLabel;
    
    if (![JJSwipePasswordViewController isEqualDataBasePassword:password]) {
        ++self.failedCounter;
        titleLabel.text = [NSString stringWithFormat:@"手势密码不正确, 你还能尝试%ld次", 10-self.failedCounter];
        return JJSwipeLockStateWarning;
    }
    
    if (dismiss) {
        [self dismiss];
    }
    
    //重置失败次数
    [self setFailedCounter:0];
    
    return JJSwipeLockStateNormal;
}

- (JJSwipeLockState)_swipeView:(JJSwipeMainView *)swipeView updateLastInputPassword:(NSString *)password dismiss:(BOOL)dismiss

{
    UILabel *titleLabel = swipeView.titleLabel;
    
    if (![self isEqualToLastInputPassword:password]) {
        titleLabel.text = @"与上次输入的手势密码不一致";
        return JJSwipeLockStateWarning;
    }
    
    if (dismiss) {
        [self dismiss];
    }
    
    JJSwipePasswordData *pwdData = [JJSwipePasswordData share];
    pwdData.password = password;
    pwdData.failedCounter = 0;
    pwdData.type = JJSwipePasswordTypeGesture;
    
    [pwdData save];
    
    return JJSwipeLockStateNormal;
}


#pragma mark - show and dismiss


- (void)dismiss
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - password check

- (void)setFailedCounter:(NSUInteger)failedCounter
{
    ///记录到数据库
    _failedCounter = failedCounter;
    
    NSUInteger count = [JJSwipePasswordData share].failedCounter;
    if (count != failedCounter) {
        [JJSwipePasswordData share].failedCounter = failedCounter;
        [[JJSwipePasswordData share] save];
    }
}

- (void)setPasswordString:(NSString *)passwordString
{
    ///加密
    _passwordString = [AESDESCrypt encryptWithText:passwordString];
}

- (BOOL)isEqualToLastInputPassword:(NSString *)password
{
    if (password.length == 0) {
        return NO;
    }
    //加密  秘钥比较就可以了
    return [self.passwordString isEqualToString:[AESDESCrypt encryptWithText:password]];
}


+ (BOOL)isEqualDataBasePassword:(NSString *)password
{
    if (password.length == 0) {
        return NO;
    }
    return [[JJSwipePasswordData share].password isEqualToString:[AESDESCrypt encryptWithText:password]];
}

@end
