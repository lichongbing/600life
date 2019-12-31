//
//  HomePageMenuModel.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "HomePageMenuCategoryChild.h"

NS_ASSUME_NONNULL_BEGIN

//就是分类

@interface HomePageMenuModel : JSONModel

@property (nonatomic,copy) NSNumber *parent_id;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray<HomePageMenuCategoryChild*> *child;
@property (nonatomic,copy) NSNumber *cid;

@end

NS_ASSUME_NONNULL_END
