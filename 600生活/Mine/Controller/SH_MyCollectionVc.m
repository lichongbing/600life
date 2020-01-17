//
//  SH_MyCollectionVc.m
//  600生活
//
//  Created by iOS on 2020/1/17.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "SH_MyCollectionVc.h"

@interface SH_MyCollectionVc ()

@end

@implementation SH_MyCollectionVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    UILabel *labicon = [[UILabel alloc]initWithFrame:CGRectMake(0,100, 50, 20)];
    labicon.backgroundColor = [UIColor redColor];
    labicon.text = @"天猫";
    labicon.textColor = [UIColor greenColor];
    labicon.font = [UIFont systemFontOfSize:11];
//    [self.view addSubview:labicon];
    
    UILabel *labicon_txt = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 40)];
      labicon_txt.backgroundColor = [UIColor whiteColor];
      labicon_txt.text = @"\t\t欧美风复古拼接水洗牛衣秋装休闲夹...克衫潮流欧美风复古拼接水洗牛衣秋装休闲夹...克衫潮流欧美风复古拼接水洗牛衣秋装休闲夹...克衫潮流";
        labicon_txt.numberOfLines = 0;
      labicon_txt.textColor = [UIColor redColor];
      labicon_txt.font = [UIFont systemFontOfSize:13];
      [self.view addSubview:labicon_txt];
//      [labicon_txt addSubview:labicon];
    [self.view addSubview:labicon];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
