//
//  DeviceSingle.m
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/15.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import "DeviceSingle.h"

@implementation DeviceSingle

static DeviceSingle *instance;

+(DeviceSingle *)sharedInstance{
    return [[self alloc] init];
}
-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
    });
    return instance;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    if (instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [super allocWithZone:zone];
        });
    }
    return instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return instance;
}
@end
