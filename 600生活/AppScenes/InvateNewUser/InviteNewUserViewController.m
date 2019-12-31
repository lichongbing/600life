//
//  InviteNewUserViewController.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "InviteNewUserViewController.h"
#import "iCarousel.h"
#import "LLWindowTipView.h"
#import "UIImage+ext.h"

#import "MKQRCode.h"  //二维码生成
#import "WXApi.h"


@interface InviteNewUserViewController ()<iCarouselDelegate,iCarouselDataSource>

@property (weak, nonatomic) IBOutlet iCarousel *calourseView;
@property(nonatomic,strong)NSArray* imageViewArr;
 //被选中的calourseView的子项

@property(nonatomic,strong)NSDictionary* data; //网络数据

@end

@implementation InviteNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请好友";
    self.view.backgroundColor = [UIColor whiteColor];
    self.calourseView.width = kScreenWidth - 50;
    
    [self requestInviteUser];
}


-(void)setupCalourseView
{
    self.calourseView.dataSource = (id)self;
    self.calourseView.delegate = (id)self;
    self.calourseView.bounces = NO;
    self.calourseView.pagingEnabled = YES;
    self.calourseView.type = iCarouselTypeRotary;
}

//kInviteUser
#pragma mark - 网络请求
//邀请好友的海报数据

-(void)requestInviteUser
{
    __weak InviteNewUserViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kInviteUser) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself handleInviteUser:res[@"data"]];
            });
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleInviteUser:(NSDictionary*)data
{
    _data = data;
    NSArray* imageUrls = data[@"image"];
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < imageUrls.count; i++){
        CGFloat left = 20;
        CGFloat top = 20;
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(left, top, kScreenWidth - left*2, kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight -top)];

        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]] placeholderImage:kPlaceHolderImg];
        [mutArr addObject:imageV];
        
        //二维码
        UIImageView* qrImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        qrImageV.tag = 10+i;
        qrImageV.hidden = YES;
        [imageV addSubview:qrImageV];
        qrImageV.centerX = imageV.width * 0.5;
        qrImageV.centerY = imageV.height * 0.75;
        
        //生成二维码
        MKQRCode *mkCode = [[MKQRCode alloc] init];
        [mkCode setInfo:data[@"downUrl"] withSize:qrImageV.width];
        qrImageV.image = [mkCode generateImage];
        
        //口令
        UILabel* lab = [UILabel new];
        [imageV addSubview:lab];
        lab.width = 150;
        lab.height = 35;
        lab.centerX = imageV.width * 0.5;
        lab.top = qrImageV.bottom + 15;
        lab.backgroundColor = [UIColor whiteColor];
        lab.text = [NSString stringWithFormat:@"邀请码%@",[LLUserManager shareManager].currentUser.invite_code];
        lab.textAlignment = NSTextAlignmentCenter;
    }
    
    if(mutArr.count > 0){
        _imageViewArr = mutArr;
        [self setupCalourseView];
    }
}

#pragma mark - control action

-(void)navBackItemAction
{
    [_calourseView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)copyBtnAction:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = _data[@"text"];
    [[LLHudHelper sharedInstance]tipMessage:@"复制口令成功"];
}

- (IBAction)shareBtnAction:(id)sender {
    LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeShare];
    [view show];
    //微信
    __weak InviteNewUserViewController* wself = self;
    
    view.shareLeftBtnAction = ^{
        NSInteger index = wself.calourseView.currentItemIndex;
        //获取当前的imageView
        UIImageView* oldImageView = (UIImageView*)[wself.imageViewArr objectAtIndex:index];
        //将当前选中的imageView以及子空间全部获取，产生新的iamg
        UIImage* newImageViewImage = [UIImageView getNewImageWithSuperImageView:oldImageView];
        [wself shareImageToWeiChatWithImage:newImageViewImage type:1];
    };
    
    //朋友圈
    view.shareCenterBtnAction = ^{
        NSInteger index = wself.calourseView.currentItemIndex;
        //获取当前的imageView
        UIImageView* oldImageView = (UIImageView*)[wself.imageViewArr objectAtIndex:index];
        //将当前选中的imageView以及子空间全部获取，产生新的iamg
        UIImage* newImageViewImage = [UIImageView getNewImageWithSuperImageView:oldImageView];
        [wself shareImageToWeiChatWithImage:newImageViewImage type:2];
    };
    
    //保存图片
    view.shareRightBtnAction = ^{
        NSInteger index = wself.calourseView.currentItemIndex;
        UIImage* image = ((UIImageView*)[wself.imageViewArr objectAtIndex:index]).image;
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    };
}

//type 1好友   2朋友圈
-(void)shareImageToWeiChatWithImage:(UIImage*)image type:(int)type
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


#pragma mark - iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _imageViewArr.count;
}


-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    //最后一个元素
    if(index == (_imageViewArr.count - 1)){
        for(int i = 0; i < _imageViewArr.count; i++){
            UIImageView* imageView = [_imageViewArr objectAtIndex:i];
            UIImageView* qrImv = [imageView viewWithTag:i+10];
            qrImv.hidden = NO;
        }
    }
    return _imageViewArr[index];
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


-(void) onReq:(BaseReq*)reqonReq
{
    NSLog(@"%@",reqonReq);
}

@end
