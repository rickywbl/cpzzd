//
//  CPMessage.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPMessage : NSObject

@property(nonatomic, strong) NSMutableDictionary *context;
@property(nonatomic, strong) NSString * Message;
@property(nonatomic, assign) BOOL  Succeed;


- (void) fromString:(NSString*)message;
- (NSString*) toString;
-(void)fromDic:(NSDictionary *)messageDic;


@end
