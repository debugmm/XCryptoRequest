//
//  XCryptoRequestProtocol.h
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
 @Description succeeded xcrypto Request

 @param xcryptoRequest xcrypto Request
 */
-(void)succeededXCryptoRequest:(XCryptoRequest *)xcryptoRequest;

/**
 @Description xcrypto Request failed

 @param xcryptoRequest xcrypto Request
 */
-(void)failedXCryptoRequest:(XCryptoRequest *)xcryptoRequest;

#pragma mark - Track XCrypto Request Progress
/**
 @Description track progress value

 @param xcryptoRequest XCrypto Request
 @param ratioValue float type ratio Value
 */
-(void)xcryptoRequest:(XCryptoRequest *)xcryptoRequest progressRatioValue:(float)ratioValue;

@end
