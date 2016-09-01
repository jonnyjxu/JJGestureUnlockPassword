//
//  BaseView.m
//   
//
//  Created by xu on 9/4/14.
//  Copyright (c) 2014   . All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    
    return self;
}



+ (id)xibViewWithNibName:(NSString *)nibName
{
   id view = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil].lastObject;
   
    
    return view;
}

+ (id)xibView
{
    return [BaseView xibViewWithNibName:NSStringFromClass(self.class)];
}

@end
