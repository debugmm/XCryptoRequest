//
//  XCryptManagerProtocol.h
//  SyncHelper
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XCryptoManagerProtocol <NSObject>

@optional
#pragma mark - XCrypt(Encrypt/Decrypt)
/**
 @Description 完成文件加密/解密

 @param sourceFilePath 源文件路径
 @param desFilePath 目标文件路径
 @param callbackParam 回调可能会用到的参数
 
 @discussion callbackParam,example:data model
 */
-(void)finishedXCrypto:(NSString *)sourceFilePath
          desFilePath:(NSString *)desFilePath
        callbackParam:(id)callbackParam;


/**
 @Description 文件加密/解密失败

 @param sourceFilePath 源文件路径
 @param desFilePath 目标文件路径
 @param callbackParam 回调可能会用到的参数
 @param statusCode 失败状态码
 @param failedMsg 失败状态码描述（错误描述信息）
 
 @discussion callbackParam,example:data model
 */
-(void)failedXCrypto:(NSString *)sourceFilePath
        desFilePath:(NSString *)desFilePath
      callbackParam:(id)callbackParam
   failedStatusCode:(NSInteger)statusCode
          failedMsg:(NSString *)failedMsg;

/**
 @Description 文件加密/解密已取消

 @param sourceFilePath 源文件路径
 @param desFilePath 目标文件路径
 @param callbackParam 回调可能会用到的参数
 
 @discussion callbackParam,example:data model
 */
-(void)canceledXCrypto:(NSString *)sourceFilePath
          desFilePath:(NSString *)desFilePath
        callbackParam:(id)callbackParam;

#pragma mark - track progress

/**
 @Description 文件加密/解密 进度跟踪

 @param progressValue 进度值(ratio)
 @param sourceFilePath 源文件路径
 @param desFilePath 目标文件路径
 @param callbackParam 回调可能会用到的参数
 
 @discussion callbackParam,example:data model
 */
-(void)xcryptoProgressValue:(float)progressValue
            sourceFilePath:(NSString *)sourceFilePath
               desFilePath:(NSString *)desFilePath
             callbackParam:(id)callbackParam;


@end
