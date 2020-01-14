//
//  LLRefreshAutoGifFooter.m
//  600生活
//
//  Created by iOS on 2019/12/27.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLRefreshAutoGifFooter.h"
#import "UIImage+ext.h"
@interface LLRefreshAutoGifFooter()
@property(nonatomic,strong)NSMutableArray* imagesArray;
@end
@implementation LLRefreshAutoGifFooter

- (void)prepare
{
    [super prepare];
    if(self.imagesArr.count > 0){
        [self setImages:@[self.imagesArr.firstObject] duration:1 forState:MJRefreshStatePulling];
    }
    
    [self setImages:self.imagesArray duration:1 forState:MJRefreshStateRefreshing];
    self.refreshingTitleHidden = YES;
    [self setTitle:@"" forState:MJRefreshStateIdle];
}

-(NSMutableArray*)imagesArr
{
    if(_imagesArray == nil){
        _imagesArray = [NSMutableArray new];
        for(int i = 1; i <=4; i++){
            NSString* imageName = [NSString stringWithFormat:@"Refresh_down_Gif_%d",i];
            UIImage* image = [UIImage imageNamed:imageName];
            //图片大小原图未100:57
            if(image){
                [_imagesArray addObject:[UIImage scaleToSize:image size:CGSizeMake(50, 28)]];
            }
        }
    }
    return _imagesArray;
}

@end
