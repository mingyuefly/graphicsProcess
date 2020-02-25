//
//  ViewController.m
//  RotatoryDice
//
//  Created by Gguomingyue on 2018/3/16.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"
#import "DiceView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DiceView *diceView = [[DiceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:diceView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
