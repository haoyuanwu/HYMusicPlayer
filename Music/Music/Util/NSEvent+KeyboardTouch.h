//
//  NSEvent+KeyboardTouch.h
//  Music
//
//  Created by 吴昊原 on 2018/7/2.
//  Copyright © 2018年 吴昊原. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSEvent (KeyboardTouch)

- (BOOL)isCommandDown;

- (BOOL)isShiftDown;

- (BOOL)isControlDown;

- (BOOL)isOptionDown;
@end
