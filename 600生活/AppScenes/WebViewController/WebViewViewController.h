//
//  WebViewViewController.h
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewViewController : LLViewController

-(id)initWithUrl:(NSString*)url title:(NSString*)title;

@property (strong, nonatomic) WKWebView *webView;

@property(nonatomic,assign)BOOL isNeedJS;  //是否需要js交互

@end

NS_ASSUME_NONNULL_END
