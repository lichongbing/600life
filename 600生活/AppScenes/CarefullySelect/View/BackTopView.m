//
//  BackTopView.m
//  600生活
//
//  Created by iOS on 2019/12/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "BackTopView.h"

@implementation BackTopView

-(id)init
{
    if (self = [super init]) {
        self =[[NSBundle mainBundle]loadNibNamed:@"BackTopView" owner:nil options:nil].firstObject;
        self.frame = CGRectMake(0, 0, 50, 50);
    }
    return self;
}

- (IBAction)backTopBtnAction:(id)sender {
    if(self.backTopViewClickedCallBack){
        self.backTopViewClickedCallBack();
    }
}


@end
