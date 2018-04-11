//
//  SWPieChat.h
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SWPieChatRationLayer : NSObject
@property(nonatomic, strong) CAShapeLayer *shapeLayer;
@property(nonatomic, assign) CGFloat centerAngel;
@property(nonatomic, strong) NSString *indentity;
@property(nonatomic, strong) NSNumber *ratio;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIColor *color;
@end

@interface SWPieChatSegment : NSObject
@property(nonatomic, strong) UIColor *segmentColor;
@property(nonatomic, strong) NSString *segmentTitle;
@property(nonatomic, assign) CGFloat segmentRatio;
@end

@interface SWPieChat : UIView
- (void)updateProportions:(NSArray *)proportions placeHolderColor:(NSArray *)placeHolderColors placeHolderTitles:(NSArray *)placeHolderTitles;
@end

@protocol SWPieChatDelegate<NSObject>
- (void)pieChatDidShow:(SWPieChat *)pieChat;
- (void)pieChat:(SWPieChat *)pieChat didSelectSegment:(SWPieChatSegment *)pieChatSegment;
@end
