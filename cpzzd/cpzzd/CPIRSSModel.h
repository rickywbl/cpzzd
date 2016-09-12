//
//  CPIRSSModel.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Realm/Realm.h>

@interface CPIRSSModel : RLMObject

@property (copy,nonatomic) NSString * Id;
@property (copy,nonatomic) NSString * ArtExId;
@property (copy,nonatomic) NSString * Title;
@property (copy,nonatomic) NSString * Content;
@property (copy,nonatomic) NSString * Inputer;
@property  (copy,nonatomic)NSString * ReleaseDate;
@property  (copy,nonatomic)NSString * Author;
@property  (copy,nonatomic)NSString * Source;
@property (copy,nonatomic) NSString * Intro;
@property  (copy,nonatomic)NSNumber<RLMInt> * ProductType;
@property  (copy,nonatomic)NSNumber<RLMBool> * IsDelete;
@property (copy,nonatomic) NSNumber<RLMBool> * IsHot;


@property  NSNumber<RLMFloat> * cellHight;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<CPIRSSModel>
RLM_ARRAY_TYPE(CPIRSSModel)
