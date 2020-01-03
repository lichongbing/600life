//
//  JDTeSeMainViewController.h
//  600生活
//
//  Created by iOS on 2020/1/3.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDTeSeMainViewController : LLViewController

//根据index判断spMenu移动的位置
//0好券商品  1 9.9包邮   2品牌好货
-(id)initWithIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
