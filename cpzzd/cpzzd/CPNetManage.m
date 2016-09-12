//
//  CPNetManage.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPNetManage.h"
#import "CPMessageResponse.h"

@interface CPNetManage()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

@property (nonatomic, strong) AFHTTPSessionManager * sessionManager;

@end
@implementation CPNetManage


+ (instancetype)sharedInstance
{
    static CPNetManage* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CPNetManage new];
    });
    
    return instance;
}

-(instancetype)init{
    
    if(self= [super init]){
        
        self.sessionManager = [AFHTTPSessionManager manager];
        
        self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        self.networkStatus = AFNetworkReachabilityStatusUnknown;
        
        self.sessionManager.operationQueue.maxConcurrentOperationCount = 1;
        
        self.sessionManager.requestSerializer.timeoutInterval = 30;
        
        
        
    }
    
    
    return self;
}

/**
 *  开始检测网络
 */

- (void)startMonitoringNetworkStatus {
    @weakify(self);
    [self.sessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        
        NSOperationQueue *operationQueue = self.sessionManager.operationQueue;
        self.networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [operationQueue setSuspended:NO];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
            {
                [operationQueue setSuspended:YES];
            }
                break;
        }
    }];
    //    [self.networkManager.reachabilityManager startMonitoring];
}

/**
 *  停止检测网络
 */
- (void)stopMonitoringNetworkStatus {
  
    
    [self.sessionManager.reachabilityManager stopMonitoring];
}

// 检查网络状态
- (void)checkNetworkStatus{
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
                        self.networkStatus = AFNetworkReachabilityStatusNotReachable;
            
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            
            
            self.networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
            
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            
            self.networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
        }
        
        
    }];
}




- (void)GETRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(CPMessageResponse * messageResponse, NSError *err))completion{
    
    
    [self.sessionManager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if([responseObject isKindOfClass:[NSData class]]){
            
            
            NSData *responseData = (NSData *)responseObject;
            
            CPMessageResponse * messageResponse =[CPMessageResponse responseWithReponseData:responseData];
            
            
            if(messageResponse.context){
                
                completion(messageResponse,nil);
            }
            
            
        }
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *responseData = (NSDictionary *)responseObject;
            
            CPMessageResponse * messageResponse =[CPMessageResponse responseWithReponseDic:responseData];
            
            if(messageResponse.context){
                
                completion(messageResponse,nil);
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            completion(nil,error);
        
    }];
    
}



- (void)PostRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(CPMessageResponse * messageResponse, NSError *err))completion{
        
    
    [self.sessionManager POST:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        if([responseObject isKindOfClass:[NSData class]]){
            
            
            NSData *responseData = (NSData *)responseObject;
            
            CPMessageResponse * messageResponse =[CPMessageResponse responseWithReponseData:responseData];
            
            
            if(messageResponse.context){
                
                completion(messageResponse,nil);
            }
            
            
        }
        if([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *responseData = (NSDictionary *)responseObject;
            
            CPMessageResponse * messageResponse =[CPMessageResponse responseWithReponseDic:responseData];
            
            if(messageResponse.context){
                
                completion(messageResponse,nil);
            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        completion(nil,error);
        
    }];
    
}



@end
