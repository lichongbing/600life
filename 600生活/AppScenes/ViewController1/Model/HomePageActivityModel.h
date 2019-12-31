//
//  HomePageActivityModel.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HomePageActivityModel;

@interface HomePageActivityModel : JSONModel

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *url;  //如果这个url 不为空，说明应该浏览器打开
@property (nonatomic,copy) NSString *type;   

@end

NS_ASSUME_NONNULL_END
