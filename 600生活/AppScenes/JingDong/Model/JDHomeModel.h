//
//  JDModel.h
//  600生活
//
//  Created by iOS on 2020/1/2.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "JDCategoryModel.h"  //分类
#import "JDGood.h"  //推荐商品

NS_ASSUME_NONNULL_BEGIN

@interface JDHomeModel : JSONModel

@property (nonatomic,copy) NSString *banner;   //首页banner图片
@property (nonatomic,copy) NSString *pinpai_image;  //平台好货图片
@property (nonatomic,copy) NSString *hjsp_image; //好券商品图片
@property (nonatomic,copy) NSString *jiu_image; //9.9包邮图片

@property (nonatomic,copy) NSArray<JDCategoryModel*> *category;  //分类数据不知道和另外一个分类是否是同一个东西 先试一试吧
@property (nonatomic,copy) NSArray<JDGood*> *recommend_goods; //推荐商品

@end

NS_ASSUME_NONNULL_END
