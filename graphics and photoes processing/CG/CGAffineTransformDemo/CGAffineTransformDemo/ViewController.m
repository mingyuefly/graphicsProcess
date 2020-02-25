//
//  ViewController.m
//  CGAffineTransformDemo
//
//  Created by Gguomingyue on 2018/3/19.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger next;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI
{
    self.next = 0;
    self.titles = @[@"translation", @"scale", @"rotation", @"affine"];
    self.button = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 100, 30);
        button.center = CGPointMake(self.view.center.x, self.view.frame.origin.y + 80);
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"translation" forState:UIControlStateNormal];
        button;
    });
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image"]];
        imageView.frame = CGRectMake(0, 0, 100, 80);
        imageView.center = CGPointMake(self.view.center.x, self.view.frame.origin.y + 160);
        imageView;
    });
    [self.view addSubview:self.button];
    [self.view addSubview:self.imageView];
}

-(void)buttonAction:(UIButton *)sender
{
    __block CGAffineTransform transform;
    NSInteger state = self.next%4;
    switch (state) {
        case 0:
        {
            transform = CGAffineTransformMakeTranslation(-100, 150);
        }
            break;
        case 1:
        {
            transform = CGAffineTransformMakeScale(2, 2);
        }
            break;
        case 2:
        {
            transform = CGAffineTransformMakeRotation(180 * M_PI/360);
        }
            break;
        case 3:
        {
            transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, -100, 150);
            transform = CGAffineTransformScale(transform, 2, 2);
            transform = CGAffineTransformRotate(transform, 180 * M_PI/360);
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        self.imageView.transform = transform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.button.enabled = YES;
            [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }];
    }];
    
    self.next++;
    [self.button setTitle:self.titles[self.next%4] forState:UIControlStateNormal];
    [self.button setTitleColor:self.view.backgroundColor forState:UIControlStateNormal];
    self.button.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
