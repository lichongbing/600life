//
//  SPMenuSubViewController.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SPMenuSubViewController.h"

@interface SPMenuSubViewController ()

@end

@implementation SPMenuSubViewController


-(id)initWithCid:(NSString*)cid
{
    if(self = [super init]){
        self.cid = cid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//仅仅是消除.h中的一个警告 可以不要这个
-(void)loadDatasWhenUserDone
{
    
}



@end
