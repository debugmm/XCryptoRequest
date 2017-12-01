//
//  XCryptRequest.h
//  SyncHelper
//
//  Created by wjg on 13/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XCryptRequestDelegate.h"

#import <CommonCrypto/CommonCryptor.h>

typedef NS_ENUM(NSInteger,XCryptErrorType){
    
    CryptNoneError=0,
    
    SourceFileNotExist=1,
    SourceFileIsDir=2,
    
    KeyorIVConversionError=3,
    
    CryptorCreationError=4,
    CryptorUpdateError=5,
    CryptorFinalError=6,
    
    ReadFileError=7,
    WriteFileError=8,
    CreatingFileError=9,
    
    FileStreamError=20,
    
    CancelledXCryptError=30,
    
    UnhandledExceptionError=505,
};

//file size
typedef unsigned long long fileSize_t;

@interface XCryptRequest : NSOperation

#pragma mark - method

/**
 @Description shared Operation Queue

 @return share Operation Queue
 
 @discussion it is a thread-safe singleton
 */
+(NSOperationQueue *)shareQueue;

-(void)cancel;

#pragma mark - Property
/**
 @Description @{@"Sender":sender,@"CallbackParam":callbackParam}
 */
@property(nonatomic,strong)NSDictionary *userInfo;

@property(nonatomic,copy)NSString *sourceFilePath;//source file path
@property(nonatomic,readonly)NSString *desFilePath;//destination file path

@property(nonatomic,copy)NSString *iv;//initialized vector
@property(nonatomic,copy)NSString *key;//Raw key material

@property(nonatomic,readonly,strong)NSError *er;//error info

@property(nonatomic,assign)CCOperation operation;//operation type(de/encrypt)

@property(nonatomic,readonly,assign)fileSize_t fileSize;//source file size

@property(nonatomic,readonly,assign)fileSize_t xcryptSize;//xcryp progress size

@property(nonatomic,assign)id<XCryptRequestDelegate> delegate;//XCryptRequest delegate

#pragma mark -
//@property(

@end
