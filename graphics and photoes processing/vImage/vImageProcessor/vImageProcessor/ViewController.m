//
//  ViewController.m
//  vImageProcessor
//
//  Created by Gguomingyue on 2018/3/13.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"
#import "VImangeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)orginalAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"orginal";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)alphaBlendColorAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"alphaBlendColor";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)alphaBlendImageAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"alphaBlendImage";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)scaleAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"scale";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)cropAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"crop";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)shearAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"shear";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)flipAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"flip";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)rotateAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"rotate";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)affineTransformAction:(UIButton *)sender {
    VImangeViewController *vc = [[VImangeViewController alloc] init];
    vc.titleString = @"affineTransform";
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
