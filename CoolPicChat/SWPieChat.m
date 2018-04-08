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

@interface SWPieChat()
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
    CGFloat radius = (sideLength - 50)/2;
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

    // 添加指示Label
    UIBezierPath *pointerLayerPath = [[UIBezierPath alloc] init];
    
    CGFloat pointerCenterX = self.frame.size.width / 2;
    CGFloat bottomMargin = 30.0f;
   // CGFloat sideMargin = 30.0f;
    CGFloat pointerWidth = 150.f;
    CGFloat pointerHeight = 60.0f;
    CGFloat viewHeight = self.frame.size.height;
   // CGFloat viewWidth = self.frame.size.width;
    
    CGPoint p1 = CGPointMake(pointerCenterX - pointerWidth / 2, pieCenter.y + radius + 25);
    CGPoint p2 = CGPointMake(p1.x + 60, p1.y);
    CGPoint p3 = CGPointMake(pointerCenterX, p1.y - 50);
    CGPoint p4 = CGPointMake(p2.x + 30, p2.y);
    CGPoint p5 = CGPointMake(p4.x + 60, p4.y);
    CGPoint p6 = CGPointMake(p5.x, p5.y + pointerHeight);
    CGPoint p7 = CGPointMake(p5.x - pointerWidth, p6.y);
    
    [pointerLayerPath moveToPoint:p1];
    [pointerLayerPath addLineToPoint:p2];
    [pointerLayerPath addLineToPoint:p3];
    [pointerLayerPath addLineToPoint:p4];
    [pointerLayerPath addLineToPoint:p5];
    [pointerLayerPath addLineToPoint:p6];
    [pointerLayerPath addLineToPoint:p7];
    [pointerLayerPath closePath];
    CAShapeLayer *pointerShapLayer = [[CAShapeLayer alloc] init];
    pointerShapLayer.path = pointerLayerPath.CGPath;
    pointerShapLayer.fillColor = [UIColor whiteColor].CGColor;
    pointerShapLayer.opacity = 0.5;
    [self.layer addSublayer:pointerShapLayer];
    
 
    CAShapeLayer *poLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *poPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 4, 4)];
    poLayer.path = poPath.CGPath;
    poLayer.fillColor = [UIColor orangeColor].CGColor;
    [self.layer addSublayer:poLayer];
    
    CAShapeLayer *poLayer1 = [[CAShapeLayer alloc] init];
   
    poLayer1.path = poPath.CGPath;
    poLayer1.fillColor = [UIColor greenColor].CGColor;
    [self.bkLayer addSublayer:poLayer1];
    
   // UIPanGestureRecognizer *panCR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAct:)];
   // [self addGestureRecognizer:panCR];
//    NSString *drawText = @"测试内容";
//    UIFont *font = [UIFont systemFontOfSize:16.0f];
//   // font.
//    [drawText drawInRect:CGRectMake(p1.x, p1.y, pointerWidth - 10, pointerHeight - 10) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor blueColor]}];
    
//    // 添加mask layer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.path = insidePath.CGPath;
//    maskLayer.strokeEnd = 0;
//    maskLayer.strokeColor = [UIColor redColor].CGColor;
//    maskLayer.lineWidth =  2*radius;
//    maskLayer.fillColor = [UIColor clearColor].CGColor;
//   // bkLayer.mask = maskLayer;
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
//    // 动画2 逐步显示动画
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.duration = 1.5f;
//    animation.fromValue = @0;
//    animation.toValue = @1;
//    // 自动还原
//    animation.autoreverses = NO;
//    // 结束后是否移除
//    animation.removedOnCompletion = NO;
//    // 让动画保持在最后状态
//    animation.fillMode = kCAFillModeForwards;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//   // [maskLayer addAnimation:animation forKey:@"strokeEnd"];
//
//   // [bkLayer addAnimation:rotateAnimation forKey:@"aa"];
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

@end
