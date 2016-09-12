//
//  CPRootViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPRootViewController.h"
#import "CPTabBarController.h"
#import "CPMenuViewController.h"
#import "CPLoginViewController.h"
@interface CPRootViewController ()


@end

@implementation CPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChinaViewController];

}

-(void)setUpChinaViewController{
    

    self.menu = [[CPMenuViewController alloc]init];
    
    [self addChildViewController:self.menu];
    
    [self.view addSubview:self.menu.view];
    
    self.menu.view.frame = self.view.bounds;

 
    CPTabBarController *tabbar = [[CPTabBarController alloc]init];
    
    [self addChildViewController:tabbar];
    
    [self.view addSubview:tabbar.view];
    
    tabbar.view.frame = self.view.bounds;
    
 
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}



@end
