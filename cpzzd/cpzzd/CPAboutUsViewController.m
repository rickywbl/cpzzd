//
//  CPAboutUsViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPAboutUsViewController.h"

@interface CPAboutUsViewController ()

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation CPAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *sattus = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    sattus.backgroundColor = CPColor(@"2e3036");
    
    [self.view addSubview:sattus];
    
    UIView *navView =[[UIView alloc]initWithFrame:CGRectMake(0, 20, CPScreen_Width, 44)];
    
    navView.backgroundColor = CPColor(@"2e3036");
    
    [self.view addSubview:navView];
    
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [back setImage:CPImage(@"product_back") forState:UIControlStateNormal];
    
    back.frame = CGRectMake(0, 0,30, 44);
    
    [navView addSubview:back];
    

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, CPScreen_Width, CPScreen_Height -64)];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cpzzd.sanlianyang.com/Content/about.html"]];
    
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
}

-(void)back:(UIButton *)button{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
