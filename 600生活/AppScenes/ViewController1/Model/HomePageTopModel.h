//
//  HomePageTopModel.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HomePageTopModel;

@interface HomePageTopModel : JSONModel

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *item_id;

@end

NS_ASSUME_NONNULL_END
