//
//  ViewController.m
//  scaleView
//
//  Created by Gguomingyue on 2018/1/24.
//  Copyright © 2018年 Gguomingyue. All rights reserved.
//

#import "ViewController.h"
#import "MYSquareView.h"

@interface ViewController ()

@property (nonatomic, strong) MYSquareView *squareView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupView];
}

-(void)setupView
{
    [self.view addSubview:self.squareView];
}

-(MYSquareView *)squareView
{
    if (!_squareView) {
        _squareView = [[MYSquareView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * 30, [UIScreen mainScreen].bounds.size.width - 2 * 30)];
        _squareView.center = self.view.center;
    }
    return _squareView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
