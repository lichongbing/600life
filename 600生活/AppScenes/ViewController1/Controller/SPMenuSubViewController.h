//
//  SPMenuSubViewController.h
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPMenuSubViewController : LLViewController

//让子类去实现加载数据
-(void)loadDatasWhenUserDone;


//cid是当前vc的菜单id,活动子控制器中需要这个初始化方法
-(id)initWithCid:(NSString*)cid;

@property(nonatomic,strong)NSString* cid;

@end

NS_ASSUME_NONNULL_END
