//
//  CategoryTypeViewController.h
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SPMenuSubViewController.h"
#import "HomePageMenuCategoryChild.h" //首页传递过来的数据

NS_ASSUME_NONNULL_BEGIN

@interface CategoryTypeViewController : SPMenuSubViewController

// 传入分类id  分类名称  分类二级菜单
-(id)initWithCid:(NSNumber*)cid categoryName:(NSString*)categoryName childArray:(NSArray<HomePageMenuCategoryChild*>*)childArray;



@end

NS_ASSUME_NONNULL_END
