//
//  CPConfig.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#define CP_UserName @"userName"
#define CP_password @"password"
#define CP_token @"token"
#define CP_FirstLaunch @"firstLaunch"
#define CP_expiration @"expiration"

#import <Foundation/Foundation.h>

@interface CPConfig : NSObject

//用户名
@property (strong, nonatomic) NSString * userName;
//密码
@property (strong, nonatomic) NSString * password;
//Token
@property (strong, nonatomic) NSString * token;
//过期时间
@property (strong, nonatomic) NSString * expiration;

@property (strong, nonatomic) NSNumber * firstLaunch;

@property (strong, nonatomic) NSString * UUID;


+ (instancetype)sharedInstance;

-(void)clearLogin;

-(BOOL)loginStatus;

@end
