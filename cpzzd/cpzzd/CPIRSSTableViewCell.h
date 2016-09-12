//
//  CPIRSSTableViewCell.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPIRSSModel;

@interface CPIRSSTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *CPTitle;
@property (strong, nonatomic) IBOutlet UILabel *CPTime;
@property (strong, nonatomic) IBOutlet UILabel *CPSource;
@property (strong, nonatomic) IBOutlet UILabel *CPContent;

@property (strong, nonatomic) CPIRSSModel * model;


@end
