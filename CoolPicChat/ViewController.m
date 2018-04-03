//
//  ViewController.m
//  CoolPicChat
//
//  Created by Eren on 26/03/2018.
//  Copyright © 2018 nxrmc. All rights reserved.
//

#import "ViewController.h"
#import "SWPieChat.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWPieChat *pieChat = [[SWPieChat alloc] initWithFrame:CGRectMake(50, 20, 200, 200)];
    
    [pieChat updateProportions:@[@0.6, @0.4] placeHolderColor:@[[UIColor redColor], [UIColor blueColor]] placeHolderTitles:nil];
   // pieChat.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pieChat];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
