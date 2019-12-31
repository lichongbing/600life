//
//  ScanQRCodeViewController.m
//  kcc
//
//  Created by tomlu on 2019/5/16.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "Utility.h"  //alert


//循环引用
@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int _num;//扫描线移动位移量
    BOOL _upOrdown;//判断扫描线的上下移动
    NSTimer * _timer;//控制扫描线的移动时间
    UIImageView *_imageView;//扫描框
    UIImageView * _line;//扫描线
    AVCaptureSession * _session; //session
    
    UILabel* _infoLab; //扫码时展示的内容  扫码添加组织成员   扫码加入组织
}
@end

@implementation ScanQRCodeViewController

-(void)dealloc{
    _timer=nil;
    [_timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    self.title = @"扫码";
    //扫描匡
    _imageView=[[UIImageView alloc]init];
    _imageView.center=CGPointMake(kScreenWidth/2, kScreenHeight/2 - 30.f);
    _imageView.bounds=CGRectMake(0, 0, 260, 260);
    _imageView.image=[UIImage imageNamed:@"扫码框"];
    [self.view addSubview:_imageView];
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(3, 10,_imageView.width - 6, 3)];
    _line.image = [UIImage imageNamed:@"扫码线"];
    _line.backgroundColor = [UIColor clearColor];
    [_imageView addSubview:_line];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(lineMoveAnimation) userInfo:nil repeats:YES];
    [self start];
    [self creatEffect];
}

#pragma mark - 判断是否打开相机-并初始化相机相关设置
- (void)start
{
    void (^checkCamera)(void) = ^(){
        self.view.backgroundColor = [UIColor whiteColor];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            __weak ScanQRCodeViewController* wself = self;
            [Utility ShowAlert:@"提示" message:@"快撮撮希望使用您的手机摄像头" buttonName:@[@"确定",@"取消"] sureAction:^{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } cancleAction:^{
                [wself.navigationController popViewControllerAnimated:YES];
            }];
        }
    };
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        checkCamera();
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //创建输入流
        AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置扫描区域，中心点反转，屏幕百分比
        [output setRectOfInterest : CGRectMake(CGRectGetMinY(_imageView.frame)/kScreenHeight, CGRectGetMinX(_imageView.frame)/kScreenWidth, _imageView.frame.size.height/kScreenHeight, _imageView.frame.size.width/kScreenWidth)];
        //初始化链接对象
        _session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
        layer.frame=self.view.layer.bounds;
        
        [self.view.layer insertSublayer:layer atIndex:0];
        
        //开始捕获
        [_session startRunning];
    }else{
        //如果没有提示用户
        checkCamera();
    }
}

- (void)creatEffect
{
    UIView * topView = [self createViewWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMinY(_imageView.frame)) andBgColor:RGBA(0, 0, 0, 0.4)];
    [self.view addSubview:topView];
    
    UIView * leftView = [self createViewWithFrame:CGRectMake(0, CGRectGetMinY(_imageView.frame),( kScreenWidth - CGRectGetWidth(_imageView.frame))/2, CGRectGetHeight(_imageView.frame)) andBgColor:RGBA(0, 0, 0, 0.4)];
    [self.view addSubview:leftView];
    
    UIView * rightView = [self createViewWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame), CGRectGetMinY(_imageView.frame), CGRectGetWidth(leftView.frame), CGRectGetHeight(_imageView.frame)) andBgColor:RGBA(0, 0, 0, 0.4)];
    [self.view addSubview:rightView];
    
    UIView * bottomView = [self createViewWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxX(_imageView.frame)) andBgColor:RGBA(0, 0, 0, 0.4)];
    [self.view addSubview:bottomView];
    
    _infoLab = [self createLabelWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame), 8.f, CGRectGetWidth(_imageView.frame), 20.f) andTitle:@"将二维码放入框内，即可自动扫描" andTitleFont:[UIFont systemFontOfSize:13] andTitleColor:[UIColor whiteColor] andTextAlignment:NSTextAlignmentCenter andBgColor:[UIColor clearColor]];
    
    if(self.infoLabText != nil) {
        _infoLab.text = self.infoLabText;
    }
        
    [bottomView addSubview:_infoLab];
}


#pragma mark 相机扫描线的移动动画
-(void)lineMoveAnimation
{
    if (_upOrdown == NO) {
        _num ++;
        
        _line.frame = CGRectMake(3, 20+2*_num, _imageView.width - 6, 3);
        if (2*_num >= CGRectGetHeight(_imageView.frame)-35) {
            _upOrdown = YES;
        }
    }
    else {
        _num --;
        _line.frame = CGRectMake(3, 20+2*_num, _imageView.width - 6, 3);
        if (_num == 0) {
            _upOrdown = NO;
        }
    }
}

#pragma mark - helper

-(UIView *)createViewWithFrame:(CGRect)rect andBgColor:(UIColor *)bgColor{
    
    UIView * view = [[UIView alloc]init];
    if (rect.size.width) {
        view.frame = rect;
    }
    if (bgColor) {
        view.backgroundColor = bgColor;
    }
    return view;
}

-(UILabel *)createLabelWithFrame:(CGRect)rect andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont andTitleColor:(UIColor *)titleColor andTextAlignment:(NSTextAlignment)alignment  andBgColor:(UIColor *)bgColor{
    
    UILabel * label = [[UILabel alloc]init];
    if (rect.size.width) {
        label.frame = rect;
    }
    if (title) {
        label.text = title;
    }
    if (titleColor) {
        label.textColor = titleColor;
    }
    if (titleFont) {
        label.font = titleFont;
    }
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    if (alignment) {
        label.textAlignment = alignment;
    }
    return label;
}

#pragma mark ---扫描结果后执行的操作-打开网页AVCaptureMetadataOutputObjectsDelegate ---
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue = nil;
    if ([metadataObjects count] >0 )
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        //扫描字符串
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [_timer setFireDate:[NSDate distantFuture]];
    
    if (self.didSuccessScanCallBack) {
        self.didSuccessScanCallBack(stringValue);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
