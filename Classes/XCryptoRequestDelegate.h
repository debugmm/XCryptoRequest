//
//  XCryptRequestProtocol.h
//  SyncHelper
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

@class XCryptoRequest;

@protocol XCryptoRequestDelegate <NSObject>

@optional
#pragma mark - Finished XCrypt Request
/**
 @Description succeeded xcrypt Request

 @param xcryptRequest xcrypt Request
 */
-(void)succeededXCryptoRequest:(XCryptoRequest *)xcryptoRequest;

/**
 @Description xcrypt Request failed

 @param xcryptRequest xcrypt Request
 */
-(void)failedXCryptoRequest:(XCryptoRequest *)xcryptoRequest;

#pragma mark - Track XCrypt Request Progress
/**
 @Description track progress value

 @param xcryptRequest XCrypt Request
 @param ratioValue float type ratio Value
 */
-(void)xcryptoRequest:(XCryptoRequest *)xcryptoRequest progressRatioValue:(float)ratioValue;

@end
