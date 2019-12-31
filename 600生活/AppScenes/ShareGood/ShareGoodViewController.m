//
//  ShareGoodViewController.m
//  600生活
//
//  Created by iOS on 2019/12/10.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ShareGoodViewController.h"
#import "ShareDataModel.h"
#import "LLBaseView.h"
#import "SPButton.h"
#import "LLWindowTipView.h"
#import "WXApi.h"
#import "UIImage+ext.h"

@interface ShareGoodViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LLBaseView *whiteView;

@property (weak, nonatomic) IBOutlet SPButton *incomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bigImageV;
@property (weak, nonatomic) IBOutlet UIButton *smallImageV1;
@property (weak, nonatomic) IBOutlet UIButton *samllImageV2;

@property (weak, nonatomic) IBOutlet UIImageView *bigIcon;
@property (weak, nonatomic) IBOutlet UIImageView *smallIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *samllIcon2;

@property (weak, nonatomic) IBOutlet UILabel *selectedLab; //选中的图片

@property (weak, nonatomic) IBOutlet UILabel *goodTitleLab; //商品标题
@property (weak, nonatomic) IBOutlet UILabel *wenanTitleLab; //文案标题

@property (weak, nonatomic) IBOutlet UILabel *tklLab;  //淘口令
@property (weak, nonatomic) IBOutlet UILabel *wenanDetailLab; //文案描述
@property (weak, nonatomic) IBOutlet UILabel *linkLab;    //商品链接
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLab;  //邀请码

@property (weak, nonatomic) IBOutlet SPButton *btn1; //淘口令
@property (weak, nonatomic) IBOutlet SPButton *btn2; //商品链接
@property (weak, nonatomic) IBOutlet SPButton *btn3; //邀请码

@end


@interface ShareGoodViewController ()
//淘口令
@property(nonatomic,strong)NSString* tkl;
//邀请码
@property(nonatomic,strong)NSString* inviteCode;
@property(nonatomic,strong)ShareDataModel* shareDataModel;
@end

@implementation ShareGoodViewController


//tkl: 淘口令    inviteCode:邀请码
-(id)initWithTKL:(NSString*)tkl inviteCode:(NSString*)inviteCode
{
    if(self = [super init]){
        self.tkl = tkl;
        self.inviteCode = inviteCode;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分享商品";
    self.contentView.width = kScreenWidth;
    [self.scrollView addSubview:self.contentView];
    __weak ShareGoodViewController* wself = self;
    
    self.whiteView.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        CGFloat newContentHeight = newFrame.origin.y + newFrame.size.height + 30;
        wself.contentView.height = newContentHeight;
        wself.scrollView.contentSize = CGSizeMake(kScreenWidth, wself.contentView.height);
        if(wself.contentView.height <= wself.scrollView.height){
            wself.scrollView.contentSize = CGSizeMake(kScreenWidth, wself.scrollView.height+1);
        }
    };
    
    [self getShareData];
}


#pragma mark - 网络请求

//获取分享数据
-(void)getShareData
{
    NSDictionary* param = @{
        @"content":self.tkl,
        @"invite_code":self.inviteCode
    };
    
    [self GetWithUrlStr:kFullUrl(kGetShareData) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleShareData:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        NSLog(@"%@",error.description);
    }];
}

-(void)handleShareData:(NSDictionary*)data
{
    self.shareDataModel = [[ShareDataModel alloc]initWithDictionary:data error:nil];
    if(!self.shareDataModel){return;}
    __weak ShareGoodViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself resetupUI];
    });
}

-(void)resetupUI
{
    //收益
    NSString* earnings = [NSString stringWithFormat:@"奖励预计收益 ￥%@",self.shareDataModel.earnings];
    [self.incomeBtn setTitle:earnings forState:UIControlStateNormal];
    
    //大图
    NSURL* url1 = [NSURL URLWithString:_shareDataModel.pic_url];
    [self.bigImageV sd_setImageWithURL:url1 forState:UIControlStateNormal];
    
    if(_shareDataModel.small_images.count > 0) {
        NSURL* url2 = [NSURL URLWithString:_shareDataModel.small_images.firstObject];
        [self.smallImageV1 sd_setImageWithURL:url2 forState:UIControlStateNormal];
        
        if(_shareDataModel.small_images.count > 1){
            NSURL* url3 = [NSURL URLWithString:_shareDataModel.small_images[1]];
            [self.samllImageV2 sd_setImageWithURL:url3 forState:UIControlStateNormal];
        }
    }
    
    //淘口令
    self.tklLab.text = _shareDataModel.tkl;
    
    //商品标题
    self.goodTitleLab.text = _shareDataModel.goods_title;
    
    //文案标题
    self.wenanTitleLab.text = _shareDataModel.wenan_title;
    
    //文案详细
    self.wenanDetailLab.text = _shareDataModel.wenan_desc;
    
    //商品链接
    self.linkLab.text = _shareDataModel.item_url;
    
    //邀请码
    self.inviteCodeLab.text = _shareDataModel.invite_code;
}

