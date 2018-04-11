//
//  SWPieChat.m
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "SWPieChat.h"
@implementation SWPieChatRationLayer
@end

@interface SWPieChat()<CAAnimationDelegate>
@property(nonatomic, strong) NSArray *proportions;
@property(nonatomic, strong) NSArray *placeHolderColors;
@property(nonatomic, strong) NSArray *placeHolderTitles;
@property(nonatomic, strong) CALayer *bkLayer;
@property(nonatomic, strong) CAShapeLayer *firstLayer;
@property(nonatomic, assign) CGPoint pieCenter;
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign) CGFloat midAngle;
@property(nonatomic, strong) NSMutableArray<SWPieChatRationLayer *> *pieRatioLayerArray;
@end


@implementation SWPieChat
- (NSMutableArray *)pieRatioLayerArray {
    if (_pieRatioLayerArray == nil) {
        _pieRatioLayerArray = [[NSMutableArray alloc] init];
    }
    return _pieRatioLayerArray;
}

- (void)drawRect:(CGRect)rect {
    // 绘制圆环背景
    CGFloat sideLength = MIN(self.bounds.size.width, self.bounds.size.height);
    CGRect outRect = CGRectMake(5, 5, sideLength - 5, sideLength - 5);
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath *outPath = [UIBezierPath bezierPathWithOvalInRect:outRect];
    [path appendPath:outPath];
    [[UIColor lightGrayColor] set];
    [path fill];
    
    
    // 根据proportions填充饼图
    CGFloat startAngle = -M_PI_2;
    CGFloat totalAngel = 2 * M_PI;
    CGFloat radius = (sideLength - 15)/2;
    _radius = radius;
    CGPoint pieCenter = CGPointMake(CGRectGetMidX(outRect), CGRectGetMidY(outRect));
    self.pieCenter = pieCenter;
    UIBezierPath *backgroundLayerPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:radius startAngle:startAngle endAngle:totalAngel clockwise:YES];
    [backgroundLayerPath closePath];
    CAShapeLayer *bkLayer = [[CAShapeLayer alloc] init];
    bkLayer.path = backgroundLayerPath.CGPath;
    bkLayer.fillColor = [UIColor greenColor].CGColor;
    bkLayer.position = pieCenter;
    [self.layer addSublayer:bkLayer];
    self.bkLayer = bkLayer;
    
   
    NSInteger index = 0;
    for (NSNumber *ratio in self.proportions) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addArcWithCenter:CGPointZero radius:radius startAngle:startAngle endAngle:startAngle + ratio.floatValue * totalAngel clockwise:YES];
        [path closePath];
        CAShapeLayer *newLayer = [[CAShapeLayer alloc] init];
        newLayer.fillColor = ((UIColor *)(self.placeHolderColors[index])).CGColor;
        newLayer.path = path.CGPath;
        [bkLayer addSublayer:newLayer];
        
        SWPieChatRationLayer *ratioLayer = [[SWPieChatRationLayer alloc] init];
        ratioLayer.shapeLayer = newLayer;
        ratioLayer.ratio = ratio;
        ratioLayer.color = self.placeHolderColors[index];
        ratioLayer.centerAngel = startAngle + (ratio.floatValue * totalAngel)/2;
        ratioLayer.indentity = [NSString stringWithFormat:@"%ld", index];
        [self.pieRatioLayerArray addObject:ratioLayer];
        
        startAngle += ratio.floatValue * totalAngel;
        ++index;
    }

    // 添加总额的圆圈
    CALayer *countBackgourLayer = [CALayer layer];
    countBackgourLayer.bounds = CGRectMake(0, 0, 120, 120);
    countBackgourLayer.cornerRadius = 60;
    countBackgourLayer.masksToBounds = YES;
    countBackgourLayer.position = pieCenter;
    countBackgourLayer.backgroundColor = [UIColor blackColor].CGColor;
    countBackgourLayer.opacity = 0.2f;
    
    
    CATextLayer *countTextLayer = [CATextLayer layer];
    countTextLayer.bounds = CGRectMake(0, 0, 50, 36);
    countTextLayer.position = pieCenter;
    countTextLayer.contentsScale = [UIScreen mainScreen].scale;
    countTextLayer.string = @"总计\n123.23";
    countTextLayer.fontSize = 15;
    countTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    countTextLayer.alignmentMode = kCAAlignmentCenter;
    [self.layer addSublayer:countBackgourLayer];
    [self.layer addSublayer:countTextLayer];
   
    
    // 添加边缘半透明的圆环
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithArcCenter:pieCenter radius:radius - 4 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    CAShapeLayer *ringLayer = [CAShapeLayer layer];
    ringLayer.path = ringPath.CGPath;
    ringLayer.strokeColor = [UIColor whiteColor].CGColor;
    ringLayer.fillColor = [UIColor clearColor].CGColor;
    ringLayer.lineWidth = 8;
    ringLayer.opacity = 0.2f;
    [self.layer addSublayer:ringLayer];
    
