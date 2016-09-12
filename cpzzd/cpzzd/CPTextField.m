//
//  CPTextField.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPTextField.h"

@implementation CPTextField




- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {

        [self setValue:CPColor(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        
        self.layer.cornerRadius = 5;
        
        self.clipsToBounds = YES;
        
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 47)];
        
        self.leftImageView.contentMode = UIViewContentModeCenter;
    
        self.leftView = self.leftImageView;
        
        self.leftViewMode = UITextFieldViewModeAlways;
        
        
    }
    return self;
}

@end
