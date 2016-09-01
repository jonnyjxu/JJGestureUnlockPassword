# JJSwipeLockView
a swipe password view to unlock an application written in objective-c

<img src="example.gif"/>
## Requirements

JJSwipeLockView works on iOS 6.0 and later version and is compatible with ARC projects. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

## Usage

 1. Copy the JJSwipeLockView folder to your project.
 2. Add JJSwipeLockView as a subview wherever you want and set a delegate to this JJSwipeLockView.

```objective-c
		
JJSwipeMainView *mainView = nil;

if (self.style == JJSwipePasswordStyleLock) {
    mainView = [JJSwipeMainView defaultMainViewWithNoNavigation];
}
else {
    mainView = [JJSwipeMainView defaultMainViewWithNavigation];
}

mainView.delegate = self;

[self.view addSubview:mainView];


    
- (JJSwipeLockState)swipeView:(JJSwipeMainView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    //everytime user finish a swipe, this method get called and pass a password, add your logic here.
    
}
```
## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
# JJGestureUnlockPassword
