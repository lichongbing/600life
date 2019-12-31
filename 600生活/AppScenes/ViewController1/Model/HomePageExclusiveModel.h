//
//  HomePageExclusiveModel.h
//  600生活
//
//  Created by iOS on 2019/11/6.
//  Copyright © 2019 灿男科技. All rights reserved.
//  独家福利购

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageExclusiveModel;

@interface HomePageExclusiveModel : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
