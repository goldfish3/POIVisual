//
//  ControlViewController.m
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/16.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import "ControlViewController.h"
#import "WhiteBtn.h"
#import "SliderView.h"
#import <WebKit/WebKit.h>
#import "SetModel.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define ITEM_HEIGHT 70
#define ssRGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define ssRGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define ssRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@interface ControlViewController()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property(strong,nonatomic) SetModel *setModel;

@property(assign,nonatomic) float width;
@property(assign,nonatomic) float height;
@property(strong,nonatomic) UIView *setView;
@property(strong,nonatomic) UIButton *setBtn;   //设置按钮
@property(strong,nonatomic) UIAlertController *alertController;
@property(strong,nonatomic) UIButton *backBtn;  //返回按钮
@property(strong,nonatomic) UIScrollView *bgScroll;
@property(strong,nonatomic) UIView *controlView;
@property(strong,nonatomic) UITableView *selectView;
@property(strong,nonatomic) WhiteBtn *categorySetBtn;   //选择要去的poi类别
@property(strong,nonatomic) UIView *categoryView;   //poi类别显示界面
@property(strong,nonatomic) UITextField *rediusField;   //最远距离
@property(strong,nonatomic) SliderView *hotSlider;    //热门程度
@property(strong,nonatomic) SliderView *novelSlider;  //新颖度
@property(strong,nonatomic) SliderView *distanceSlider;   //距离
@property(strong,nonatomic) SliderView *timeSlider;   //时段性
@property(strong,nonatomic) WKWebView *chartView;   //用南丁格尔图表示几个因素的关系
@property(strong,nonatomic) UIButton *commitBtn;    //提交按钮
@property(strong,nonatomic) NSString *poiData;
@end

@implementation ControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)buildFace{
    self.setModel = [[SetModel alloc] init];
    self.width = self.view.frame.size.width;
    self.height = self.view.frame.size.height;
    
    //设置
    self.setView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width-1, ITEM_HEIGHT)];
    [self.view addSubview:self.setView];
    
    //设置按钮
    int btnW = 100;
    int margin = 10;
    self.setBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.setView.frame.size.width-btnW,
                                                             margin,
                                                             btnW,
                                                             self.setView.frame.size.height-margin*2)];
    [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [self.setBtn setTitleColor:ssRGBHex(0x4169E1) forState:UIControlStateNormal];
    [self.setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [self.setView addSubview:self.setBtn];
    
    self.alertController = [UIAlertController alertControllerWithTitle:@"setting" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cityAction = [UIAlertAction actionWithTitle:@"select a city" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.bgScroll setContentOffset:CGPointMake(self.width, 0) animated:YES];
        NSLog(@"select a city");
    }];
    UIAlertAction * userAction = [UIAlertAction actionWithTitle:@"select a user" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.bgScroll setContentOffset:CGPointMake(self.width, 0) animated:YES];
        NSLog(@"select a user");
    }];
    [self.alertController addAction:cityAction];
    [self.alertController addAction:userAction];
    
    //返回按钮
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                              margin,
                                                              btnW,
                                                              self.setView.frame.size.height-margin*2)];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn setTitleColor:ssRGBHex(0x4169E1) forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.setView addSubview:self.backBtn];
    self.backBtn.hidden = TRUE;
    
    //背景滚动视图
    self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(self.setView.frame),
                                                                   self.width-6, self.height)];
    self.bgScroll.contentSize = CGSizeMake(self.width*2, self.height);
    self.bgScroll.scrollEnabled = false;
    [self.bgScroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.bgScroll];
    
    [self buildControlView];
    [self buildSelectView];
}
- (void)buildControlView{
    //视图1（用于控制页面）
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                self.width,
                                                                self.height)];
    [self.bgScroll addSubview:self.controlView];
    
    //选择要去的poi类别
    self.categorySetBtn = [[WhiteBtn alloc] initWithFrame:CGRectMake(0, 0, self.width, ITEM_HEIGHT)];
    [self.categorySetBtn setTitle:@"选择要去的poi类别" forState:UIControlStateNormal];
    [self.categorySetBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.categorySetBtn addTarget:self action:@selector(categorySelect:) forControlEvents:UIControlEventTouchUpInside];
    self.categorySetBtn.backgroundColor = [UIColor whiteColor];
    [self.controlView addSubview:self.categorySetBtn];
    
    //poi类别显示
    self.categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.categorySetBtn.frame)+1, self.width, ITEM_HEIGHT)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    [self.controlView addSubview:self.categoryView];
    
    //最远距离
    UIView *distanceView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetMaxY(self.categoryView.frame)+1,
                                                                    self.bgScroll.frame.size.width, ITEM_HEIGHT)];
    distanceView.backgroundColor = [UIColor whiteColor];
    [self.controlView addSubview:distanceView];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,
                                                                       distanceView.frame.size.width/5,
                                                                       ITEM_HEIGHT-20)];
    [distanceLabel setText:@"最远距离"];
    distanceLabel.textColor = [UIColor darkGrayColor];
    [distanceView addSubview:distanceLabel];
    
    self.rediusField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(distanceLabel.frame)+10, 10, distanceView.frame.size.width-CGRectGetMaxX(distanceLabel.frame)-20, ITEM_HEIGHT-20)];
    self.rediusField.backgroundColor = [UIColor whiteColor];
    self.rediusField.placeholder = @"请输入希望推荐的poi半径";
    [distanceView addSubview:self.rediusField];
    
    //热门程度
    self.hotSlider = [[SliderView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(distanceView.frame)+1,
                                                                   self.bgScroll.frame.size.width,
                                                                   ITEM_HEIGHT) andValueChange:^(float val) {
        self.setModel.hotValue = val;
        [self sendMsgForWebView:self.setModel];
    }];
    self.hotSlider.title = @"热门程度";
    [self.controlView addSubview:self.hotSlider];
    
    //新颖度
    self.novelSlider = [[SliderView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.hotSlider.frame)+1,
                                                                  self.bgScroll.frame.size.width,
                                                                    ITEM_HEIGHT) andValueChange:^(float val) {
        self.setModel.novelValue = val;
        [self sendMsgForWebView:self.setModel];
    }];
    self.novelSlider.title = @"新颖度";
    [self.controlView addSubview:self.novelSlider];
    
    //距离
    self.distanceSlider = [[SliderView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.novelSlider.frame)+1,
                                                                  self.bgScroll.frame.size.width,
                                                                       ITEM_HEIGHT) andValueChange:^(float val) {
        self.setModel.distanceValue = val;
        [self sendMsgForWebView:self.setModel];
    }];
    self.distanceSlider.title = @"距离";
    [self.controlView addSubview:self.distanceSlider];
    
    //时段性
    self.timeSlider = [[SliderView alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(self.distanceSlider.frame)+1,
                                                                  self.bgScroll.frame.size.width,
                                                                   ITEM_HEIGHT) andValueChange:^(float val) {
        self.setModel.timeValue = val;
        [self sendMsgForWebView:self.setModel];
    }];
    self.timeSlider.title = @"时段性";
    [self.controlView addSubview:self.timeSlider];
    
    //南丁格尔图（webView）
    int webM = 10;
    int webW = self.bgScroll.frame.size.width - webM*2;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    //preference
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 10;
    config.preferences.javaScriptEnabled = YES;
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    
    //userContentController
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"messageSend"];
    
    config.processPool = [[WKProcessPool alloc] init];
    self.chartView = [[WKWebView alloc] initWithFrame:CGRectMake(10,
                                                                 CGRectGetMaxY(self.timeSlider.frame)+webM, webW, webW)
                                        configuration:config];
    self.chartView.UIDelegate = self;
    self.chartView.navigationDelegate = self;
    NSURL *htmlUrl = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *res = [[NSURLRequest alloc] initWithURL:htmlUrl];
    [self.chartView loadRequest:res];
    [self.chartView setOpaque:NO];
    [self.controlView addSubview:self.chartView];
    
    //***********************添加js方法，oc与js端对应实现*******************************//
    [config.userContentController addScriptMessageHandler:self name:@"collectSendKey"];
    [config.userContentController addScriptMessageHandler:self name:@"collectIsLogin"];
    
    //***********************打印js日志*******************************//
