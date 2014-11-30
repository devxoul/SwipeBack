//
// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//


#import <JRSwizzle/JRSwizzle.h>
#import <objc/runtime.h>

#import "UINavigationController+SwipeBack.h"


@implementation UINavigationController (SwipeBack)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jr_swizzleMethod:@selector(viewDidLoad)
                    withMethod:@selector(hack_viewDidLoad)
                         error:nil];
        [self jr_swizzleMethod:@selector(pushViewController:animated:)
                    withMethod:@selector(hack_pushViewController:animated:)
                         error:nil];
    });
}

- (void)hack_viewDidLoad
{
    [self hack_viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self.swipeBackEnabled ? self : nil;
}

- (void)hack_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self hack_pushViewController:viewController animated:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
}


#pragma mark - UIGestureRecognizerDelegate

/**
 * Prevent `interactiveGestureRecognizer` from canceling navigation button's touch event. (patch for #2)
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] && [touch.view isDescendantOfView:self.navigationBar]) {
        UIButton *button = (id)touch.view;
        button.highlighted = YES;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.navigationBar];
    UIView *view = [self.navigationBar hitTest:location withEvent:nil];

    if ([view isKindOfClass:[UIButton class]] && [view isDescendantOfView:self.navigationBar]) {
        UIButton *button = (id)view;
        button.highlighted = NO;
    }
    return YES;
}


#pragma mark - swipeBackEnabled

- (BOOL)swipeBackEnabled
{
    NSNumber *enabled = objc_getAssociatedObject(self, @selector(swipeBackEnabled));
    if (enabled == nil) {
        return YES; // default value
    }
    return enabled.boolValue;
}

- (void)setSwipeBackEnabled:(BOOL)enabled
{
    objc_setAssociatedObject(self, @selector(swipeBackEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.interactivePopGestureRecognizer.delegate = nil;
    self.interactivePopGestureRecognizer.enabled = enabled;
}

@end
