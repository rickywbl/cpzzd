//
//  CPIRSSTableViewCell.m
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "CPIRSSTableViewCell.h"
#import "CPIRSSModel.h"

@implementation CPIRSSTableViewCell
@synthesize model = _model;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(CPIRSSModel *)model
{
	_model = model;
    
    self.CPTitle.text = model.Title;
    
    self.CPContent.attributedText = [CPTools AttributedStringWithString:self.model.Intro space:5 fontSize:14];
    
    self.CPContent.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.CPTime.text = model.ReleaseDate;
    
    self.CPSource.text = model.Source;
}



@end
