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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWPieChat *pieChat = [[SWPieChat alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, self.view.frame.size.height - 40)];
    
    [pieChat updateProportions:@[@0.2, @0.1, @0.7] placeHolderColor:@[[UIColor blueColor], [UIColor yellowColor], [UIColor redColor]] placeHolderTitles:nil];
    pieChat.backgroundColor = [UIColor blackColor];
    [self.view addSubview:pieChat];
    
    SWSpeechBubble *speechBubble = [[SWSpeechBubble alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, 60)];
    speechBubble.speechContentLab.textColor = [UIColor orangeColor];
    speechBubble.speechContentLab.text = @"30.2%\n定制家具";
    speechBubble.backgroundColor = [UIColor whiteColor];
  //  [self.view addSubview:speechBubble];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
