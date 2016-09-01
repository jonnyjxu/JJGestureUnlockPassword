//
//  ViewController.m
//  JJSwipeLockViewDemo
//
//  Created by xujun on 16/2/12.
//  Copyright (c) 2016年 xujun. All rights reserved.
//

#import "ViewController.h"
#import "JJSwipeLockView.h"
#import "JJSwipePasswordViewController.h"
#import "JJSwipePasswordData.h"


@interface ViewController ()
@property (nonatomic, weak) UIButton *setButton;
@property (nonatomic, weak) UIButton *checkButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = 300;
    
    
    UIButton *testButton1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, width, 20)];
    testButton1.tag = 0;
    [testButton1 setTitle:@"创建密码" forState:UIControlStateNormal];
    [testButton1 addTarget:self action:@selector(testButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton1];
    
    UIButton *testButton2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 180, width, 20)];
    testButton2.tag = 1;
    [testButton2 setTitle:@"验证密码" forState:UIControlStateNormal];
    [testButton2 addTarget:self action:@selector(testButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton2];
    
    UIButton *testButton3 = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, width, 20)];
    testButton3.tag = 2;
    [testButton3 setTitle:@"修改密码" forState:UIControlStateNormal];
    [testButton3 addTarget:self action:@selector(testButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton3];
    
    UIButton *testButton4 = [[UIButton alloc] initWithFrame:CGRectMake(20, 260, width, 20)];
    testButton4.tag = 3;
    [testButton4 setTitle:@"解锁锁屏" forState:UIControlStateNormal];
    [testButton4 addTarget:self action:@selector(testButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton4];
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, width, 20)];
    resetButton.tag = 4;
    [resetButton setTitle:@"重置密码" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetButtonBeTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
}


- (void)testButtonBeTouched:(UIButton *)sender
{
    if (sender.tag != 0 && [JJSwipePasswordData share].type == JJSwipePasswordTypeNone) {
        [self alertWithTitle:@"您还未设置密码"];
        return;
    }
    JJSwipePasswordViewController *vc = [JJSwipePasswordViewController defaultViewControllerWithStyle:sender.tag];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)resetButtonBeTouched:(UIButton *)sender
{
    [[JJSwipePasswordData new] save];
    
    [self alertWithTitle:@"密码重置成功"];
}


- (void)alertWithTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
