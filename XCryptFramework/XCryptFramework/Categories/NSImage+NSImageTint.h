//
//  NSImage+NSImageTint.h
//  UCDisk
//
//  Created by wjg on 22/12/2016.
//  Copyright © 2016 wjg All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (NSImageTint)

/**
 @Description   给图片着色

 @param tintColor tintColor 着色颜色
 @return return value 着色后的图片
 */
-(NSImage *)imageWithTintColor:(NSColor *)tintColor;

@end
