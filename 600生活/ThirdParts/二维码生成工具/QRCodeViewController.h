//
//  QRCodeViewController.h
//  MKQRCodeDemo
//
//  Created by Mkil on 9/25/16.
//  Copyright © 2016 Mkil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"

@interface QRCodeViewController : LLViewController
@property(nonatomic,strong)UIImageView *headerImage;//头像
@property(nonatomic,strong)UILabel *titelLable;//标题
@property(nonatomic,strong)UILabel *introductionLabel;//说明
@property(nonatomic,strong)id info;//需要传的数据
@end
