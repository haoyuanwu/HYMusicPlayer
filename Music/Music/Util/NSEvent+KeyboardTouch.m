//
//  NSEvent+KeyboardTouch.m
//  Music
//
//  Created by 吴昊原 on 2018/7/2.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import "NSEvent+KeyboardTouch.h"

@implementation NSEvent (KeyboardTouch)

- (BOOL)isCommandDown {
    return (self.modifierFlags & NSEventModifierFlagCommand) != 0;
}

- (BOOL)isShiftDown {
    return (self.modifierFlags & NSEventModifierFlagShift) != 0;
}

- (BOOL)isControlDown {
    return (self.modifierFlags & NSEventModifierFlagControl) != 0;
}

- (BOOL)isOptionDown {
    return (self.modifierFlags & NSEventModifierFlagOption) != 0;
}

@end
