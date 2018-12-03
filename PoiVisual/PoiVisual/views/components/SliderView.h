//
//  SliderView.h
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/18.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Value)(float);

@interface SliderView : UIView
@property(copy,nonatomic) NSString *title;
@property(strong,nonatomic) UILabel *titleLabel;
@property(strong,nonatomic) UISlider *slider;
@property(copy,nonatomic) Value valueBlock;
- (instancetype)initWithFrame:(CGRect)frame andValueChange:(Value)block;
@end
