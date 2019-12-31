//
//  LLWindowTipView.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLBaseView.h"
#import "SearchedGoodModel.h" //搜索的商品 模型
#import "SuperiorUserInfo.h" //上级用户 模型

typedef NS_ENUM(int, WindowTipViewType) {
    WindowTipViewTypeCustomerService  = 1,  //专属客服
    WindowTipViewTypeGoSigin,    //提醒注册
    WindowTipViewTypeAISearch,   //智能搜索
    WindowTipViewTypeShare,      //分享
    WindowTipViewTypeTaoBao,     //跳转淘宝
    WindowTipViewTypeSuperiorUser//上级用户
};


NS_ASSUME_NONNULL_BEGIN

@interface LLWindowTipView : LLBaseView

-(id)initWithType:(WindowTipViewType)type;
-(void)show;
-(void)dismiss;

///智能搜索控件
@property(nonatomic,strong)NSString* searchStr;
@property (nonatomic,strong) void (^aiSearchSureBtnAction)(void);

///专属客服控件响应
@property (nonatomic,strong) void (^customerServiceLeftBtnAction)(NSString* wxId);
@property (nonatomic,strong) void (^customerServiceRightBtnAction)(UIImage* qrImg);
@property(nonatomic,strong)NSDictionary* customerServiceData;//专属客服信息

///分享控件响应
@property (nonatomic,strong) void (^shareLeftBtnAction)(void);
@property (nonatomic,strong) void (^shareCenterBtnAction)(void);
@property (nonatomic,strong) void (^shareRightBtnAction)(void);


///跳转淘宝
@property(nonatomic,strong)NSString* income; //收益信息


///上级用户
@property(nonatomic,strong)SuperiorUserInfo* superiorUserInfo; //上级信息

@end

NS_ASSUME_NONNULL_END