//
//    // 添加动画
//    // 动画1 旋转动画
//    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotateAnimation.duration = 3.0f;
//    rotateAnimation.fromValue = @0;
//    rotateAnimation.toValue = @(M_PI);
//    rotateAnimation.autoreverses = NO;
//    rotateAnimation.removedOnCompletion = NO;
//    rotateAnimation.cumulative = YES;
//    rotateAnimation.repeatCount = MAXFLOAT;
//
//
    // [bkLayer addAnimation:rotateAnimation forKey:@"aa"];
    
    // 动画2 逐步显示动画
    // 添加mask layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = backgroundLayerPath.CGPath;
    maskLayer.strokeEnd = 0;
    maskLayer.strokeColor = [UIColor redColor].CGColor;
    maskLayer.lineWidth =  2*radius;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    bkLayer.mask = maskLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.5f;
    animation.fromValue = @0;
    animation.toValue = @1;
    // 自动还原
    animation.autoreverses = NO;
    // 结束后是否移除
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    // 让动画保持在最后状态
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setValue:@"strokeEnd" forKey:@"AnimationKey"];
    [maskLayer addAnimation:animation forKey:@"strokeEnd"];
    
}
- (void)updateProportions:(NSArray *)proportions placeHolderColor:(NSArray *)placeHolderColors placeHolderTitles:(NSArray *)placeHolderTitles {
    self.proportions = proportions;
    self.placeHolderColors = placeHolderColors;
    self.placeHolderTitles = placeHolderTitles;
    [self setNeedsLayout];
}

#pragma mark - Gesture Recognizer
//- (void)rotationAct:(UIRotationGestureRecognizer *)gesture {
//    self.bkLayer.affineTransform = CGAffineTransformMakeRotation(gesture.rotation);
//}
//- (void)panAct:(UIPanGestureRecognizer *)panGR {
//    CGPoint trans = [panGR translationInView:self];
//    CGFloat transUnit = M_PI / 50;
//    self.bkLayer.affineTransform = CGAffineTransformMakeRotation(-(transUnit * trans.x));
//}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
   
       UITouch *touch = [touches anyObject];
    
        NSUInteger toucheNum = [[event allTouches] count];//有几个手指触摸屏幕
        if ( toucheNum > 1 ) {
            return;//多个手指不执行旋转
        }
        
        //_view，你想旋转的视图
        if (![touch.view isEqual:self]) {
            return;
        }
        
        /**
         CGRectGetHeight 返回控件本身的高度
         CGRectGetMinY 返回控件顶部的坐标
         CGRectGetMaxY 返回控件底部的坐标
         CGRectGetMinX 返回控件左边的坐标
         CGRectGetMaxX 返回控件右边的坐标
         CGRectGetMidX 表示得到一个frame中心点的X坐标
         CGRectGetMidY 表示得到一个frame中心点的Y坐标
         */
        
        CGPoint center = self.pieCenter;
        CGPoint currentPoint = [touch locationInView:touch.view];//当前手指的坐标
        CGPoint previousPoint = [touch previousLocationInView:touch.view];//上一个坐标
        
        /**
         求得每次手指移动变化的角度
         atan2f 是求反正切函数 参考:http://blog.csdn.net/chinabinlang/article/details/6802686
         */
        CGFloat angle = atan2f(currentPoint.y - center.y, currentPoint.x - center.x) - atan2f(previousPoint.y - center.y, previousPoint.x - center.x);
   
        self.bkLayer.affineTransform = CGAffineTransformRotate(self.bkLayer.affineTransform, angle);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {

    CGAffineTransform layerTransform = CGAffineTransformInvert(self.bkLayer.affineTransform);
    // 根据当前的变换矩阵，反向变换 testPoint，使得testPoint仍然在初始坐标系下的(0, 20)点
    CGPoint testPoint = CGPointApplyAffineTransform(CGPointMake(0, 20), layerTransform);
    for (SWPieChatRationLayer *layer in  self.pieRatioLayerArray) {
        if (CGPathContainsPoint(layer.shapeLayer.path, nil, testPoint, false)) {
            CGFloat slideAngel = M_PI_2 - layer.centerAngel;
            self.bkLayer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, slideAngel);
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if(flag) {
        if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"strokeEnd"]) {
            // 移除动画
            self.bkLayer.mask = nil;
            [self.bkLayer removeAnimationForKey:@"strokeEnd"];
        }
    }
}

@end
