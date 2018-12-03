//
//  MapView.m
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/15.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import "MapView.h"

@implementation MapView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        self.mapView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height) configuration:config];
        [self deleteWebCache];
        NSURL *htmlUrl = [NSURL URLWithString:@"http://localhost:63342/EchartLearn/map-polygon.html"];
        NSURLRequest *res = [[NSURLRequest alloc] initWithURL:htmlUrl];
        [self.mapView loadRequest:res];
//        [self.mapView setOpaque:NO];
        [self addSubview:self.mapView];
        [self addSubview:self.mapView];
    }
    return self;
}
- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}
@end
