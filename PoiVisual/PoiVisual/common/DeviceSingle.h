//
//  DeviceSingle.h
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/15.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceSingle : NSObject
@property(assign,nonatomic) int width;
@property(assign,nonatomic) int height;
+(DeviceSingle *)sharedInstance;
@end
