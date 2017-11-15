//
//  XCryptManager.m
//  SyncHelper
//
//  Created by wjg on 14/11/2017.
//  Copyright © 2017 wjg All rights reserved.
//

#import "XCryptManager.h"
#import "XCryptRequest.h"

#import "XCryptRequestDelegate.h"
#import "XCryptManagerProtocol.h"

#define XCryptKey (@"Key")
#define XCryptIV (@"IV")
#define XCryptOperation (@"CCOperation")
#define XCryptSourceFilePath (@"SourceFilePath")

#define XCryptSender (@"Sender")
#define XCryptCallBackParam (@"CallbackParam")

@interface XCryptManager()<XCryptRequestDelegate>

@property(nonatomic,strong)NSMutableArray *requests;//save request

@property(atomic,strong)NSRecursiveLock *opLock;//lock

@end

@implementation XCryptManager

+(XCryptManager *)sharedManager{
    
    static dispatch_once_t onceToken;
    static XCryptManager *sharedManager;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager=[[XCryptManager alloc] init];
        
        sharedManager.requests=[[NSMutableArray alloc] initWithCapacity:1];
        sharedManager.opLock=[[NSRecursiveLock alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Send XCrypt Request
-(void)sendAESCBCXCryptRequest:(id)sender
                  requestParam:(NSDictionary *)param
                 callbackParam:(id)callbackParam{
    
    XCryptRequest *xr=[[XCryptRequest alloc] init];

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
    
    [self.opLock lock];
    [self.requests addObject:xr];
    [self.opLock unlock];
    
    [[XCryptRequest shareQueue] addOperation:xr];
}

#pragma mark - Cancel Request
-(void)cancelXCryptRequest:(id)sender
                requestTag:(id)requestTag{

    [self.opLock lock];
    
    __block XCryptRequest *mid;
    
    [self.requests enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XCryptRequest *xr=(XCryptRequest *)obj;
        
        NSString *cbp=[xr.userInfo objectForKey:XCryptCallBackParam];
        
        if([cbp isEqualToString:(NSString *)requestTag]){
        
            mid=xr;
            
            *stop=YES;
        }
    }];
    
    [self.requests removeObject:mid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [mid cancel];
    });
    
    [self.opLock unlock];
}

#pragma mark - XCrypt Request Delegate
-(void)succeededXCryptRequest:(XCryptRequest *)xcryptRequest{
    
    id sender=[xcryptRequest.userInfo objectForKey:XCryptSender];
    id cbp=[xcryptRequest.userInfo objectForKey:XCryptCallBackParam];
    
    if(sender && [sender conformsToProtocol:@protocol(XCryptManagerProtocol)]){
        
        if([sender respondsToSelector:@selector(finishedXCrypt:desFilePath:callbackParam:)]){
        
            [sender finishedXCrypt:xcryptRequest.sourceFilePath
                       desFilePath:xcryptRequest.desFilePath
                     callbackParam:cbp];
        }
    }
    NSLog(@"succeededXCryptRequest\n");
}

-(void)failedXCryptRequest:(XCryptRequest *)xcryptRequest{

    NSLog(@"failedXCryptRequest\n");
    id sender=[xcryptRequest.userInfo objectForKey:XCryptSender];
    id cbp=[xcryptRequest.userInfo objectForKey:XCryptCallBackParam];
    
    if(sender && [sender conformsToProtocol:@protocol(XCryptManagerProtocol)]){
        
        if([sender respondsToSelector:@selector(failedXCrypt:desFilePath:callbackParam:failedStatusCode:failedMsg:)]){
            
            [sender failedXCrypt:xcryptRequest.sourceFilePath
                     desFilePath:xcryptRequest.desFilePath
                   callbackParam:cbp
                failedStatusCode:xcryptRequest.er.code
                       failedMsg:@""];
        }
    }
}

-(void)xcryptRequest:(XCryptRequest *)xcryptRequest
  progressRatioValue:(float)ratioValue{

    id sender=[xcryptRequest.userInfo objectForKey:XCryptSender];
    id cbp=[xcryptRequest.userInfo objectForKey:XCryptCallBackParam];
    
    if(sender && [sender conformsToProtocol:@protocol(XCryptManagerProtocol)]){
    
        if([sender respondsToSelector:@selector(xcryptProgressValue:sourceFilePath:desFilePath:callbackParam:)]){
            
            [sender xcryptProgressValue:ratioValue sourceFilePath:xcryptRequest.sourceFilePath desFilePath:xcryptRequest.desFilePath callbackParam:cbp];
        }
    }
    NSLog(@"ratioValue:%f\n",ratioValue);
}

@end
