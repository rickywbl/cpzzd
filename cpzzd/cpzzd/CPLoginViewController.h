//
//  CPLoginViewController.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPFatherViewController.h"
@class CPTextField;
@interface CPLoginViewController : CPFatherViewController
@property (strong, nonatomic) IBOutlet CPTextField *UserNameTF;
@property (strong, nonatomic) IBOutlet CPTextField *PassWordTf;
@property (strong, nonatomic) IBOutlet UIButton *AboutUS;
@property (strong, nonatomic) IBOutlet UIButton *Login;
@property (strong, nonatomic) IBOutlet UIButton *Forgrt;
- (IBAction)AboutUSAction:(id)sender;
- (IBAction)LoginAction:(id)sender;
- (IBAction)ForgetAction:(id)sender;

@end
