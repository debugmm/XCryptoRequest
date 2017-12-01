//
//  XCryptRequestProtocol.h
//  SyncHelper
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCryptRequest;

@protocol XCryptRequestDelegate <NSObject>

@optional
#pragma mark - Finished XCrypt Request
/**
 @Description succeeded xcrypt Request

 @param xcryptRequest xcrypt Request
 */
-(void)succeededXCryptRequest:(XCryptRequest *)xcryptRequest;

/**
 @Description xcrypt Request failed

 @param xcryptRequest xcrypt Request
 */
-(void)failedXCryptRequest:(XCryptRequest *)xcryptRequest;

#pragma mark - Track XCrypt Request Progress
/**
 @Description track progress value

 @param xcryptRequest XCrypt Request
 @param ratioValue float type ratio Value
 */
-(void)xcryptRequest:(XCryptRequest *)xcryptRequest progressRatioValue:(float)ratioValue;

@end
