//
//  CreateEventViewController.m
//  600生活
//
//  Created by iOS on 2019/12/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CreateEventViewController.h"
#import "LeeDatePickerView.h"
#import "EventManager.h"
#import <EventKit/EventKit.h>

@interface CreateEventViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contentTf;
@property(nonatomic,assign)BOOL isContentTfOk;
@property (weak, nonatomic) IBOutlet UITextField *timeTf;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,strong)NSDate* selectDate;

@end

@implementation CreateEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提醒设置";
    self.contentTf.delegate = self;
}
#pragma 选择时间的控件
- (IBAction)timeBtn:(id)sender {
    //判断用户是否打开访问日历的权限
    // EKEntityTypeEvent    代表日历    // EKEntityTypeReminder 代表备忘
    EKAuthorizationStatus ekAuthStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
//    if (ekAuthStatus == EKAuthorizationStatusNotDetermined) {
//        EKEventStore *store = [[EKEventStore alloc] init];
//        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            NSLog(@"========%i",granted);
//        }];
//    } else
    if (ekAuthStatus == EKAuthorizationStatusRestricted || ekAuthStatus == EKAuthorizationStatusDenied ||ekAuthStatus == EKAuthorizationStatusNotDetermined ) {
       //NO
        NSString* str = [NSString stringWithFormat:@"前往设置600生活,打开访问日历的权限"];
        [[LLHudHelper sharedInstance]tipMessage:str delay:2.0];
    } else {
//       YES
       __weak CreateEventViewController* wself= self;
           [LeeDatePickerView showLeeDatePickerViewWithStyle:LeeDatePickerViewStyle_Single formatterStyle:LeeDatePickerViewDateFormatterStyle_yMdHm block:^(NSArray<NSDate *> *dateArray) {
               NSDate* date = dateArray.firstObject;
               wself.selectDate = date;
               NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
               [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
               NSString* timeStr = [formatter stringFromDate:date];
               wself.timeTf.text = timeStr;
               [wself checkSureBtnOk];
           }];
    }
}

#pragma mark - textfiel delegate

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0))
{
    if(textField == self.contentTf){
        self.isContentTfOk = textField.text.length > 0;
    }
}

-(void)setIsContentTfOk:(BOOL)isContentTfOk
{
    _isContentTfOk = isContentTfOk;
    [self checkSureBtnOk];
}

-(BOOL)checkSureBtnOk
{
    if(self.isContentTfOk && self.timeTf.text.length > 0){
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"F54556"];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        return YES;
    }else{
        self.sureBtn.backgroundColor = [UIColor colorWithHexString:@"E6E6E6"];
        [self.sureBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    }
    return NO;
}

- (IBAction)sureBtnAction:(id)sender {
    BOOL flag = [self checkSureBtnOk];
    if(flag){
        __weak CreateEventViewController* wself = self;
        [[EventManager sharedManager]writeWithTitle:self.contentTf.text time:self.selectDate success:^{
            [[LLHudHelper sharedInstance]tipMessage:@"添加提醒到日历成功" delay:1.5];
            __strong CreateEventViewController* sself = wself;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sself.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSError * _Nullable error) {
             [[LLHudHelper sharedInstance]tipMessage:@"添加提醒失败" delay:1.5];
        }];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"请完成输入"];
    }
}

@end
