//
//  SWSpeechBubble.m
//  CoolPicChat
//
//  Created by Eren on 09/04/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWSpeechBubble.h"

#define ICON_WIDTH 30
#define ARROW_WIDTH 60.0f
#define ARROW_HEIGHT 60.0f
#define MARGIN 15.0f

@implementation SWSpeechBubble
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 添加箭头
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(CGRectGetWidth(self.frame) - 2*MARGIN, MARGIN)];
    [arrowPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - MARGIN, CGRectGetHeight(self.frame)/2)];
    [arrowPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - 2*MARGIN, CGRectGetHeight(self.frame) - MARGIN)];
    [[UIColor lightGrayColor] setStroke];
    [arrowPath stroke];
}

- (void)commonInit {
    self.speechContentLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
    self.speechContentLab.numberOfLines = 0;
    self.speechContentLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.speechContentLab];
    CGFloat arrowWidth = 60.0f;
    CGFloat arrowHeight = 60.0f;
    UIView *arrow = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)/2 - arrowWidth/2, -arrowHeight, arrowWidth, arrowHeight)];
    arrow.backgroundColor = [UIColor orangeColor];
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointMake(0, arrowHeight)];
    [arrowPath addLineToPoint:CGPointMake(arrowWidth/2, 0)];
    [arrowPath addLineToPoint:CGPointMake(arrowWidth, arrowHeight)];
    [arrowPath closePath];
    CAShapeLayer *arrowMaskLayer = [[CAShapeLayer alloc] init];
    arrowMaskLayer.path = arrowPath.CGPath;
    arrow.layer.mask = arrowMaskLayer;
    arrow.alpha = 0.6;
    [self addSubview:arrow];
}
@end
