//
//  ShareDataModel.h
//  600生活
//
//  Created by iOS on 2019/12/10.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareDataModel : JSONModel

@property (nonatomic,copy) NSString *wenan_title;
@property (nonatomic,copy) NSString *wenan_desc;
@property (nonatomic,copy) NSString *tkl;
@property (nonatomic,copy) NSString *pic_url;
@property (nonatomic,copy) NSNumber *earnings;
@property (nonatomic,copy) NSString *item_url;
@property (nonatomic,copy) NSString *invite_code;
@property (nonatomic,copy) NSArray<NSString*> *small_images;
@property (nonatomic,copy) NSString *goods_title;

@end

NS_ASSUME_NONNULL_END
