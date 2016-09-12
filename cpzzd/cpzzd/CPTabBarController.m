//
//  CPTabBarController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPTabBarController.h"
#import "CPjQSViewController.h"
#import "CPIRssViewController.h"

#define CPTABBAR_COLOR CPColor(@"2e3036")
#define CPTABItemSelect_COLOR CPColor(@"01a9f6")
#define CPTABItemNormal_COLOR CPColor(@"d5d5d6")

@interface CPTabBarController ()

@property(copy,nonatomic)NSMutableArray *CPChinas;

@end

@implementation CPTabBarController


+(void)load{

    UITabBar *bar = [UITabBar appearance];
    
    [bar setBarTintColor:CPTABBAR_COLOR];
    
    
    UITabBarItem *item = [UITabBarItem appearance];
    
    NSMutableDictionary *SelectedAttributes = [[NSMutableDictionary alloc]init];
    SelectedAttributes[NSForegroundColorAttributeName] = CPTABItemSelect_COLOR;
    [item setTitleTextAttributes:SelectedAttributes forState:UIControlStateSelected];
    
    
    NSMutableDictionary *NormalAttributes = [[NSMutableDictionary alloc]init];
    NormalAttributes[NSForegroundColorAttributeName] = CPTABItemNormal_COLOR;
    [item setTitleTextAttributes:NormalAttributes forState:UIControlStateNormal];
    
    

}

-(NSMutableArray *)CPChinas{
    
    if(_CPChinas == nil){
        
        _CPChinas = [[NSMutableArray alloc]init];;
    }
    
    return _CPChinas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CPIRssViewController *Irss = [[CPIRssViewController alloc]init];
    

    
    [self setUpChinaViewController:Irss title:@"内参" NormalImage:@"tabbar_Irss_normal" SelectedImage:@"tabbar_Irss_selected"];


    CPjQSViewController *jqs = [[CPjQSViewController alloc]init];
    
    [self setUpChinaViewController:jqs title:@"复盘" NormalImage:@"tabbar_jqs_normal" SelectedImage:@"tabbar_jqs_selected"];
    
    
    self.viewControllers = self.CPChinas;
    
}

-(void)setUpChinaViewController:(UIViewController *)vc title:(NSString *)title NormalImage:(NSString *)normalImageName SelectedImage:(NSString *)SelectIamgeName{

    CPNavigationController *nav = [[CPNavigationController alloc]initWithRootViewController:vc];
    
    vc.title = title;
    
    vc.tabBarItem.image = [UIImage imageNamed:normalImageName];
    
    vc.tabBarItem.selectedImage = [UIImage imageNamed:SelectIamgeName];
    
    [self.CPChinas addObject:nav];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}






@end
