//
//  SearchResultListController.h
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultListController : LLViewController

/** 搜索 sort字段
 1：综合排序
 2：佣金比例由大到小
 3：预估收益由高到低
 4：价格由大到小
 5：价格由小到大
 6：月销量由大到小
 7：月销量由小到大
 */
-(id)initWithKeyWords:(NSString*)keywords;

@end

NS_ASSUME_NONNULL_END
