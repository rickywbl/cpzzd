//
//  CPNavigationController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPNavigationController.h"

#define CPNAVBAR_COLOR CPColor(@"2e3036")

@interface CPNavigationController ()

@end

@implementation CPNavigationController



+(void)load{

    UINavigationBar *bar = [UINavigationBar appearance];
    
    [bar setBarTintColor:CPNAVBAR_COLOR];
    
    [bar setTintColor:[UIColor whiteColor]];
    
    
    NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc]init];
    titleAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    bar.titleTextAttributes = titleAttributes;
    
    [bar setBackgroundColor:CPNAVBAR_COLOR];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barStyle = UIBarStyleBlack;

}


@end
