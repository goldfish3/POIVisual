//
//  SetModel.h
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/19.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetModel : UIView
//热门程度
@property(assign,nonatomic) float hotValue;
//新颖度
@property(assign,nonatomic) float novelValue;
//距离
@property(assign,nonatomic) float distanceValue;
//时段性
@property(assign,nonatomic) float timeValue;
@end
