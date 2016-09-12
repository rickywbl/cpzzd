//
//  UIImage+Extension.m
//  mobip2p
//
//  Created by LittleKin on 15-4-5.
//  Copyright (c) 2015年 zkbc. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
/**
 *  创建圆环图片
 *
 *  @return 圆环图片
 */
+ (UIImage *)circleImageProgress:(CGFloat) progress
{
    // 进度条背景图片
    UIImage *image = [UIImage imageNamed:@"进度背景"];
    
    // 1.画大圆
    // 此处的宽高必须和storyboard的progressView大小一致
    CGSize imgSize = CGSizeMake(80, 80);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect circleRect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    CGContextAddEllipseInRect(ctx, circleRect);
    [[UIColor whiteColor] set];
    //   实心渲染
    CGContextFillPath(ctx);
    
    // 2.画小圆
    // x控制圆环的大小
    CGFloat x = 5.0;
    CGRect circleSmall = CGRectMake(x, x, imgSize.width - x*2, imgSize.height - x*2);
    CGContextAddEllipseInRect(ctx, circleSmall);
    
    // 3.设置裁剪途径（将图形上下文 按照上边图形裁剪出来）
    CGContextClip(ctx);
    //   画图片
    [image drawInRect:circleSmall];
    
    // 4.绘制进度图片
    CGFloat rate = (100-progress)/100.0;
    CGFloat circleProgressX = 0;
    CGFloat circleProgressY = circleSmall.size.height*rate;
    CGFloat circleProgressW = circleRect.size.width;
    CGFloat circleProgressH = circleRect.size.height;
    CGRect circleProgress = CGRectMake(circleProgressX,circleProgressY, circleProgressW, circleProgressH);
    // 进度条图片
    UIImage * rateImage = [UIImage imageNamed:@"当前进度"];
    [rateImage drawInRect:circleProgress];
    
    // 5.取出图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭位图上下文
    UIGraphicsEndImageContext();
    return newImg;
}

-(UIImage *)circleImage{
    
    // NO:代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获取图片上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    //添加一个园
    CGRect rect = CGRectMake(0, 0, self.size.width,self.size.height);
    
    CGContextAddEllipseInRect(ref, rect);
    
    //裁剪
    CGContextClip(ref);
    
    
    //画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
