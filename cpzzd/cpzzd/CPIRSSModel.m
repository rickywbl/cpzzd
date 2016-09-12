//
//  CPIRSSModel.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPIRSSModel.h"

@implementation CPIRSSModel




+(NSString *)primaryKey{

    return @"Id";
}

+ (NSArray *)modelPropertyBlacklist {
    
    return @[@"cellHight"];
}


-(void)setIntro:(NSString *)Intro{

    _Intro = Intro;
    
    CGFloat height = [CPTools CalculateCellHightWithString:Intro Size:CGSizeMake(CPScreen_Width,65) Fontsize:15]+10+20+12+12+7;
    
    self.cellHight = [NSNumber numberWithFloat:height];

}

@end
