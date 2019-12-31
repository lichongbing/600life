//
//  FAQModel.h
//  600生活
//
//  Created by iOS on 2019/12/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "JSONModel.h"
#import "QuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FAQModel : JSONModel

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSArray<QuestionModel*> *question_list;

//客户端自定义数据
@property(nonatomic,assign)BOOL isShowMoreInfo; //是否展示更多信息

@end

NS_ASSUME_NONNULL_END