//    NSString *jsCode = @"console.log = (function(oriLogFunc){\
//        return function(str)\
//        {\
//        window.webkit.messageHandlers.log.postMessage(str);\
//        oriLogFunc.call(console,str);\
//        }\
//        })(console.log);";
//    [config.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCode injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
//    [self catchJsLog];
}


#pragma mark - WKScriptMessageHandler
//当js 通过 注入的方法 @“messageSend” 时会调用代理回调。 原生收到的所有信息都通过此方法接收。
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
     NSLog(@"原生收到了js发送过来的消息 message.body = %@",message.body);
}
#pragma mark - WKUIDelegate
//js调用alert的时候，会调用这个原生方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"显示一个JavaScript警告面板, message = %@",message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
    [self sendMsgForWebView:self.setModel];
}
//-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    [self sendMsgForWebView:self.setModel];
//}
- (void)sendMsgForWebView:(SetModel *)model{
    NSArray *sendData = @[@{@"value":[NSNumber numberWithFloat:model.hotValue],@"name":@"热度"},
                          @{@"value":[NSNumber numberWithFloat:model.novelValue],@"name":@"新颖度"},
                          @{@"value":[NSNumber numberWithFloat:model.distanceValue],@"name":@"距离"},
                          @{@"value":[NSNumber numberWithFloat:model.timeValue],@"name":@"时间因素"}];
    
    //  options选择kNilOptions,字符串化的dict是没有空格的
    NSData * data = [NSJSONSerialization dataWithJSONObject:sendData options:kNilOptions error:nil];
    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsStr = [NSString stringWithFormat:@"sendMessageByIOS(%@)",dataStr];
    NSLog(@"%@",jsStr);
    [self.chartView evaluateJavaScript:jsStr completionHandler:^(id _Nullable res, NSError * _Nullable error) {
        NSLog(@"error=%@,response=%@",error,res);
    }];
}

//- (void)catchJsLog{
//    if(DEBUG){
//        JSContext *ctx = [self.chartView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//        ctx[@"console"][@"log"] = ^(JSValue * msg) {
//            NSLog(@"H5  log : %@", msg);
//        };
//        ctx[@"console"][@"warn"] = ^(JSValue * msg) {
//            NSLog(@"H5  warn : %@", msg);
//        };
//        ctx[@"console"][@"error"] = ^(JSValue * msg) {
//            NSLog(@"H5  error : %@", msg);
//        };
//    }
//}

- (void)buildSelectView{
    //视图2（用于选择页面）
    self.selectView = [[UITableView alloc] initWithFrame:CGRectMake(self.width,
                                                                    0,
                                                                    self.width, self.height)];
    [self.bgScroll addSubview:self.selectView];
}
- (void)categorySelect:(id)sender{
    [self setClick];
}
- (void)setClick{
    [self presentViewController:self.alertController animated:YES completion:nil];
    self.setBtn.hidden = true;
    self.backBtn.hidden = false;
}
- (void)backClick{
    [self.bgScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    self.setBtn.hidden = false;
    self.backBtn.hidden = true;
}
@end
