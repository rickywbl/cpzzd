//
//  CPCommentTableViewCell.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/7.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *Content;

@end
