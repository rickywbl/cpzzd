//
//  AppDelegate.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"
#import "CPIRSSWebDetailViewController.h"
#import "CPIRSSModel.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];
    
    isActivity = YES;
    
    self.allowRotation = 0;
    
    [UMessage startWithAppkey:UMKEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    
    
    
    if(launchOptions)
    {
        
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if([CPConfig sharedInstance].loginStatus == YES){
            
         
            
            NSString *operationStr = [pushNotificationKey objectForKey:@"operation"];
            
            
            if([operationStr isEqualToString:@"openApp"])
            {
                
            }
            if([operationStr isEqualToString:@"openWeb"])
            {
                
                NSString *url =[pushNotificationKey objectForKey:@"url"];
                
                CPIRSSWebDetailViewController *detail =[[CPIRSSWebDetailViewController alloc]init];
                CPIRSSModel *model = [[CPIRSSModel alloc]init];
                model.Id = url;
                detail.model = model;
                CPNavigationController *nav = (CPNavigationController *)self.window.rootViewController;
                [nav pushViewController:detail animated:YES];
                
            }
            
            
        }
    
    };


    
    [self  StoreUUID];
    
    
    if(![CPConfig sharedInstance].loginStatus){
        
        self.window.rootViewController = [[CPLoginViewController alloc]init];
        
    }else{
    
        CPRootViewController *root = [[CPRootViewController alloc]init];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:root];
        
    }

    [self.window makeKeyAndVisible];
    return YES;
}

-(void)StoreUUID{

    //保存唯一设备识别
    NSString *SERVICE_NAME = @"com.cjzkw.cpzdd";
    NSString * str =  [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];  // 从keychain获取数据
    if ([str length] <= 0)
    {
        str  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];  // 保存UUID作为手机唯一标识符
        [SFHFKeychainUtils storeUsername:@"UUID"
                             andPassword:str
                          forServiceName:SERVICE_NAME
                          updateExisting:1
                                   error:nil];  // 往keychain添加数据
    }
    
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    _UserInfo =[NSDictionary dictionaryWithDictionary:userInfo];
    
    if(isActivity == YES)
        
    {
        
        if([[_UserInfo objectForKey:@"operation"] isEqualToString:@"openApp"])
        {
            
        }
        if([[_UserInfo objectForKey:@"operation"] isEqualToString:@"openWeb"])
        {
            
            
            
            UIAlertView *  alertView = [[UIAlertView alloc] initWithTitle:@"最新资讯"
                                                                  message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                        otherButtonTitles:@"确定",nil];
            [alertView show];
        }
        
    }
    else
    {

        [self Pushnofi];
        
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1)
    {
        
        [self Pushnofi];
    }
}


-(void)Pushnofi{
    
    if([CPConfig sharedInstance].loginStatus == YES){
        
    
        NSString *operationStr = [_UserInfo objectForKey:@"operation"];
        if([operationStr isEqualToString:@"openApp"])
        {
            
        }
        if([operationStr isEqualToString:@"openWeb"])
        {
            
            NSString *url =[_UserInfo objectForKey:@"url"];
            CPIRSSWebDetailViewController *detail =[[CPIRSSWebDetailViewController alloc]init];
            CPIRSSModel *model = [[CPIRSSModel alloc]init];
            model.Id = url;
            detail.model = model;
            CPNavigationController *nav = (CPNavigationController *)self.window.rootViewController;
            [nav pushViewController:detail animated:YES];
        
        }
    

    }


}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    isActivity = YES;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    isActivity = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    isActivity = YES;
     [self checkToken];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}



//应用激活的时候需要验证下Token是否有效

-(void)checkToken{

    if([CPConfig sharedInstance].loginStatus == YES){
        
        NSString *token = [CPConfig sharedInstance].token;
        
        [[CPNetManage sharedInstance] PostRequestWithPath:CPNetRequest_Header(CheckToken_Request(token)) parameters:nil completion:^(CPMessageResponse *messageResponse, NSError *err) {
            
            if(!messageResponse.Succeed){
                
                self.window.rootViewController = [[CPLoginViewController alloc]init];
            }
            
        }];
        
        
    }
}


- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
  
    if (_allowRotation == 1) {
        
        return UIInterfaceOrientationMaskLandscapeLeft;//这个可以根据自己的需求设置旋转方向
    }
    else
    {
        return (UIInterfaceOrientationMaskPortrait);
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
