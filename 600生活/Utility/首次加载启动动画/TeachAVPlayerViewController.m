//
//  TeachAVPlayerViewController.m
//  600生活
//
//  Created by iOS on 2019/11/15.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "TeachAVPlayerViewController.h"



@interface TeachAVPlayerViewController ()

@property(nonatomic,strong)NSString* filePath;

@property(nonatomic,strong)UIButton* enterMainButton;  //播放结束进入app按钮
@property(nonatomic,strong)UIButton* fullScreenButton;  //控制暂停，继续的btn
@property (nonatomic, strong) CABasicAnimation *scaleAnimation;

@property(nonatomic,assign)BOOL isPlayering; //播放器是否在播放，默认给yes

@end

@implementation TeachAVPlayerViewController

-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//文件路径
-(id)initWithFilePath:(NSString*)filePath
{
    if(self = [super init]){
        self.filePath = filePath;
        self.isPlayering = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.filePath]];
    self.showsPlaybackControls = NO;
    self.view.userInteractionEnabled = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
    
    UIButton *enterMainButton = [[UIButton alloc] init];
    self.enterMainButton = enterMainButton;
    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
    [self.view addSubview:enterMainButton];
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    enterMainButton.alpha = 0.0;
    
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinishedNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    //全屏暂停按钮
    _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
       [self.view addSubview:_fullScreenButton];
       _fullScreenButton.frame = CGRectMake(0, 0, kScreenWidth, enterMainButton.top);
    [_fullScreenButton addTarget:self action:@selector(fullScreenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
       _fullScreenButton.backgroundColor = [UIColor clearColor];
}

- (void)enterMainAction:(UIButton *)btn {
    if(_didClickedEnterMainCallBack) {
        _didClickedEnterMainCallBack();
    }
}

-(void)fullScreenBtnAction:(UIButton*)btn
{
    if(self.isPlayering){
        btn.selected = !btn.isSelected;
        if(btn.selected){
            [self.player pause];
            self.enterMainButton.alpha = 1;
        }else{
            [self.player play];
            self.enterMainButton.alpha = 0;
        }
    }
}


- (void)playbackFinishedNotification:(NSNotification *)notifation {
    // 回到视频的播放起点
//    [self.player seekToTime:kCMTimeZero];
//    [self.player play];
    self.isPlayering = NO;
    self.fullScreenButton.userInteractionEnabled = NO;
    
    __weak TeachAVPlayerViewController* wself = self;
    [UIView animateWithDuration:1.0 animations:^{
        wself.enterMainButton.alpha = 1.0;
    }];
}

@end
