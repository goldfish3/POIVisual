//
//  PoiInfoView.m
//  PoiVisual
//
//  Created by 何钰堂 on 2018/12/5.
//  Copyright © 2018 com.512. All rights reserved.
//

#import "PoiInfoView.h"
@interface PoiInfoView()
@property(strong,nonatomic) UIButton *hideBtn;
@property(strong,nonatomic) UIView *contentView;
@end

@implementation PoiInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        //弹入弹出按钮
        self.hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [self.hideBtn setTitle:@"show" forState:UIControlStateNormal];
        self.hideBtn.layer.cornerRadius = 5;
        [self addSubview:self.hideBtn];
        
        //内容
        int margin = 10;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hideBtn.frame)+margin,
                                                                    0,
                                                    self.frame.size.width - self.hideBtn.frame.size.width-margin,
                                                                    self.frame.size.height)];
        [self addSubview:self.contentView];
    }
    return self;
}
@end
