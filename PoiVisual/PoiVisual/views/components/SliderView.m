//
//  SliderView.m
//  PoiVisual
//
//  Created by 何钰堂 on 2018/11/18.
//  Copyright © 2018年 com.512. All rights reserved.
//

#import "SliderView.h"
#define MARGIN 10

@implementation SliderView

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame andValueChange:(Value)block{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, self.frame.size.width/5, self.frame.size.height - MARGIN * 2)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.titleLabel];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+MARGIN,
                                                                 MARGIN,
                                                                 self.frame.size.width - CGRectGetMaxX(self.titleLabel.frame)-MARGIN*2,
                                                                 self.frame.size.height - MARGIN*2)];
        [self.slider addTarget:self action:@selector(valueChange:)
              forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
        self.valueBlock = block;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, self.frame.size.width/5, self.frame.size.height - MARGIN * 2)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:self.titleLabel];
        
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+MARGIN,
                                                                 MARGIN,
                                                                 self.frame.size.width - CGRectGetMaxX(self.titleLabel.frame)-MARGIN*2,
                                                                 self.frame.size.height - MARGIN*2)];
        [self.slider addTarget:self action:@selector(valueChange:)
              forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
    }
    return self;
}
- (void)valueChange:(UISlider *)sender{
    self.valueBlock(sender.value);
}
@end
