//
//  FAQCellHeightHeler.h
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FAQModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FAQCellHeightHeler : NSObject

+(CGFloat)getCellHeightWithData:(FAQModel*)faqModel;

@end

NS_ASSUME_NONNULL_END
