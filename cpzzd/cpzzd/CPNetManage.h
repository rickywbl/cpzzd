//
//  CPNetManage.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPNetManage : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

+ (instancetype)sharedInstance;
- (void)startMonitoringNetworkStatus;
- (void)stopMonitoringNetworkStatus;
- (void)checkNetworkStatus;


- (void)GETRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(CPMessageResponse * messageResponse, NSError *err))completion;

- (void)PostRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(CPMessageResponse * messageResponse, NSError *err))completion;

@end
