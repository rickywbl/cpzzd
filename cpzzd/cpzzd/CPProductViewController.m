//
//  CPProductViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPProductViewController.h"

@interface CPProductViewController ()

@end

@implementation CPProductViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNav];
}

-(void)viewWillAppear:(BOOL)animated{

    

    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
}

-(void)setUpNav{


    self.title = @"产品说明";
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [back setImage:CPImage(@"product_back") forState:UIControlStateNormal];
    
    back.frame = CGRectMake(0, 0,30, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = leftItem;


}

-(void)back:(UIButton *)button{


    [self.navigationController popViewControllerAnimated:YES];
}


@end
