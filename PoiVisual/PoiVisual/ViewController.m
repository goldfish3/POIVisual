//
//  ViewController.m
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/15.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import "ViewController.h"
#import "DeviceSingle.h"
#import "MapView.h"
#import "ExplainView.h"
#import "ControlViewController.h"
#import "PNRadarChart.h"

@interface ViewController ()
@property(strong,nonatomic) DeviceSingle *device;
@property(strong,nonatomic) UIScrollView *bgScroll;
@property(strong,nonatomic) ExplainView *explainView;
@property(strong,nonatomic) ControlViewController *controlVC;
@property(strong,nonatomic) MapView *mapView;
@property(strong,nonatomic) UIButton *setBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.device = [DeviceSingle sharedInstance];
    self.device.width = [UIScreen mainScreen].bounds.size.width;
    self.device.height = [UIScreen mainScreen].bounds.size.height;
    
    NSLog(@"%d,%d",self.device.width,self.device.height);
    
    
    
    //定义滚动背景
    self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.device.width, self.device.height)];
    self.bgScroll.scrollEnabled = false;
    self.bgScroll.contentSize = CGSizeMake(self.device.width / 3 * 4, self.device.height);
    [self.view addSubview:self.bgScroll];
    
    //在滚动背景上添加控制视图
    self.controlVC = [[ControlViewController alloc] init];
    self.controlVC.view.frame = CGRectMake(0, 0,
                                           self.device.width/3,
                                           self.device.height);
    [self.controlVC buildFace];
    [self addChildViewController:self.controlVC];
    [self.bgScroll addSubview:self.controlVC.view];
    
    //添加地图
    self.mapView = [[MapView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.controlVC.view.frame),
                                                             0,
                                                             self.device.width,
                                                             self.device.height)];
    [self.bgScroll addSubview:self.mapView];
    
    //设置按钮(由于主页面有地图，无法识别手势，所以控制面板消失后，使用按钮点击的方式让页面出现)
    //设置按钮位于图层的最上方
    self.setBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.controlVC.view.frame)+10,
                                                             30, 50, 30)];
    [self.setBtn setTitle:@"hide" forState:UIControlStateNormal];
    self.setBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.setBtn.layer.cornerRadius = 5;
    [self.setBtn addTarget:self action:@selector(hideAndShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScroll addSubview:self.setBtn];
    
    //向右滑
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setShow)];
    [right setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:right];
    
    //向左滑
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setHide)];
    [left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:left];
}

- (void)hideAndShow:(UIButton *)sender{
    NSLog(@"%lf+++++++",self.bgScroll.contentOffset.x);
    if (self.bgScroll.contentOffset.x < 1) {
        [self setHide];
        [sender setTitle:@"show" forState:UIControlStateNormal];
    }else{
        [self setShow];
        [sender setTitle:@"hide" forState:UIControlStateNormal];
    }
}

-(void)setShow{
    [self.bgScroll setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)setHide{
    [self.bgScroll setContentOffset:CGPointMake(self.device.width/3, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
