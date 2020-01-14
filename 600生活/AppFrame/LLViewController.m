//
//  LLViewController.m
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLViewController.h"
#import "Utility.h"  //判断相机相册权限
#import "CheckResultViewController.h"  //如果当前vc是订单查询vc 系统粘贴板不能清空
#import "ViewController1.h"  //导入ViewController1 防止所有LLViewController都去判断系统粘贴板
/**
下面是智能搜索需要用到的
*/
#import "LLWindowTipView.h"
#import "SearchResultListController.h"


typedef void (^ Success)(void);// 成功Block


@interface LLViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate> //uipickerviewcontroller 需要的两个协议

@end

@implementation LLViewController

-(void)dealloc
{
    NSLog(@"%@控制器------已被释放",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 每一次进入viewWillAppear 父类都会展示navBar
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //用户是否复制了文字到剪切板
    UIViewController* vc = [Utility getCurrentUserVC];
    
    if([self isKindOfClass:[vc class]]){
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userPasteboardNofificationAction:) name:kCheckUserPasteboardNofification object:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCheckUserPasteboardNofification object:nil];
}


//隐藏导航栏 无动画
-(void)hiddenNavigationBar
{
    if (self.navigationController.navigationBar.isHidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

//显示导航栏 无动画  默认的viewdidload 中会调用这个方法
-(void)showNavigationBar
{
    if (self.navigationController.navigationBar.isHidden == YES) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

//显示导航栏 有动画
-(void)showNavigationBarWithAnimation:(BOOL)animated
{
    if (self.navigationController.navigationBar.isHidden == YES) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

//隐藏导航栏 有动画
-(void)hiddenNavigationBarWithAnimation:(BOOL)animated
{
    if (self.navigationController.navigationBar.isHidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

//视图内容超出到状态栏 (默认情况下 不会超出状态栏 在安全线以下)
-(void)contentViewBeyondStatusBar {
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.tableview.scrollIndicatorInsets = self.tableview.contentInset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImagePickerController*)pickerVC
{
    if(!_pickerVC){
        _pickerVC = [[UIImagePickerController alloc]init];
        _pickerVC.delegate = (id)self;
        _pickerVC.allowsEditing = NO;
    }
    return _pickerVC;
}

//拍照获取图片
-(void)takePicture
{
    __weak LLViewController* wself = self;
    [Utility judgeAVAuthorizationStatus:^(BOOL isAuthed) {
        if(isAuthed){
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                wself.pickerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [wself presentViewController:wself.pickerVC animated:YES completion:nil];
            });
        }
    }];
}

//相册选取图片
-(void)takePhoto
{
    __weak LLViewController* wself = self;
    [Utility judgePhoteAuthorizationStatus:^(BOOL isAuthed) {
        if(isAuthed){
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                wself.pickerVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [wself presentViewController:wself.pickerVC animated:YES completion:nil];
            });
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate 选取相册图片后回调

/**
 infod: UIImagePickerControllerOriginalImage  图片
 */
// 获取图片后的操作 在子类中实现下面的方法 不会走父类的
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片到本地相册回调

//UIImageWriteToSavedPhotosAlbum 回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        [[LLHudHelper sharedInstance]tipMessage:@"保存成功"];
    }
}

#pragma mark - 通知
-(void)userPasteboardNofificationAction:(NSNotification*)notification
{
    BOOL islogin = [LLUserManager shareManager].currentUser.isLogin;
    if (islogin) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIPasteboard *board = [UIPasteboard generalPasteboard];
            if (board.hasStrings) {
                [self getPasteboardStringWithPasteboard:board];
            }else{
                NSLog(@"系统粘贴板无值");
            }
        });
    } else {
        //do nothing
    }
}

-(void)getPasteboardStringWithPasteboard:(UIPasteboard*)board{
    if (board.strings.count>0) {
        NSString *pasteboardString=[board.strings firstObject];
        NSString *searchContent=pasteboardString;
        //去掉字符串首尾的空格和换行符
        searchContent=[searchContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (searchContent.length >= 20000) {
            searchContent = [searchContent substringToIndex:20000];
        }
        
        //是否展示tipView 默认展示
        BOOL isShowWindowTipView = YES;
        
        //是否清空系统粘贴板 默认清空
        BOOL isClearPasteboard = YES;
        
        //排除除app内部复制字符串的情况 不展示tipview  不清空系统粘贴板内容
        NSString* appInnerCopyStr = [[NSUserDefaults standardUserDefaults]valueForKey:kAppInnerCopyStr];
        if([appInnerCopyStr isEqualToString:searchContent]){
            isShowWindowTipView = NO; //不展示
            isClearPasteboard = NO;  //不清空
        }
      
        if(isShowWindowTipView){
            [self showWindowTipViewAISearch:searchContent];
        }
        
        if(isClearPasteboard){
            //保存系统粘贴板的值
            [[NSUserDefaults standardUserDefaults]setValue:searchContent forKey:kAppLastClearStr];
            //清空系统粘贴板
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0) , ^{
                board.strings = @[]; //清空字符串
            });
        }
    }
}

-(void)showWindowTipViewAISearch:(NSString*)searchContent
{
    __weak LLViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeAISearch];
        view.searchStr = searchContent;
        //展示
        __strong LLViewController* sself = wself;
        __weak LLWindowTipView* wview = view;
        view.aiSearchSureBtnAction = ^() {
            SearchResultListController* vc = [[SearchResultListController alloc]initWithKeyWords:wview.searchStr];
            vc.hidesBottomBarWhenPushed = YES;
            [sself.navigationController pushViewController:vc animated:YES];
            [wview dismiss];
        };
        [view show];
    });
}

-(void)impactLight
{
    UIImpactFeedbackGenerator* impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
    [impactLight impactOccurred];
}
@end
