//
//  XCryptManager.h
//  SyncHelper
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCryptManager : NSObject

/**
 @Description file en/decrypt 

 @return singleton shared manager
 */
+(XCryptManager *)sharedManager;

#pragma mark - Send Request

/**
 @Description send XCrypt Request

 @param sender sender
 @param param XCrypt Param
 @param callbackParam callbackParam
 
 @discussion callbackParam,example:data model
             request Param struct:@{@"CCOperation":operation,
                                    @"Key":key,
                                    @"IV":iv,
                                    @"SourceFilePath":sourceFilePath}
 
 */
-(void)sendAESCBCXCryptRequest:(id)sender
                  requestParam:(NSDictionary *)param
                 callbackParam:(id)callbackParam;

#pragma mark - Cancel A XCrypt Request

/**
 @Description Cancel A XCrypt Request

 @param sender sender
 @param requestTag a request tag
 
 @discussion requestTag Most likely:model data
 */
-(void)cancelXCryptRequest:(id)sender
                requestTag:(id)requestTag;

@end
