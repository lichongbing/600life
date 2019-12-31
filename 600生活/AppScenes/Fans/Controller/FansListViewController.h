//
//  FansListViewController.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FansListViewController : LLViewController

//粉丝类型：1全部 2直接粉丝 3间接
-(id)initWithType:(NSString*)type;

-(void)loadDatasWhenUserDone;  //外部调用 当用户操作时，载入数据

@end

NS_ASSUME_NONNULL_END
