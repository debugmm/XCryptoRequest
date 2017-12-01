//
//  XCryptoManager.h
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCryptoManager : NSObject

/**
 @Description file en/decrypt 

 @return singleton shared manager
 */
+(XCryptoManager *)sharedManager;

#pragma mark - Send Request

/**
 @Description send XCrypto Request

 @param sender sender
 @param param XCrypto Param
 @param callbackParam callbackParam
 
 @discussion callbackParam,example:data model
             request Param struct:@{@"CCOperation":operation,
                                    @"Key":key,
                                    @"IV":iv,
                                    @"SourceFilePath":sourceFilePath}
 
 */
-(void)sendAESCBCXCryptoRequest:(id)sender
                   requestParam:(NSDictionary *)param
                  callbackParam:(id)callbackParam;

#pragma mark - Cancel A XCrypto Request

/**
 @Description Cancel A XCrypto Request

 @param sender sender
 @param requestTag a request tag
 
 @discussion requestTag Most likely:model data
 */
-(void)cancelXCryptoRequest:(id)sender
                 requestTag:(id)requestTag;

@end
