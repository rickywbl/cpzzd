//
//  CPMessageResponse.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPMessage.h"
@interface CPMessageResponse : CPMessage

@property (nonatomic, copy, readonly) NSString *responseString;


+ (id)responseWithReponseData:(NSData*)responseData;
- (id)initWithReponseData:(NSData*)responseData;

+(id)responseWithReponseDic:(NSDictionary *)responseDic;
-(instancetype)initWithReponseDic:(NSDictionary *)responseDic;


@end
