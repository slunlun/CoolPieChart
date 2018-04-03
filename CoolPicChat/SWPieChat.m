//
//  SWPieChat.m
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWPieChat.h"
@interface SWPieChat()
@property(nonatomic, strong) NSArray *proportions;
@property(nonatomic, strong) NSArray *placeHolderColors;
@property(nonatomic, strong) NSArray *placeHolderTitles;
@end


@implementation SWPieChat
- (void)drawRect:(CGRect)rect {
    // 绘制边框
    CGFloat sideLength = MIN(self.bounds.size.width, self.bounds.size.height);
    CGRect outRect = CGRectMake(5, 5, sideLength - 5, sideLength - 5);
    CGRect insideRect = CGRectMake(10, 10, sideLength - 15, sideLength - 15);
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.usesEvenOddFillRule = YES;
    UIBezierPath *outPath = [UIBezierPath bezierPathWithOvalInRect:outRect];
    [path appendPath:outPath];
    UIBezierPath *insidePath = [UIBezierPath bezierPathWithOvalInRect:insideRect];
    [path appendPath:insidePath];
    [[UIColor lightGrayColor] set];
    [path fill];
    
    // 根据proportions填充饼图
    CGFloat startAngle = -M_PI_2;
    CGFloat totalAngel = 2 * M_PI;
    CGFloat radius = (sideLength - 15)/2;
    CGPoint pieCenter = CGPointMake(CGRectGetMidX(outRect), CGRectGetMidY(outRect));
    
    UIBezierPath *backgroundLayerPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:startAngle endAngle:totalAngel clockwise:YES];
    [backgroundLayerPath closePath];
    CAShapeLayer *bkLayer = [[CAShapeLayer alloc] init];
    bkLayer.path = backgroundLayerPath.CGPath;
    bkLayer.fillColor = [UIColor greenColor].CGColor;
    bkLayer.position = pieCenter;
    [self.layer addSublayer:bkLayer];
    
   
    NSInteger index = 0;
    
//    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)];
//    CAShapeLayer *newLayer = [[CAShapeLayer alloc] init];
//    newLayer.fillColor = [UIColor redColor].CGColor;
//    newLayer.path = path1.CGPath;
//    [bkLayer addSublayer:newLayer];
//
//    return;
    for (NSNumber *ratio in self.proportions) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addArcWithCenter:CGPointZero radius:radius startAngle:startAngle endAngle:startAngle + ratio.floatValue * totalAngel clockwise:YES];
        startAngle = startAngle + ratio.floatValue * totalAngel;
        CAShapeLayer *newLayer = [[CAShapeLayer alloc] init];
        newLayer.fillColor = ((UIColor *)(self.placeHolderColors[index])).CGColor;
        newLayer.path = path.CGPath;
        ++index;
        [bkLayer addSublayer:newLayer];
    }
    
    // 添加mask layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = insidePath.CGPath;
    maskLayer.strokeEnd = 0;
    maskLayer.strokeColor = [UIColor redColor].CGColor;
    maskLayer.lineWidth =  2*radius;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
   // bkLayer.mask = maskLayer;
    
    // 添加动画
    // 动画1 旋转动画
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.duration = 3.0f;
    rotateAnimation.fromValue = @0;
    rotateAnimation.toValue = @(M_PI);
    rotateAnimation.autoreverses = NO;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.cumulative = YES;
    rotateAnimation.repeatCount = MAXFLOAT;
    
    // 动画2 逐步显示动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.5f;
    animation.fromValue = @0;
    animation.toValue = @1;
    // 自动还原
    animation.autoreverses = NO;
    // 结束后是否移除
    animation.removedOnCompletion = NO;
    // 让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
   // [maskLayer addAnimation:animation forKey:@"strokeEnd"];
    
    [bkLayer addAnimation:rotateAnimation forKey:@"aa"];
}
- (void)updateProportions:(NSArray *)proportions placeHolderColor:(NSArray *)placeHolderColors placeHolderTitles:(NSArray *)placeHolderTitles {
    self.proportions = proportions;
    self.placeHolderColors = placeHolderColors;
    self.placeHolderTitles = placeHolderTitles;
    [self setNeedsLayout];
}
@end
