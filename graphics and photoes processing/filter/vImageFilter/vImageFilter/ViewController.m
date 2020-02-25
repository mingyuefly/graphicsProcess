//
//  ViewController.m
//  vImageFilter
//
//  Created by Gguomingyue on 2018/3/20.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"
#import "UIViewAdditions.h"
#import "UIImage+Filter.h"

@interface ViewController ()

@property (nonatomic, strong) UISlider *slider0;
@property (nonatomic, strong) UISlider *slider1;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.image = [UIImage imageNamed:@"wuyanzu.jpg"];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.image;
    self.imageView.width = self.view.width;
    self.imageView.height = 3 * self.imageView.width / 2;
    self.imageView.centerX = self.view.centerX;
    self.imageView.top = 0;
    [self.view addSubview:self.imageView];
    
    self.slider0 = [[UISlider alloc] init];
    self.slider0.width = self.view.width;
    self.slider0.height = 28;
    self.slider0.top = self.imageView.bottom + 10;
    self.slider0.centerX = self.view.centerX;
    self.slider0.minimumValue = 0;
    self.slider0.maximumValue = 1.0;
    self.slider0.value = 0;
    [self.slider0 addTarget:self action:@selector(slider0Action:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider0];
    
    self.slider1 = [[UISlider alloc] init];
    self.slider1.width = self.view.width;
    self.slider1.height = 28;
    self.slider1.top = self.slider0.bottom + 10;
    self.slider1.centerX = self.view.centerX;
    self.slider1.minimumValue = 0;
    self.slider1.maximumValue = 2.0;
    self.slider1.value = 1.0;
    [self.slider1 addTarget:self action:@selector(slider1Action:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider1];
}

-(void)slider0Action:(UISlider *)sender
{
    //UIImage *image = [self.image imageByBlur:sender.value];
    UIImage *image = [self.image imageByBlur:sender.value Saturation:self.slider1.value];
    self.imageView.image = image;
}

-(void)slider1Action:(UISlider *)sender
{
    //UIImage *image = [self.image imageBySaturation:sender.value];
    UIImage *image = [self.image imageByBlur:self.slider0.value Saturation:sender.value];
    self.imageView.image = image;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
