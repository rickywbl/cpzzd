//
//  CPMenuViewController.h
//  cpzzd
//
//  Created by 王保霖 on 16/8/31.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPFatherViewController.h"

@interface CPMenuViewController : CPFatherViewController

//Property
@property (strong, nonatomic) IBOutlet UIButton *AccountManage;
@property (strong, nonatomic) IBOutlet UIButton *Product;
@property (strong, nonatomic) IBOutlet UIButton *Telphone;
@property (strong, nonatomic) IBOutlet UIButton *Risk;
@property (strong, nonatomic) IBOutlet UIView *MenuView;
@property (strong, nonatomic) IBOutlet UIView *BgView;

//Constrains

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *MenuLeft;



//Methods
- (IBAction)AcountAction:(UIButton *)sender;
- (IBAction)Description:(UIButton *)sender;
- (IBAction)ContactAction:(id)sender;
- (IBAction)RiskTip:(UIButton *)sender;
- (IBAction)Exit:(id)sender;


-(void)MenuShow;

@end
