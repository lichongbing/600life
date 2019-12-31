//
//  SuperiorUserInfo.h
//  600生活
//
//  Created by iOS on 2019/12/16.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperiorUserInfo : JSONModel

@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