#pragma mark - control action
//大图
- (IBAction)bigBtnAction:(UIButton*)sender {
    if(_shareDataModel.pic_url){
        sender.selected = !sender.isSelected;
        if(sender.selected){
             self.bigIcon.image = [UIImage imageNamed:@"loginMain_check"];
        }else{
            self.bigIcon.image = [UIImage imageNamed:@"分享商品未选中"];
        }
    }
    
    [self caculate];
}

//小图1
- (IBAction)small1BtnAction:(UIButton*)sender {
    if(_shareDataModel.small_images.count > 0){
        sender.selected = !sender.isSelected;
        if(sender.selected){
             self.smallIcon1.image = [UIImage imageNamed:@"loginMain_check"];
        }else{
            self.smallIcon1.image = [UIImage imageNamed:@"分享商品未选中"];
        }
    }
    
    [self caculate];
}

//小图2
- (IBAction)small2BtnAction:(UIButton*)sender {
    if(_shareDataModel.small_images.count > 1){
        sender.selected = !sender.isSelected;
        if(sender.selected){
             self.samllIcon2.image = [UIImage imageNamed:@"loginMain_check"];
        }else{
            self.samllIcon2.image = [UIImage imageNamed:@"分享商品未选中"];
        }
    }
    
    [self caculate];
}

