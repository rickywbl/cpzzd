//
//  CPMessage.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPMessage.h"

@implementation CPMessage


-(id)init {
    self = [super init];
    if ( self ) {
        
        self.context = [NSMutableDictionary new];
    }
    return self;
}

-(void)fromString:(NSString*)message {
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
    if ([jsonObj isKindOfClass:[NSMutableDictionary class]]) {
        
        self.context = (NSMutableDictionary*)jsonObj;
        
        self.Message = self.context[@"result"][@"Message"];
        self.Succeed = [self.context[@"result"][@"Succeed"] boolValue];
        
        
    } else {
        NSAssert1(NO, @"不正确的Json:%@", message);
    }
}

-(NSString*)toString {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.context
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}


-(void)fromDic:(NSDictionary *)messageDic{
    
    self.context = [messageDic mutableCopy];
    
    
    if([messageDic[@"result"] isKindOfClass:[NSDictionary class]]){
        
        self.Message = self.context[@"result"][@"Message"];
        self.Succeed = [self.context[@"result"][@"Succeed"] boolValue];
    }
    
    
    
}

@end
