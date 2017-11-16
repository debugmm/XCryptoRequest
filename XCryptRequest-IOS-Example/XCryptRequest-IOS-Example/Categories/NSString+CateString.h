//
//  NSString+CateString.h
//  SyncHelper
//
//  Created by wjg on 22/09/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CateString)

#pragma mark -
/**
 *  @abstract judgment string whether content.length==0/nil/NULL or not.
 *
 *  @param string type:NSString.
 *
 *  @return BOOL(YES,content is empty).
 */
+(BOOL)isEmptyString:(NSString *)string;

/**
 *  @abstract delete string both end white space.
 *
 *  @param string type:NSString.
 *
 *  @return new string that deleted both end white space.
 */
+(NSString *)stringByTrimmingBothEndWhiteSpace:(NSString *)string;

@end
