//
//  GuidenceViewController.h
//  600生活
//
//  Created by iOS on 2019/11/15.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuidenceViewController : UIViewController

@property (nonatomic,strong) UIScrollView* scrlView;
@property (nonatomic,strong) UIPageControl* pageControl;
@property (nonatomic,strong) NSArray* imageArray;

@end

NS_ASSUME_NONNULL_END
