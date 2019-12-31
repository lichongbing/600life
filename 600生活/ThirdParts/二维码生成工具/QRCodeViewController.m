//
//  QRCodeViewController.m
//  MKQRCodeDemo
//
//  Created by Mkil on 9/25/16.
//  Copyright © 2016 Mkil. All rights reserved.
//

#import "QRCodeViewController.h"
#import "MKQRCode.h"
#define MKScreenWidth     [UIScreen mainScreen].bounds.size.width
#define MKScreenHeight    [UIScreen mainScreen].bounds.size.height
#define PROPORTION_W [UIScreen mainScreen].bounds.size.width/375.0 //宽的比例
#define PROPORTION_H [UIScreen mainScreen].bounds.size.height/667.0//高的比例

@implementation QRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initilizedUseInterface];
}


-(void)initilizedUseInterface{
//    self.navBarBgAlpha = 0;

    self.automaticallyAdjustsScrollViewInsets = NO;
    //蒙层
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MKScreenWidth, MKScreenHeight )];
    baseView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    [self.view addSubview:baseView];
    //二维码背景View
    UIView * bgView = [[UIView alloc]init];
    bgView.bounds = CGRectMake(0, 0, MKScreenWidth-70*PROPORTION_W, 360);
    bgView.center = self.view.center;
    
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 8;
    [baseView addSubview: bgView];
    
    //头像
  
    [bgView addSubview:self.headerImage];
    //标题
    [bgView addSubview:self.titelLable];
    //二维码图片
    UIImageView * coreImageView = [[UIImageView alloc]initWithFrame:CGRectMake((bgView.frame.size.width - 200 )/2, CGRectGetMaxY(_headerImage.frame) +10 , 200 , 200)];
    
    MKQRCode *code = [[MKQRCode alloc] init];
//    code.style = MKQRCodeStyleCenterImage;//设置二维码样式
//    //中心图片
//    code.centerImg = self.headerImage.image;
    if ([_info isKindOfClass:[NSString class]]) {
        // 内容和大小(越大越清晰)
        [code setInfo:_info withSize:300];
    }else if([_info isKindOfClass:[NSDictionary class]]){
        [code setInfo:[self dictionaryToJson:_info] withSize:300];
    }
    coreImageView.image = [code generateImage];


    [bgView addSubview:coreImageView];
    
    //说明
self.introductionLabel.frame = CGRectMake(0, CGRectGetMaxY(coreImageView.frame) + 10 , bgView.frame.size.width, 20);
    [bgView addSubview:self.introductionLabel];
    }

//字典转Json

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(UIImageView *)headerImage{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
        _headerImage.frame = CGRectMake(20 , 20, 55 , 55 );
        _headerImage.clipsToBounds = YES;
        _headerImage.layer.cornerRadius = 27.5;
    }
    return _headerImage;
}
-(UILabel *)titelLable{
    if (!_titelLable) {
        _titelLable = [[UILabel alloc]init];
        _titelLable.frame = CGRectMake(CGRectGetMaxX(self.headerImage.frame) + 10, 40, MKScreenWidth-160, 20);
        _titelLable.font = [UIFont systemFontOfSize:18];
    }
    return _titelLable;
}
-(UILabel *)introductionLabel{
    if (!_introductionLabel) {
        _introductionLabel = [[UILabel alloc]init];
       
        _introductionLabel.font = [UIFont systemFontOfSize:15];
        _introductionLabel.textAlignment = NSTextAlignmentCenter;
        _introductionLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _introductionLabel;
}
@end
