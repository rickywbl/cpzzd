//
//  CPJQSTableViewCell.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPJQSTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *JQSTitle;
@property (strong, nonatomic) IBOutlet UILabel *JQSTime;
@property (strong, nonatomic) IBOutlet UILabel *JQSTeacher;
@property (strong, nonatomic) IBOutlet UILabel *JQSSource;
@property (strong, nonatomic) IBOutlet UIImageView *JQSImage;

@end
