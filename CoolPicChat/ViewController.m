//
//  ViewController.m
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "ViewController.h"
#import "SWPieChat.h"
#import "SWSpeechBubble.h"
@interface ViewController ()<SWPieChatDelegate>
@property(nonatomic, strong) SWSpeechBubble *speechBubble;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWPieChat *pieChat = [[SWPieChat alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    SWPieChatSegment *seg1 = [[SWPieChatSegment alloc] initWithValue:548.3 title:@"瓷砖" color:[UIColor orangeColor]];
    SWPieChatSegment *seg2 = [[SWPieChatSegment alloc] initWithValue:748.3 title:@"瓷砖" color:[UIColor blueColor]];
    SWPieChatSegment *seg3 = [[SWPieChatSegment alloc] initWithValue:243.61 title:@"电器" color:[UIColor redColor]];
    NSArray *segmentsArray = @[seg1, seg2, seg3];
    [pieChat updateProportions:segmentsArray];
    pieChat.backgroundColor = [UIColor whiteColor];
    pieChat.delegate = self;
    [self.view addSubview:pieChat];
    
    SWSpeechBubble *speechBubble = [[SWSpeechBubble alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height + 100, self.view.frame.size.width - 60, 60)];
    speechBubble.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:speechBubble];
    self.speechBubble = speechBubble;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SWPieChatDelegate
- (void)pieChatDidShow:(SWPieChat *)pieChat defaultSegment:(SWPieChatSegment *)pieChatSegment {
    [UIView animateWithDuration:0.5f animations:^{
        self.speechBubble.frame = CGRectMake(30, self.view.frame.size.width + 20, self.view.frame.size.width - 60, 60);
    } completion:^(BOOL finished) {
        NSString *title = [NSString stringWithFormat:@"%@ %.2f%%", pieChatSegment.segmentTitle, pieChatSegment.segmentRatio * 100];
        self.speechBubble.speechTitleLab.textColor = pieChatSegment.segmentColor;
        self.speechBubble.speechTitleLab.text = title;
        
        NSString *value = [NSString stringWithFormat:@"¥ %.2f", pieChatSegment.segmentValue];
        self.speechBubble.speechContentLab.textColor = pieChatSegment.segmentColor;
        self.speechBubble.speechContentLab.text = value;
    }];
}

- (void)pieChat:(SWPieChat *)pieChat didSelectSegment:(SWPieChatSegment *)pieChatSegment {
    NSString *title = [NSString stringWithFormat:@"%@ %.2f%%", pieChatSegment.segmentTitle, pieChatSegment.segmentRatio * 100];
    self.speechBubble.speechTitleLab.textColor = pieChatSegment.segmentColor;
    self.speechBubble.speechTitleLab.text = title;
    
    NSString *value = [NSString stringWithFormat:@"¥ %.2f", pieChatSegment.segmentValue];
    self.speechBubble.speechContentLab.textColor = pieChatSegment.segmentColor;
    self.speechBubble.speechContentLab.text = value;
}
@end
