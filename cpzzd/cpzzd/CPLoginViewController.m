//
//  CPLoginViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CPTextField.h"
#import "CPAboutUsViewController.h"
@interface CPLoginViewController ()


@property(strong,nonatomic)UITextField * AccountTextField;
@property(strong,nonatomic)UITextField * PasswordTextField;

@end

@implementation CPLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpNav];
    
    self.UserNameTF.leftImageView.image = [UIImage imageNamed:@"Login_account"];
     self.PassWordTf.leftImageView.image = [UIImage imageNamed:@"Login_password"];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
}

-(void)setUpNav{
    
    self.title = @"登录";

    
}

-(void)back:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
     [SVProgressHUD dismiss];
}



- (IBAction)AboutUSAction:(id)sender {
    
    CPAboutUsViewController *about  =[[CPAboutUsViewController alloc]init];
    [self presentViewController:about animated:YES completion:nil];
    
}

- (IBAction)LoginAction:(id)sender {
    
    
    [SVProgressHUD showWithStatus:@"登录中..."];
    
    [[CPNetManage sharedInstance] PostRequestWithPath:CPNetRequest_Header(Login_Request(self.UserNameTF.text,self.PassWordTf.text,[CPConfig sharedInstance].UUID) ) parameters:nil completion:^(CPMessageResponse *messageResponse, NSError *err) {
        
        
        if(err){
        
            [SVProgressHUD showInfoWithStatus:@"网络异常!!!"];
            
            return;
            
        }
        
        
        if(messageResponse.Succeed){
            
            [CPConfig sharedInstance].token = messageResponse.context[@"token"];
            [CPConfig sharedInstance].expiration = messageResponse.context[@"memberInfo"][@"EndDate"];
            [CPConfig sharedInstance].userName = self.UserNameTF.text;
            [CPConfig sharedInstance].password = self.PassWordTf.text;
            
            CPRootViewController *root = [[CPRootViewController alloc]init];
            CPKeyWindowController = [[CPNavigationController alloc]initWithRootViewController:root];
            
            [SVProgressHUD dismiss];
            
        }else{
        
            [SVProgressHUD showInfoWithStatus:messageResponse.Message];
        }
        
        
        
        
    }];
}

- (IBAction)ForgetAction:(id)sender {
    
    

}

@end
