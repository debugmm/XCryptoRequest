//
//  XCryptoManager.m
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import "XCryptoManager.h"
#import "XCryptoRequest.h"

#import "XCryptoRequestDelegate.h"
#import "XCryptoManagerProtocol.h"

#define XCryptKey (@"Key")
#define XCryptIV (@"IV")
#define XCryptOperation (@"CCOperation")
#define XCryptSourceFilePath (@"SourceFilePath")

#define XCryptSender (@"Sender")
#define XCryptCallBackParam (@"CallbackParam")

typedef NS_ENUM(NSInteger,OpRequestsType){

    RemoveObjectType=1,
    AddObjectType=2,
};

@interface XCryptoManager()<XCryptoRequestDelegate>

@property(nonatomic,strong)NSMutableArray *requests;//save request

@property(nonatomic,strong)NSRecursiveLock *opLock;//lock

@end

@implementation XCryptoManager

+(XCryptoManager *)sharedManager{
    
    static dispatch_once_t onceToken;
    static XCryptoManager *sharedManager;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager=[[XCryptoManager alloc] init];
        
        sharedManager.requests=[[NSMutableArray alloc] initWithCapacity:1];
        sharedManager.opLock=[[NSRecursiveLock alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Send XCrypt Request
-(void)sendAESCBCXCryptoRequest:(id)sender
                  requestParam:(NSDictionary *)param
                 callbackParam:(id)callbackParam{
    
    XCryptoRequest *xr=[[XCryptoRequest alloc] init];

    NSNumber *op=[param objectForKey:XCryptOperation];
    NSString *key=[param objectForKey:XCryptKey];
    NSString *iv=[param objectForKey:XCryptIV];
    
    NSString *sfp=[param objectForKey:XCryptSourceFilePath];
    
    if(op){
        
        xr.operation=[op unsignedIntValue];
    }
    if(key){
    
        xr.key=key;
    }
    if(iv){
    
        xr.iv=iv;
    }
    if(sfp){
    
        xr.sourceFilePath=sfp;
    }
    
    xr.delegate=self;
    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] initWithCapacity:2];
    if(sender){
    
        [userInfo setObject:sender forKey:XCryptSender];
    }
    if(callbackParam){
    
        [userInfo setObject:callbackParam forKey:XCryptCallBackParam];
    }
    
    xr.userInfo=userInfo;

    [self operationRequest:AddObjectType
                    object:xr
                requestTag:callbackParam
                    sender:sender];
        
}

-(void)addOperationRequestToShareQueue:(XCryptoRequest *)xr{

    if(xr){
    
        [[XCryptoRequest shareQueue] addOperation:xr];
    }
}

#pragma mark - Cancel Request
-(void)cancelXCryptoRequest:(id)sender
                requestTag:(id)requestTag{
    
    NSLog(@"cancelXCryptoRequest");
    [self operationRequest:RemoveObjectType
                    object:nil
                requestTag:requestTag
                    sender:sender];
}

#pragma mark - Operation requests
-(void)operationRequest:(OpRequestsType)opType
                 object:(id)object
             requestTag:(id)requestTag
                 sender:(id)sender{
    
    //lock requests array operation
    [self.opLock lock];
    NSLog(@"cancel,thread:%@",[NSThread currentThread]);
    
    __block XCryptoRequest *mid;
    __block BOOL existRequest=NO;
    
    [self.requests enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XCryptoRequest *xr=(XCryptoRequest *)obj;
        
        NSString *cbp=[xr.userInfo objectForKey:XCryptCallBackParam];
        
        if([cbp isEqualToString:(NSString *)requestTag]){
            
            mid=xr;
            
            *stop=YES;
            existRequest=YES;
        }
    }];
    
    [self.opLock unlock];
    
    
    if(opType==RemoveObjectType){
        
        if(existRequest && mid){
        
            [self.requests removeObject:mid];
            
            [mid cancel];
        }
        
    }else{
    
        if(object && !existRequest){
        
            [self.requests addObject:object];
            
            [self addOperationRequestToShareQueue:object];
        }
    }
}

#pragma mark - XCrypto Request Delegate
-(void)succeededXCryptoRequest:(XCryptoRequest *)XCryptoRequest{
    
    id sender=[XCryptoRequest.userInfo objectForKey:XCryptSender];
    id cbp=[XCryptoRequest.userInfo objectForKey:XCryptCallBackParam];
    
    if(sender && [sender conformsToProtocol:@protocol(XCryptoManagerProtocol)]){
        
        if([sender respondsToSelector:@selector(finishedXCrypto:desFilePath:callbackParam:)]){
        
            [sender finishedXCrypto:XCryptoRequest.sourceFilePath
                        desFilePath:XCryptoRequest.desFilePath
                      callbackParam:cbp];
        }
    }
    NSLog(@"succeededXCryptoRequest\n");
}

-(void)failedXCryptoRequest:(XCryptoRequest *)XCryptoRequest{

    NSLog(@"failedXCryptoRequest\n");
    id sender=[XCryptoRequest.userInfo objectForKey:XCryptSender];
    id cbp=[XCryptoRequest.userInfo objectForKey:XCryptCallBackParam];
    
    if(sender && [sender conformsToProtocol:@protocol(XCryptoManagerProtocol)]){
        
        if([sender respondsToSelector:@selector(failedXCrypto:desFilePath:callbackParam:failedStatusCode:failedMsg:)]){
            
            [sender failedXCrypto:XCryptoRequest.sourceFilePath
                      desFilePath:XCryptoRequest.desFilePath
                    callbackParam:cbp
                 failedStatusCode:XCryptoRequest.er.code
                        failedMsg:@""];
        }
    }
}

-(void)XCryptoRequest:(XCryptoRequest *)XCryptoRequest
  progressRatioValue:(float)ratioValue{

    id sender=[XCryptoRequest.userInfo objectForKey:XCryptSender];
    id cbp=[XCryptoRequest.userInfo objectForKey:XCryptCallBackParam];
    
    if(sender && [sender conformsToProtocol:@protocol(XCryptoManagerProtocol)]){
    
        if([sender respondsToSelector:@selector(xcryptoProgressValue:sourceFilePath:desFilePath:callbackParam:)]){
            
            [sender xcryptoProgressValue:ratioValue sourceFilePath:XCryptoRequest.sourceFilePath desFilePath:XCryptoRequest.desFilePath callbackParam:cbp];
        }
    }
    NSLog(@"ratioValue:%f\n",ratioValue);
}

@end
