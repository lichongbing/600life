//
//  LLRefreshGifHeader.m
//  600生活
//
//  Created by iOS on 2019/12/27.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLRefreshGifHeader.h"
#import "UIImage+ext.h"

@interface LLRefreshGifHeader()
@property(nonatomic,strong)NSMutableArray* imagesArray;
@end

@implementation LLRefreshGifHeader

- (void)prepare
{
    [super prepare];
    if(self.imagesArr.count > 0){
        [self setImages:[[self.imagesArray reverseObjectEnumerator] allObjects] duration:1 forState:MJRefreshStatePulling];
    }
    
    [self setImages:self.imagesArray duration:1 forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
}


-(NSMutableArray*)imagesArr
{
    if(_imagesArray == nil){
        _imagesArray = [NSMutableArray new];
        for(int i = 1; i <=9; i++){
            NSString* imageName = [NSString stringWithFormat:@"Refresh_up_Gif_%d",i];
            UIImage* image = [UIImage imageNamed:imageName];
            //图片大小原图未98:54
            if(image){
                [_imagesArray addObject:[UIImage scaleToSize:image size:CGSizeMake(49, 27)]];
            }
        }
    }
    return _imagesArray;
}

@end
