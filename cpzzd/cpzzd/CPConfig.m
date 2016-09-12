//
//  CPConfig.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPConfig.h"

@interface CPConfig()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end


@implementation CPConfig

@synthesize token = _token;
@synthesize expiration = _expiration;
@synthesize password = _password;
@synthesize userName = _userName;


+ (instancetype)sharedInstance
{
    static CPConfig* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CPConfig new];
    });
    
    return instance;
}

-(instancetype)init{
    
    if(self = [super init]){
        
        self.defaults = [NSUserDefaults standardUserDefaults];
        
    }
    
    return self;
}


-(void)clearLogin{
    
    self.userName = nil;
    self.password = nil;
    self.token = nil;
    self.expiration = nil;
}


-(NSString *)UUID{

    NSString *SERVICE_NAME = @"com.cjzkw.cpzdd";//最好用程序的bundle id
    
    NSString *str =  [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];
    
    NSLog(@"%@",str);
    
    return @"656BEA5B-47FA-42A5-9003-6A66B8CEC322";
    
    
    
}


-(BOOL)loginStatus{
    
    return [self.defaults objectForKey:CP_token] == nil ? NO:YES;
}



#pragma mark --- SET&&GET

// 用户名
- (NSString *)userName

{
    
    if([self.defaults objectForKey:CP_UserName] == nil){
        
        return @"";
    }
    return (NSString *)[self.defaults objectForKey:CP_UserName];
}

- (void)setUserName:(NSString *)userName
{
    [self.defaults setObject:userName forKey:CP_UserName];
    [self.defaults synchronize];
}

// 密码

- (NSString *)password
{
    return  (NSString *)[self.defaults objectForKey:CP_password];
}

- (void)setPassword:(NSString *)password
{
    [self.defaults setObject:password forKey:CP_password];
    [self.defaults synchronize];
    
}

//过期时间

- (NSString *)expiration
{
    return (NSString *)[self.defaults objectForKey:CP_expiration];
}

- (void)setExpiration:(NSString *)expiration
{
    [self.defaults setObject:expiration forKey:CP_expiration];
    [self.defaults synchronize];
}

//Token

- (NSString *)token

{
    
    if([self.defaults objectForKey:CP_token] == nil){
        
        return @"";
    }
    return (NSString *)[self.defaults objectForKey:CP_token];
}

- (void)setToken:(NSString *)token
{
    [self.defaults setObject:token forKey:CP_token];
    [self.defaults synchronize];
}

-(NSNumber *)firstLaunch{
    
    
    return (NSNumber *)[self.defaults objectForKey:CP_FirstLaunch];
}



-(void)setFirstLaunch:(NSNumber *)firstLaunch{
    
    [self.defaults setObject:firstLaunch forKey:CP_FirstLaunch];
}


@end
