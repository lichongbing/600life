//
//  JDCategoryModel.h
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "JDCategoryChild.h"
NS_ASSUME_NONNULL_BEGIN

@interface JDCategoryModel : JSONModel

@property (nonatomic,copy) NSNumber *parent_id;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray<JDCategoryChild*> *child;
@property (nonatomic,copy) NSNumber *cid;

@end

NS_ASSUME_NONNULL_END
