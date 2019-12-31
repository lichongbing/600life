//
//  CHangeNameViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CHangeNameViewController.h"

@interface CHangeNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;


@property(nonatomic,strong)NSString* name;
@end

@implementation CHangeNameViewController

-(id)initWithName:(NSString*)name
{
    if(self = [super init]){
        self.name = name;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.name;
    self.textField.placeholder = [NSString stringWithFormat:@"请输入新%@",self.name];
}

#pragma mark - 网络请求
-(void)requestChangeNameWithNewName:(NSString*)newName
{
    NSDictionary* param = @{
        @"username" : newName
    };
    
    __weak CHangeNameViewController* wself = self;
    [self PostWithUrlStr:kFullUrl(kChangeuserName) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [[LLHudHelper sharedInstance]tipMessage:@"修改成功"];
            LLUser* user = [LLUserManager shareManager].currentUser;
            user.user_nickname = newName;
           [[LLUserManager shareManager]insertOrUpdateCurrentUser:user];
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself.navigationController popViewControllerAnimated:YES];
            });
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}


- (IBAction)sureBtnAction:(id)sender {
    if(self.textField.text.length > 0) {
        [self.view endEditing:YES];
//        [self.navigationController popViewControllerAnimated:YES];
        [self requestChangeNameWithNewName:self.textField.text];
    } else {
        [[LLHudHelper sharedInstance]tipMessage:[NSString stringWithFormat:@"请正确输入新%@",self.name]];
    }
}

@end
