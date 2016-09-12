//
//  CPTools.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPTools.h"

@implementation CPTools


+(NSAttributedString *)AttributedStringWithString:(NSString *)content space:(CGFloat)space fontSize:(CGFloat)fontsize{
    
    NSMutableDictionary * attributes = [[NSMutableDictionary alloc]init];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    
    style.lineSpacing = space;
    
    attributes[NSParagraphStyleAttributeName] = style;
    
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:fontsize];
    
    //attributes[]
    
    NSAttributedString *Attr = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    
    return Attr;
}


+(CGFloat)CalculateCellHightWithString:(NSString *)content Size:(CGSize)size Fontsize:(NSInteger)fontsize{
    
    NSMutableDictionary * attributes = [[NSMutableDictionary alloc]init];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    
    style.lineSpacing = 5;
    
    attributes[NSParagraphStyleAttributeName] = style;
    
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:fontsize];
    
    return [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    
}

@end
