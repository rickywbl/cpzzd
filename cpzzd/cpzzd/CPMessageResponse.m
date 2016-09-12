//
//  CPMessageResponse.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPMessageResponse.h"

@interface CPMessageResponse()

@property (nonatomic, copy, readwrite) NSString *responseString;


@end


@implementation CPMessageResponse

+ (id)responseWithReponseData:(NSData*)responseData {
    
    CPMessageResponse *response = [[self class]alloc];
    
    response = [response initWithReponseData:responseData];
    
    return response;
}

+(id)responseWithReponseDic:(NSDictionary *)responseDic{
    
    CPMessageResponse *response = [[self class]alloc];
    response = [response initWithReponseDic:responseDic];
    return response;
}

- (id)initWithReponseData:(NSData*)responseData {
    
    if ((self = [super init])) {
        
        self.responseString = [[NSString alloc]initWithData:responseData
                                                   encoding:NSUTF8StringEncoding];
        NSLog(@"响应报文:\n%@", self.responseString);
        
        
        [self fromString: self.responseString];
    }
    return self;
}

-(instancetype)initWithReponseDic:(NSDictionary *)responseDic{
    
    if(self = [super init]){
        
        
        [self fromDic:responseDic];
        
    }
    
    return self;
}


@end
