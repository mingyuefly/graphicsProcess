//
//  VImangeViewController.m
//  vImageProcessor
//
//  Created by Gguomingyue on 2018/3/13.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "VImangeViewController.h"
#import "UIImage+vImageProcess.h"
#import "VImangeViewController.h"
#import "UIViewAdditions.h"


@interface VImageView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation VImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.bottom = self.height;
    self.titleLabel.centerX = self.centerX;
    self.imageView.top = 0;
    self.imageView.left = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.height - self.titleLabel.height;
}

@end

@interface VImangeViewController ()

@property (nonatomic, strong) VImageView *vImageView;


@end

@implementation VImangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *testImage = [UIImage imageNamed:@"testImageLarge"];
    UIImage *blendImage = [UIImage imageNamed:@"TestImage"];
    
    self.vImageView = [[VImageView alloc] init];
    self.vImageView.titleLabel.text = self.titleString;
    if ([self.titleString isEqualToString:@"orginal"]) {
        self.vImageView.imageView.image = testImage;
    } else if ([self.titleString isEqualToString:@"alphaBlendColor"]) {
        self.vImageView.imageView.image = [testImage vImage_alphaBlendedImageWithColor:[UIColor colorWithWhite:1 alpha:0.5]];
    } else if ([self.titleString isEqualToString:@"alphaBlendImage"]) {
        self.vImageView.imageView.image = [testImage vImage_alphaBlendedImageWithImage:blendImage point:CGPointMake(500, 500)];
    } else if ([self.titleString isEqualToString:@"scale"]) {
        self.vImageView.imageView.image = [testImage vImage_scaledImageWithSize:CGSizeMake(300, 400)];
    } else if ([self.titleString isEqualToString:@"crop"]) {
        self.vImageView.imageView.image = [testImage vImage_croppedImageWithRect:CGRectMake(1000, 1000, 2000, 2000)];
    } else if ([self.titleString isEqualToString:@"flip"]) {
        self.vImageView.imageView.image = [testImage vImage_flippedImageWithHorizontal:YES];
    } else if ([self.titleString isEqualToString:@"rotate"]) {
        self.vImageView.imageView.image = [testImage vImage_rotatedImageWithRadians:M_PI_2];
    } else if ([self.titleString isEqualToString:@"shear"]) {
        self.vImageView.imageView.image = [testImage vImage_shearedImageWithHorizontal:YES offset:CGVectorMake(0, 0) translation:0 slope:M_PI_4 scale:0.5];
    } else if ([self.titleString isEqualToString:@"affineTransform"]) {
        self.vImageView.imageView.image = [testImage vImage_affineTransformedImageWithTransform:CGAffineTransformMake(1, 0, 0, 0.5, 0, 500)];
    }
    
    self.vImageView.width = self.view.width;
    self.vImageView.height = self.view.width;
    self.vImageView.centerX = self.view.width/2;
    self.vImageView.centerY = self.view.height/2;
    [self.view addSubview:self.vImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.width = 100;
    button.height = 30;
    button.bottom = self.view.height - 10;
    button.centerX = self.view.centerX;
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
