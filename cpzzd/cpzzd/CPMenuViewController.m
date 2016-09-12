//
//  CPMenuViewController.m
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPMenuViewController.h"
#import "CPProductViewController.h"
#import "CPHelpdeskViewController.h"
#import "CPAcountViewController.h"
#import "CPHotlineViewController.h"
#import "CPLoginViewController.h"

@interface CPMenuViewController ()

@end

@implementation CPMenuViewController

- (void)viewDidLoad {
    
    
    [self MenuHide];
    
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    
    [self.BgView addGestureRecognizer:swipe];
    [self.BgView addGestureRecognizer:tap];
    


}

-(void)swipe:(UIGestureRecognizer *)gest{

     [self MenuHide];
    
}

- (IBAction)AcountAction:(UIButton *)sender {
    
    CPAcountViewController *acount = [[CPAcountViewController alloc]init];
    
   [self.navigationController pushViewController:acount animated:YES];
}

- (IBAction)Description:(UIButton *)sender {
    
    CPProductViewController *product = [[CPProductViewController alloc]init];
    
    [self.navigationController pushViewController:product animated:YES];
}

- (IBAction)ContactAction:(id)sender {
    
    CPHotlineViewController *hotline = [[CPHotlineViewController alloc]init];
     [self.navigationController pushViewController:hotline animated:YES];
}

- (IBAction)RiskTip:(UIButton *)sender {
    
    CPHelpdeskViewController *help = [[CPHelpdeskViewController alloc]init];
     [self.navigationController pushViewController:help animated:YES];
}

- (IBAction)Exit:(id)sender {
    

    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确认退出当前账号?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        CPLoginViewController *login =[[CPLoginViewController alloc]init];
        
        CPKeyWindowController = login;
        NSString *path = CPNetRequest_Header(LoginOut_Request([CPConfig sharedInstance].token));
        
        [[CPNetManage sharedInstance] PostRequestWithPath:path parameters:nil completion:^(CPMessageResponse *messageResponse, NSError *err) {
        
            
        }];
        
    }];
    
    [alter addAction:action];
    [alter addAction:action1];
    
    
    [self presentViewController:alter animated:YES completion:nil];
}




-(void)MenuShow{
    
    [self.view.superview bringSubviewToFront:self.view];

    self.MenuLeft.constant = 0 ;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.view layoutIfNeeded];
        
         self.BgView.alpha  = 1;
        
    } completion:^(BOOL finished) {
        
      
    }];

}

-(void)MenuHide{

    
    self.MenuLeft.constant = - self.view.width * 0.4;

    [UIView animateWithDuration:0.5 animations:^{
        
        self.BgView.alpha  = 0;
       
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    
        [self.view.superview insertSubview:self.view atIndex:0];
        
    }];
    
}

@end