//计算已选
-(void)caculate
{
    int counter = 0;
    BOOL res0 = [self.bigIcon.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
    counter += res0;
    BOOL res1 = [self.smallIcon1.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
    counter += res1;
    BOOL res2 = [self.samllIcon2.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
    counter += res2;
    
    _selectedLab.text = [NSString stringWithFormat:@"已选%d张",counter];
}


#pragma mark  - /////////////////////////////////////

//淘口令
- (IBAction)tklBtnAction:(UIButton*)sender {
    
    sender.selected = !sender.isSelected;
    if(sender.selected){//执行后 撤销勾选 隐藏lab
         [sender setImage:[UIImage imageNamed:@"loginMain_uncheck"] forState:UIControlStateNormal];
        if(_tklLab.text.length > 0){
            _tklLab.text = nil;
        }
    }else{ //执行后 被勾选 展示lab
        [sender setImage:[UIImage imageNamed:@"loginMain_check"] forState:UIControlStateNormal];
        if(!_tklLab.text){
            _tklLab.text = _shareDataModel.tkl;
        }
    }
}

//商品链接
- (IBAction)linkBtnAction:(UIButton*)sender {
    
    sender.selected = !sender.isSelected;
    if(sender.selected){//执行后 撤销勾选 隐藏lab
         [sender setImage:[UIImage imageNamed:@"loginMain_uncheck"] forState:UIControlStateNormal];
        if(_linkLab.text.length > 0){
            _linkLab.text = nil;
        }
    }else{ //执行后 被勾选 展示lab
        [sender setImage:[UIImage imageNamed:@"loginMain_check"] forState:UIControlStateNormal];
        if(!_linkLab.text){
            _linkLab.text = _shareDataModel.item_url;;
        }
    }
}

//邀请码
- (IBAction)inviteBtnAction:(UIButton*)sender {
    
    sender.selected = !sender.isSelected;
    if(sender.selected){//执行后 撤销勾选 隐藏lab
        [sender setImage:[UIImage imageNamed:@"loginMain_uncheck"] forState:UIControlStateNormal];
        if(_inviteCodeLab.text.length > 0){
            _inviteCodeLab.text = nil;
        }
    }else{ //执行后 被勾选 展示lab
        [sender setImage:[UIImage imageNamed:@"loginMain_check"] forState:UIControlStateNormal];
        if(!_inviteCodeLab.text){
            _inviteCodeLab.text = _shareDataModel.invite_code;;
        }
    }
}

//复制文案
- (IBAction)copyWenan:(id)sender {
    
    NSString* wenanInfo = [self getAllSelectedWenanInfo];
    
    [[LLHudHelper sharedInstance]tipMessage:@"复制文案成功"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = wenanInfo;
    });
}

-(NSString*)getAllSelectedWenanInfo
{
    NSMutableString* mutStr = [NSMutableString new];
    //商品标题
    [mutStr appendString:_shareDataModel.goods_title];
    [mutStr appendString:@"\n"];
    //文案标题
    [mutStr appendString:_shareDataModel.wenan_title];
    [mutStr appendString:@"\n"];
    //文案描述
    [mutStr appendString:_shareDataModel.wenan_desc];
    [mutStr appendString:@"\n"];
    //淘口令
    if(_tklLab.text.length > 0){
        [mutStr appendString:_tklLab.text];
        [mutStr appendString:@"\n"];
    }
    //商品链接
    if(_linkLab.text.length > 0){
        [mutStr appendString:_linkLab.text];
        [mutStr appendString:@"\n"];
    }
    //邀请码
    if(_inviteCodeLab.text.length > 0){
        [mutStr appendString:_inviteCodeLab.text];
    }
    return mutStr;
}

//分享图片
- (IBAction)shareImages:(id)sender {
    
    NSMutableArray* mutArr = [NSMutableArray new];
    
    BOOL res0 = [self.bigIcon.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
    if(res0){
        [mutArr addObject:self.bigImageV.imageView.image];
    }
    
    BOOL res1 = [self.smallIcon1.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
    if(res1){
        [mutArr addObject:self.smallImageV1.imageView.image];
    }
    
    BOOL res2 = [self.samllIcon2.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
    if(res2){
        [mutArr addObject:self.samllImageV2.imageView.image];
    }
    
    if(mutArr.count == 0){
        [[LLHudHelper sharedInstance]tipMessage:@"请选择图片"];
    }else{
        
        //先拼接图片
        UIImage* masterImge = nil;
        BOOL res0 = [self.bigIcon.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
        if(res0){
            masterImge = self.bigImageV.imageView.image;
        }
        
        UIImage* headerImge = nil;
        BOOL res1 = [self.smallIcon1.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
        if(res1){
            headerImge = self.smallImageV1.imageView.image;
        }
        
        UIImage* footerImge = nil;
        BOOL res2 = [self.samllIcon2.image isEqual:[UIImage imageNamed:@"loginMain_check"]];
        if(res2){
            footerImge = self.samllImageV2.imageView.image;
        }
        
        UIImage* allImage = [UIImage addHeadImage:masterImge footImage:footerImge toMasterImage:headerImge];
        
        
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:(WindowTipViewTypeShare)];
        [view show];

        
        view.shareLeftBtnAction = ^{
            [self shareGoodToWeiChatWithImage:allImage type:1];
        };
        
        view.shareCenterBtnAction = ^{
            [self shareGoodToWeiChatWithImage:allImage type:2];
        };
        
        __weak ShareGoodViewController* wself = self;
        __weak LLWindowTipView* weakView = view;
        view.shareRightBtnAction = ^{
            for(int i = 0; i < mutArr.count; i++){
                UIImage* image = [mutArr objectAtIndex:i];
                UIImageWriteToSavedPhotosAlbum(image, wself, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }
            [weakView dismiss];
        };
    }
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [[LLHudHelper sharedInstance]tipMessage:msg];
}

// 分享商品到微信   type 1好友   2朋友圈
-(void)shareGoodToWeiChatWithImage:(UIImage*)image type:(int)type
{
    //压缩图片到10M以内 变成1M
    UIImage* newImage = [UIImage compressImageSize:image toByte:1*1024*1024];
    NSData *sharedImageData = UIImagePNGRepresentation(newImage);
    
    //微信分享的图片
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = sharedImageData;
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    //icon
    UIImage* logoImg = [UIImage imageNamed:@"loginIcon"];
    NSData *logoImgData = UIImagePNGRepresentation(logoImg);
    message.thumbData = logoImgData;
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = type == 1 ? WXSceneSession: WXSceneTimeline;
    
    [WXApi sendReq:req completion:^(BOOL success) {
       
    }];
}

@end
