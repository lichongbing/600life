//
//  FansModel.h
//  600生活
//
//  Created by iOS on 2019/12/7.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FansModel : JSONModel

@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *user_nickname;
@property (nonatomic,copy) NSNumber *level;
@property (nonatomic,copy) NSNumber *count;
@property (nonatomic,copy) NSString *create_time;

@end

NS_ASSUME_NONNULL_END
