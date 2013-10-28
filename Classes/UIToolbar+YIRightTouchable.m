//
//  YIRightTouchableToolbar.m
//  YIRightTouchableToolbar
//
//  Created by Yasuhiro Inami on 2013/10/28.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "UIToolbar+YIRightTouchable.h"
#import "JRSwizzle.h"

#define IS_IOS_AT_LEAST(ver)    ([[[UIDevice currentDevice] systemVersion] compare:ver] != NSOrderedAscending)

#if defined(__IPHONE_7_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
#define IS_FLAT_DESIGN          IS_IOS_AT_LEAST(@"7.0")
#else
#define IS_FLAT_DESIGN          NO
#endif


@implementation UIToolbar (YIRightTouchable)

+ (void)load
{
    [UIToolbar jr_swizzleMethod:@selector(hitTest:withEvent:)
                     withMethod:@selector(YIRightTouchableToolbar_hitTest:withEvent:)
                          error:NULL];
}

- (UIView *)YIRightTouchableToolbar_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* hitSubview = [self YIRightTouchableToolbar_hitTest:point withEvent:event];
    
    if (!IS_FLAT_DESIGN || hitSubview != self) {
        return hitSubview;
    }
    
    UIView* mostRightSubview = nil;
    CGFloat mostRightSubviewRight = 0;
    
    for (UIView* subview in self.subviews) {
        
        CGFloat subviewRight = subview.frame.origin.x+subview.frame.size.width;
        if (subviewRight >= self.frame.size.width) {
            continue;
        }
        
        if (mostRightSubviewRight < subviewRight) {
            mostRightSubview = subview;
            mostRightSubviewRight = subviewRight;
        }
        
    }
    
    if (point.x > mostRightSubviewRight) {
        return mostRightSubview;
    }
    
    return hitSubview;
}

@end
