//
//  CPTools.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPTools : NSObject


+(CGFloat)CalculateCellHightWithString:(NSString *)content Size:(CGSize)size Fontsize:(NSInteger)fontsize;

+(NSAttributedString *)AttributedStringWithString:(NSString *)content space:(CGFloat)space fontSize:(CGFloat)fontsize;

@end
