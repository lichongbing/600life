//
//  JDCategorySubViewController.h
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "SPMenuSubViewController.h"
#import "JDCategoryModel.h"   //京东分类模型

NS_ASSUME_NONNULL_BEGIN

@interface JDCategorySubViewController : SPMenuSubViewController

-(id)initWithJDCategoryModel:(JDCategoryModel*)jdCategoryModel;

@end

NS_ASSUME_NONNULL_END
