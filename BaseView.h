//
//  BaseView.h
//   
//
//  Created by xu on 9/4/14.
//  Copyright (c) 2014   . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

//子类必须重载
+ (id)xibView;

+ (id)xibViewWithNibName:(NSString *)nibName;

@end
