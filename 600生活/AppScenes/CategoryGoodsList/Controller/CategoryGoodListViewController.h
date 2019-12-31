//
//  CategoryGoodListViewController.h
//  600生活
//
//  Created by iOS on 2019/12/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CategoryGoodListViewController : LLViewController

//传入分类id  分类名称
-(id)initWithCategoryId:(NSString*)categoryId CategoryName:(NSString*)categoryName;



@end

NS_ASSUME_NONNULL_END
