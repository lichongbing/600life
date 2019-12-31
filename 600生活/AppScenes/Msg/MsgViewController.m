//
//  MsgViewController.m
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgListViewController.h"
#import "CreateEventViewController.h"

@interface MsgViewController ()

@property (weak, nonatomic) IBOutlet UILabel *msg1;
@property (weak, nonatomic) IBOutlet UILabel *msg1Detail;

@property (weak, nonatomic) IBOutlet UILabel *msg2;
@property (weak, nonatomic) IBOutlet UILabel *msg2Detail;


@property(nonatomic,strong) NSDictionary* unreadData;

@end

@implementation MsgViewController


/**unreadData
{
    "earnings_message_count" = 2;
    "earnings_message_title" = "\U60a8\U7684\U63d0\U73b0\U5df2\U5230\U5e10!";
    "system_message_count" = 4;
    "system_message_title" = "\U7cfb\U7edf\U901a\U77e504";
}
*/


-(id)initWithUnreadData:(NSDictionary*)unreadData
{
    if(self = [super init]){
        self.unreadData = unreadData;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息";
    
    [self setNavRightItemWithTitle:@"提醒设置" titleColor:[UIColor colorWithHexString:@"#666666"] selector:@selector(rightItemAction)];
    
    self.msg1.layer.borderWidth = 1;
    self.msg1.layer.borderColor = self.msg1.textColor.CGColor;
    
    self.msg2.layer.borderWidth = 1;
       self.msg2.layer.borderColor = self.msg2.textColor.CGColor;
    
    
    int system_message_count = [self.unreadData[@"system_message_count"] intValue];
    int earnings_message_count = [self.unreadData[@"earnings_message_count"] intValue];
    
    self.msg1.text = [NSString stringWithFormat:@"%d",system_message_count];
    self.msg1.hidden = !(system_message_count > 0);
    self.msg1Detail.text = self.unreadData[@"system_message_title"];
    
    self.msg2.text = [NSString stringWithFormat:@"%d",earnings_message_count];
    self.msg2.hidden = !(earnings_message_count > 0);
    self.msg2Detail.text = self.unreadData[@"earnings_message_title"];
}


//获取消息
-(void)reqeustGetUserMsgsWithType:(int)type
{
    NSDictionary* param = @{
        @"page_size":@"10",
        @"type":[NSNumber numberWithInt:type]
    };
    [self GetWithUrlStr:nil param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        
    } falsed:^(NSError * _Nullable error) {
        
    }];
}


#pragma mark - control action

-(void)rightItemAction
{
    CreateEventViewController* vc = [CreateEventViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sysMsgBtnAction:(id)sender {
    MsgListViewController* vc = [[MsgListViewController alloc]initWithType:@"1"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)incomeMsgBtnAction:(id)sender {
    MsgListViewController* vc = [[MsgListViewController alloc]initWithType:@"2"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
