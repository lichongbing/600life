//
//  GoodStoreDetailViewController.h
//  600生活
//
//  Created by iOS on 2019/11/22.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailViewController : LLViewController

//shopType 1天猫 2淘宝
-(id)initWithBrandId:(NSString*)brandId;

@end

NS_ASSUME_NONNULL_END
