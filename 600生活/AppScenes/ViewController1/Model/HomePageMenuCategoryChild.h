//
//  HomePageMenuCategoryChild.h
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePageMenuCategoryChild : JSONModel

@property (nonatomic,copy) NSNumber *parent_id;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray *child;
@property (nonatomic,copy) NSString *cid;

@end

NS_ASSUME_NONNULL_END
