//
//  NSString+CateString.m
//  SyncHelper
//
//  Created by wjg on 22/09/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import "NSString+CateString.h"

@implementation NSString (CateString)
#pragma mark - Material Class Methods
+(BOOL)isEmptyString:(NSString *)string{
    
    if(string &&
       [string isKindOfClass:[NSString class]] &&
       string.length>0){

        return NO;
        
    }else{
        
        return YES;
    }
}

+(NSString *)stringByTrimmingBothEndWhiteSpace:(NSString *)string{
    
    if([NSString isEmptyString:string]){
        
        return [[NSString alloc] init];//最好不要使用nil，因为这改变了类型，会引起bug。
        
    }else{
        
        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

@end
