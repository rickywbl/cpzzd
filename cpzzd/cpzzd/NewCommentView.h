//
//  NewCommentView.h
//  cjzkwMain
//
//  Created by 财经智库网mac on 15/8/24.
//  Copyright (c) 2015年 财经智库网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCommentView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *ContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *Cancle;
@property (weak, nonatomic) IBOutlet UIButton *Send;
@end
