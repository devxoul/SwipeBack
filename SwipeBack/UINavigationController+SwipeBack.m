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
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)hack_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self hack_pushViewController:viewController animated:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
}

@end
