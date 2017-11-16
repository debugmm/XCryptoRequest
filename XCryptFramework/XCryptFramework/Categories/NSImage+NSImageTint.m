//
//  NSImage+NSImageTint.m
//  UCDisk
//
//  Created by wjg on 22/12/2016.
//  Copyright © 2016 wjg All rights reserved.
//

#import "NSImage+NSImageTint.h"

@implementation NSImage (NSImageTint)

-(NSImage *)imageWithTintColor:(NSColor *)tintColor{
    
    [self lockFocus];
    
    CGRect bounds=CGRectMake(0, 0, self.size.width, self.size.height);
    
    [tintColor setFill];
    NSRectFill(bounds);
    //NSCompositingOperationLuminosity vs NSCompositingOperationOverlay
    //NSCompositingOperationDestinationIn
    [self drawInRect:bounds fromRect:bounds operation:NSCompositingOperationLuminosity fraction:1.0];
    [self drawInRect:bounds fromRect:bounds operation:NSCompositingOperationDestinationIn fraction:1.0];
    
    [self unlockFocus];
    
    return self;
}

@end
