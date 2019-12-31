//
//  SealCountView.m
//  600生活
//
//  Created by iOS on 2019/11/26.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SealCountView.h"

@interface SealCountView()

@property (weak, nonatomic) IBOutlet UIView *lightRedView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UILabel *radioLab;
@property (weak, nonatomic) IBOutlet UILabel *sealCountLab;


@end

@implementation SealCountView

-(id)init{
    if(self = [super init]){
        self = [[NSBundle mainBundle] loadNibNamed:@"SealCountView" owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, 100, 20);
        self.lightRedView.width = self.width;
        self.redView.width = 0;
        self.radioLab.hidden = YES;
        self.sealCountLab.hidden = YES;
    }
    return self;
}

//设置根据父视图 得到自身frame
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SealCountView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.lightRedView.width = self.width;
        self.redView.width = 0;
        self.radioLab.hidden = YES;
        self.sealCountLab.hidden = YES;
    }
    return self;
}


-(void)setRatio:(CGFloat)ratio
{
    _ratio = ratio;
    _redView.width = _lightRedView.width * ratio;

    _radioLab.hidden = NO;
    _radioLab.text = [NSString stringWithFormat:@"%.2f%%",ratio*100];
}

-(void)setSealCount:(NSInteger)sealCount
{
    _sealCount = sealCount;
    _sealCountLab.hidden = NO;
    _sealCountLab.text = [NSString stringWithFormat:@"已抢%lu件",sealCount];
}

@end
