# SwipeBack

Re-enable iOS7 swipe-to-back while custom back button is set.


## Background

1. With setting custom back button via `leftBarButtonItem`, default swipe-to-back gesture is disabled.
2. Assigning `interactivePopGestureRecognizer` as `UINavigationController` (a common solution) can cause unexpected errors:

    > - nested pop animation can result in corrupted navigation bar
    > - Finishing up a navigation transition in an unexpected state. Navigation Bar subview tree might get corrupted.

3. Put custom code everywhere around `UINavigationController` is too annoying.


## The Answer is SwipeBack

1. **Not annoying**  
You don't need to code.

2. **iOS7 native behavior**  
Not a foolishly-customized gesture recognizer.

3. **Safe**  
No error anymore.


## Use SwipeBack

### CocoaPods

Just add a line below into your `Podfile`. You don't need to write any code. CocoaPods automatically import SwipeBack globally.

```
pod 'SwipeBack'
```

### Without CocoaPods (Why not use?)

Import SwipeBack at your `.pch` file.

```
#import "SwipeBack.h"
```

It's done.


## How does it work

See [`UINavigationController+SwipeBack.m`](https://github.com/devxoul/SwipeBack/blob/master/SwipeBack/UINavigationController%2BSwipeBack.m) and [`UIViewController+SwipeBack.m`](https://github.com/devxoul/SwipeBack/blob/master/SwipeBack/UIViewController%2BSwipeBack.m). Want to know more about method swizzling, visit [here](http://nshipster.com/method-swizzling/).