//
//  AppDelegate.h
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    BOOL isActivity;//判断程序是否在运行
    NSDictionary * _UserInfo;
    
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)NSInteger allowRotation;


@end

