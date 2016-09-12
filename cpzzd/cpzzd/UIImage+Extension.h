//
//  UIImage+Extension.h
//  mobip2p
//
//  Created by LittleKin on 15-4-5.
//  Copyright (c) 2015年 zkbc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  创建圆环进度条图片
 *
 *  @return 圆环图片
 */
+ (UIImage *)circleImageProgress:(CGFloat) progress;
-(UIImage *)circleImage;
@end
