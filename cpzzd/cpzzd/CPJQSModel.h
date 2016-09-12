//
//  CPJQSModel.h
//  cpzzd
//
//  Created by 王保霖 on 16/9/6.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Realm/Realm.h>

@interface CPJQSModel : RLMObject

@property (strong, nonatomic) NSString * Id;
@property (strong, nonatomic) NSString * Title;
@property (strong, nonatomic) NSString * Intro;
@property (strong, nonatomic) NSString * Teacher;
@property (strong, nonatomic) NSString * CreateTime;
@property (strong, nonatomic) NSString * VideoUrl;
@property (strong, nonatomic) NSString * ImgUrl;
@property (strong, nonatomic) NSString * Source;
@property (strong, nonatomic) NSNumber<RLMInt> *Count;
@property (strong, nonatomic) NSNumber<RLMBool> *IsDelete;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<CPJQSModel>
RLM_ARRAY_TYPE(CPJQSModel)
