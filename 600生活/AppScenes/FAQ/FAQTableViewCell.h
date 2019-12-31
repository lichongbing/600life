//
//  FAQTableViewCell.h
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FAQTableViewCell : UITableViewCell

-(void)fullData:(FAQModel*)faqModel indexPath:(NSIndexPath*)indexPath;

//view已经重新布局 获取布局后的frame信息
@property (nonatomic,strong) void (^headIconClickedCallback)(FAQModel* faqModel);

@end

NS_ASSUME_NONNULL_END
