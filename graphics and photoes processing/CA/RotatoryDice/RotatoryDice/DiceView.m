//
//  DiceView.m
//  RotatoryDice
//
//  Created by Gguomingyue on 2018/3/16.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "DiceView.h"

@interface DiceView ()

@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, assign) CGPoint angle;
@property (nonatomic, assign) CGFloat change;

@end

@implementation DiceView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
        self.angle = CGPointZero;
        self.change = 0.0;
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    CATransform3D transform = CATransform3DIdentity;
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.center = self.center;
    imageView1.bounds = CGRectMake(0, 0, 100, 100);
    imageView1.layer.transform = CATransform3DTranslate(transform, 0, 0, 50);
    imageView1.image = [UIImage imageNamed:@"one"];
    [self addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.center = self.center;
    imageView2.bounds = CGRectMake(0, 0, 100, 100);
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    imageView2.layer.transform = transform;
    imageView2.image = [UIImage imageNamed:@"two"];
    [self addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.center = self.center;
    imageView3.bounds = CGRectMake(0, 0, 100, 100);
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, -50, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    imageView3.layer.transform = transform;
    imageView3.image = [UIImage imageNamed:@"three"];
    [self addSubview:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc] init];
    imageView4.center = self.center;
    imageView4.bounds = CGRectMake(0, 0, 100, 100);
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    imageView4.layer.transform = transform;
    imageView4.image = [UIImage imageNamed:@"four"];
    [self addSubview:imageView4];
    
    UIImageView *imageView5 = [[UIImageView alloc] init];
    imageView5.center = self.center;
    imageView5.bounds = CGRectMake(0, 0, 100, 100);
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, -50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    imageView5.layer.transform = transform;
    imageView5.image = [UIImage imageNamed:@"five"];
    [self addSubview:imageView5];
    
    UIImageView *imageView6 = [[UIImageView alloc] init];
    imageView6.center = self.center;
    imageView6.bounds = CGRectMake(0, 0, 100, 100);
    transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    imageView6.layer.transform = transform;
    imageView6.image = [UIImage imageNamed:@"six"];
    [self addSubview:imageView6];
    
    [self addAnimation];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewTransform:)];
    [self addGestureRecognizer:pan];
}

-(void)viewTransform:(UIPanGestureRecognizer *)sender
{
    UIView *panView = sender.view;
    CGPoint point = [sender translationInView:panView];
    
    CGFloat angleX = point.x/30 + self.angle.x;
    CGFloat angleY = self.angle.y - point.y / 30;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/500;
    transform = CATransform3DRotate(transform, angleX, 0, 1, 0);
    transform = CATransform3DRotate(transform, angleY, 1, 0, 0);
    panView.layer.sublayerTransform = transform;
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.displaylink.paused = YES;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.angle = CGPointMake(point.x/100, point.y/100);
        self.displaylink.paused = NO;
    }
}

-(void)addAnimation
{
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationAction)];
    //self.displaylink.preferredFramesPerSecond = 60;
    self.displaylink.paused = NO;
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)animationAction
{
    self.change += 0.01;
    CATransform3D transform = CATransform3DRotate(CATransform3DIdentity, self.change, 0, 1, 0);
    transform = CATransform3DRotate(transform, self.change, 1, 0, 0);
    self.layer.sublayerTransform = transform;
}

@end
