//
//  ViewController.m
//  CATransform3DDemo
//
//  Created by Gguomingyue on 2018/3/16.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "GridView.h"
#import "UIViewAdditions.h"

static char const * const maxValueTagKey = "maxValueTagKey";

@interface UIButton(MAX)
@property (nonatomic, assign) float maxValue;
@end

@implementation UIButton(MAX)
@dynamic maxValue;

- (float)maxValue
{
    return [objc_getAssociatedObject(self, maxValueTagKey) floatValue];
}

- (void)setMaxValue:(float)maxValue
{
    objc_setAssociatedObject(self, maxValueTagKey, @(maxValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface ViewController ()

@property (nonatomic, weak) GridView *gridView;
@property (nonatomic, weak) UISlider *xAnchorSlider;
@property (nonatomic, weak) UISlider *yAnchorSlider;
@property (nonatomic, weak) UIView *matrixBoxView;
@property (nonatomic, assign) NSInteger selectedRow, selectedColumn;
@property (nonatomic, weak) UISlider *sliderView, *xRotationSliderView, *yRotationSliderView, *zRotationSliderView;
@property (nonatomic, weak) UILabel *xRotationLabel, *yRotationLabel, *zRotationLabel;
@property (nonatomic, assign) float initialXRotation, initialYRotation, initialZRotation;
@property (nonatomic, assign) float initialM14Value, initialM24Value;
@property (nonatomic, assign) float initialXScale, initialYScale;

@end

@implementation ViewController

#define MAX_VALUE 1.0
#define TAG_BUTTON 1000

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

-(void)setupView
{
    GridView *gridView = [[GridView alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-160)/2, 30, 161, 161)];
    [self.view addSubview:gridView];
    self.gridView = gridView;
    
    UISlider *xAnchorSlider = [[UISlider alloc] initWithFrame:CGRectMake(gridView.left, gridView.bottom + 10, gridView.width, 30)];
    [self.view addSubview:xAnchorSlider];
    [xAnchorSlider setMinimumValue:0.0];
    [xAnchorSlider setMaximumValue:1.0];
    [xAnchorSlider setValue:0.5];
    [xAnchorSlider setTag:1];
    [xAnchorSlider addTarget:self action:@selector(onAnchorPointValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.xAnchorSlider = xAnchorSlider;
    
    UISlider *yAnchorSlider = [[UISlider alloc] initWithFrame:CGRectMake(gridView.left - 45 - gridView.width/2, gridView.top + gridView.height/2 - 15, gridView.width, 30)];
    [self.view addSubview:yAnchorSlider];
    [yAnchorSlider setMinimumValue:0.0];
    [yAnchorSlider setMaximumValue:1.0];
    [yAnchorSlider setValue:0.5];
    [yAnchorSlider setTag:1];
    [yAnchorSlider addTarget:self action:@selector(onAnchorPointValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.yAnchorSlider = yAnchorSlider;
    yAnchorSlider.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    UIView *matrixBoxView = [[UIView alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-300)/2, xAnchorSlider.bottom + 10, 300, 180)];
    matrixBoxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:matrixBoxView];
    self.matrixBoxView = matrixBoxView;
    
    int btn_width = 70;
    int btn_height = 30;
    int x_gap = (matrixBoxView.frame.size.width-btn_width*4)/3;
    int y_gap = (matrixBoxView.frame.size.height-btn_height*4)/3;
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            int x = (btn_width+x_gap)*col;
            int y = (btn_height+y_gap)*row;
            CGRect btnFrame = CGRectMake(x, y, btn_width, btn_height);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setFrame:btnFrame];
            [button setTag:TAG_BUTTON + col + 4*row];
            
            [matrixBoxView addSubview:button];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            if ((row==0 && col==0) || (row==1 && col==1) || (row==2 && col==2) ||  (row==3 && col==3))
            {
                [button setTitle:@"1.0" forState:UIControlStateNormal];
                [button setMaxValue:10];
            }
            else if ((row==0 && col==1) || (row==1 && col==0))
            {
                [button setTitle:@"0.0" forState:UIControlStateNormal];
                [button setMaxValue:10];
            }
            else if ((row==2 && col==0) || (row==0 && col==2))
            {
                [button setTitle:@"0.0" forState:UIControlStateNormal];
                [button setMaxValue:10];
            }
            else if (row==3)
            {
                [button setTitle:@"0.0" forState:UIControlStateNormal];
                [button setMaxValue:10];
            }
            else
            {
                [button setTitle:@"0.0" forState:UIControlStateNormal];
                [button setMaxValue:0.01];
            }
        }
    }
    
    UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-300)/2, matrixBoxView.bottom + 10, 300, 30)];
    [self.view addSubview:sliderView];
    self.sliderView = sliderView;
    [self.sliderView setMinimumValue:-180];
    [self.sliderView setMaximumValue:180];
    [self.sliderView setValue:0.0];
    [self.sliderView addTarget:self action:@selector(onSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UISlider *xRotationSliderView = [[UISlider alloc] initWithFrame:CGRectMake(self.sliderView.left + 70, self.sliderView.bottom + 10, self.sliderView.width - 70, 30)];
    [self.view addSubview:xRotationSliderView];
    self.xRotationSliderView = xRotationSliderView;
    [self.xRotationSliderView setMinimumValue:-360];
    [self.xRotationSliderView setMaximumValue:360];
    [self.xRotationSliderView setValue:0.0];
    [self.xRotationSliderView setTag:1];
    [self.xRotationSliderView addTarget:self action:@selector(onRotationSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UISlider *yRotationSliderView = [[UISlider alloc] initWithFrame:CGRectMake(self.sliderView.left + 70, self.xRotationSliderView.bottom + 10, self.sliderView.width - 70, 30)];
    [self.view addSubview:yRotationSliderView];
    self.yRotationSliderView = yRotationSliderView;
    [self.yRotationSliderView setMinimumValue:-180];
    [self.yRotationSliderView setMaximumValue:180];
    [self.yRotationSliderView setValue:0.0];
    [self.yRotationSliderView setTag:2];
    [self.yRotationSliderView addTarget:self action:@selector(onRotationSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UISlider *zRotationSliderView = [[UISlider alloc] initWithFrame:CGRectMake(self.sliderView.left + 70, self.yRotationSliderView.bottom + 10, self.sliderView.width - 70, 30)];
    [self.view addSubview:zRotationSliderView];
    self.zRotationSliderView = zRotationSliderView;
    [self.zRotationSliderView setMinimumValue:-180];
    [self.zRotationSliderView setMaximumValue:180];
    [self.zRotationSliderView setValue:0.0];
    [self.zRotationSliderView setTag:3];
    [self.zRotationSliderView addTarget:self action:@selector(onRotationSlideValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *xRotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sliderView.left, self.sliderView.bottom + 10, 60, 30)];
    [self.view addSubview:xRotationLabel];
    self.xRotationLabel = xRotationLabel;
    [self.xRotationLabel setText:@"x: 0.0˚"];
    
    UILabel *yRotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sliderView.left, self.xRotationSliderView.bottom + 10, 60, 30)];
    [self.view addSubview:yRotationLabel];
    self.yRotationLabel = yRotationLabel;
    [self.yRotationLabel setText:@"y: 0.0˚"];
    
    UILabel *zRotationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sliderView.left, self.yRotationSliderView.bottom + 10, 60, 30)];
    [self.view addSubview:yRotationLabel];
    [self.view addSubview:zRotationLabel];
    self.zRotationLabel = zRotationLabel;
    [self.zRotationLabel setText:@"z: 0.0˚"];
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [resetButton setFrame:CGRectMake(([self.view bounds].size.width-200)/2, [self.view bounds].size.height-70, 200, 44)];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.view addSubview:resetButton];
    [resetButton addTarget:self action:@selector(onResetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onViewPanned:)];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [self.gridView addGestureRecognizer:panGestureRecognizer];
    
    UIRotationGestureRecognizer *rotateGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onViewRotated:)];
    [self.gridView addGestureRecognizer:rotateGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onViewPannedWithTwoFingers:)];
    [panGestureRecognizer2 setMinimumNumberOfTouches:2];
    [panGestureRecognizer2 setMaximumNumberOfTouches:2];
    [self.gridView addGestureRecognizer:panGestureRecognizer2];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinched:)];
    [self.gridView addGestureRecognizer:pinchGestureRecognizer];
}

-(void)applyTransformation
{
    float xAnchor = self.xAnchorSlider.value;
    float yAnchor = self.yAnchorSlider.value;
    CGPoint anchor = CGPointMake(xAnchor, yAnchor);
    [self.gridView.layer setAnchorPoint:anchor];
    
    CATransform3D transformation = CATransform3DIdentity;
    for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
            UIButton *button = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + col + 4*row];
            NSString *text = [[button titleLabel] text];
            float value = [text floatValue];
            
            if (row==0 && col==0) transformation.m11 = value;
            else if (row==0 && col==1) transformation.m12 = value;
            else if (row==0 && col==2) transformation.m13 = value;
            else if (row==0 && col==3) transformation.m14 = value;
            else if (row==1 && col==0) transformation.m21 = value;
            else if (row==1 && col==1) transformation.m22 = value;
            else if (row==1 && col==2) transformation.m23 = value;
            else if (row==1 && col==3) transformation.m24 = value;
            else if (row==2 && col==0) transformation.m31 = value;
            else if (row==2 && col==1) transformation.m32 = value;
            else if (row==2 && col==2) transformation.m33 = value;
            else if (row==2 && col==3) transformation.m34 = value;
            else if (row==3 && col==0) transformation.m41 = value;
            else if (row==3 && col==1) transformation.m42 = value;
            else if (row==3 && col==2) transformation.m43 = value;
            else if (row==3 && col==3) transformation.m44 = value;
        }
    }
    
    float x = [self.xRotationSliderView value];
    float y = [self.yRotationSliderView value];
    float z = [self.zRotationSliderView value];
    
    CATransform3D xRotation = CATransform3DMakeRotation(x*M_PI/180.0, 1.0, 0, 0);
    CATransform3D yRotation = CATransform3DMakeRotation(y*M_PI/180.0, 0, 1.0, 0);
    CATransform3D zRotation = CATransform3DMakeRotation(z*M_PI/180.0, 0, 0, 1.0);
    CATransform3D xYRotation = CATransform3DConcat(xRotation, yRotation);
    CATransform3D xyZRotation = CATransform3DConcat(xYRotation, zRotation);
    
    CATransform3D concatenatedTransformation = CATransform3DConcat(xyZRotation, transformation);
    
    self.gridView.layer.transform = concatenatedTransformation;
}

- (void)onAnchorPointValueChanged:(UISlider*)slider
{
    [self applyTransformation];
    [self.gridView setNeedsDisplay];
}

- (void)onButtonPressed:(UIButton*)button
{
    NSInteger index = [button tag] - TAG_BUTTON;
    self.selectedRow = floor(index/4) + 1;
    self.selectedColumn = index - (self.selectedRow -1)*4 + 1;
    
    [self deselectAllButtons];
    [button setSelected:YES];
    [self.sliderView setEnabled:YES];
    
    NSString *text = [[button titleLabel] text];
    float value = [text floatValue];
    [self.sliderView setValue:value];
    
    [self.sliderView setMinimumValue:-1*button.maxValue];
    [self.sliderView setMaximumValue:button.maxValue];
}

- (void)deselectAllButtons
{
    for (int row=0; row<4; row++)
    {
        for (int col=0; col<4; col++)
        {
            UIButton *button = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + col + 4*row];
            [button setSelected:NO];
        }
    }
}

- (void)onSlideValueChanged:(UISlider*)slider
{
    float value = [slider value];
    
    UIButton *button = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + self.selectedColumn-1 + 4*(self.selectedRow-1)];
    [button setTitle:[NSString stringWithFormat:@"%.4f", value] forState:UIControlStateNormal];
    
    [self applyTransformation];
}

- (void)onRotationSlideValueChanged:(UISlider*)slider
{
    NSInteger tag = [slider tag];
    [self applyTransformation];
    
    float value = [slider value];
    NSString *text = [NSString stringWithFormat:@"%.0f", value];
    if (tag==1)
    {
        [self.xRotationLabel setText:[NSString stringWithFormat:@"x: %@˚", text]];
    }
    else if (tag==2)
    {
        [self.yRotationLabel setText:[NSString stringWithFormat:@"y: %@˚", text]];
    }
    else if (tag==3)
    {
        [self.zRotationLabel setText:[NSString stringWithFormat:@"z: %@˚", text]];
    }
}

- (void)onViewPanned:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    UIGestureRecognizerState state = [gesture state];
    if (state==UIGestureRecognizerStateBegan)
    {
        self.initialXRotation = [self.xRotationSliderView value];
        self.initialYRotation = [self.yRotationSliderView value];
    }
    else if (state==UIGestureRecognizerStateChanged)
    {
        float xRotation = self.initialXRotation + translation.y;
        float yRotation = self.initialYRotation + translation.x;
        
        [self.xRotationSliderView setValue:xRotation];
        [self.yRotationSliderView setValue:yRotation];
        
        NSString *xText = [NSString stringWithFormat:@"x: %.0f˚", xRotation];
        NSString *yText = [NSString stringWithFormat:@"y: %.0f˚", yRotation];
        [self.xRotationLabel setText:xText];
        [self.yRotationLabel setText:yText];
        
        [self onRotationSlideValueChanged:nil];
    }
}

- (void)onViewRotated:(UIRotationGestureRecognizer*)gesture
{
    CGFloat rotation = [gesture rotation];
    UIGestureRecognizerState state = [gesture state];
    if (state==UIGestureRecognizerStateBegan)
    {
        self.initialZRotation = [self.zRotationSliderView value];
    }
    else if (state==UIGestureRecognizerStateChanged)
    {
        float zRotation = self.initialZRotation + rotation*180.0/M_PI;
        
        NSString *zText = [NSString stringWithFormat:@"z: %.0f˚", zRotation];
        [self.zRotationLabel setText:zText];
        
        [self.zRotationSliderView setValue:zRotation];
        [self onRotationSlideValueChanged:nil];
    }
}

- (void)onViewPannedWithTwoFingers:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:self.view];
    UIGestureRecognizerState state = [gesture state];
    UIButton *button14 = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + 3];
    UIButton *button24 = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + 7];
    if (state==UIGestureRecognizerStateBegan)
    {
        self.initialM14Value = [[[button14 titleLabel] text] floatValue];
        self.initialM24Value = [[[button24 titleLabel] text] floatValue];
    }
    else if (state==UIGestureRecognizerStateChanged)
    {
        float m14 = self.initialM14Value + translation.x/10000;
        float m24 = self.initialM24Value + translation.y/10000;
        [button14 setTitle:[NSString stringWithFormat:@"%.4f", m14] forState:UIControlStateNormal];
        [button24 setTitle:[NSString stringWithFormat:@"%.4f", m24] forState:UIControlStateNormal];
        
        [self applyTransformation];
    }
}

- (void)onPinched:(UIPinchGestureRecognizer*)gesture
{
    float scale = [gesture scale];
    UIGestureRecognizerState state = [gesture state];
    UIButton *button11 = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + 0];
    UIButton *button21 = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + 5];
    if (state==UIGestureRecognizerStateBegan)
    {
        self.initialXScale = [[[button11 titleLabel] text] floatValue];
        self.initialYScale = [[[button21 titleLabel] text] floatValue];
    }
    else if (state==UIGestureRecognizerStateChanged)
    {
        float xScale = self.initialXScale + scale - 1;
        float yScale = self.initialYScale + scale - 1;
        
        [button11 setTitle:[NSString stringWithFormat:@"%.4f", xScale] forState:UIControlStateNormal];
        [button21 setTitle:[NSString stringWithFormat:@"%.4f", yScale] forState:UIControlStateNormal];
        
        [self applyTransformation];
    }
}

- (void)onResetButtonPressed
{
    self.gridView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.gridView.layer setNeedsDisplay];
    
    CATransform3D transformation = CATransform3DIdentity;
    [UIView animateWithDuration:0.5 animations:^{
        self.gridView.layer.transform = transformation;
    } completion:^(BOOL finished) {
        
        for (int row=0; row<4; row++)
        {
            for (int col=0; col<4; col++)
            {
                UIButton *button = (UIButton*)[self.matrixBoxView viewWithTag:TAG_BUTTON + col + 4*row];
                if (row==0 && col==0) [button setTitle:@"1.0" forState:UIControlStateNormal];
                else if (row==1 && col==1) [button setTitle:@"1.0" forState:UIControlStateNormal];
                else if (row==2 && col==2) [button setTitle:@"1.0" forState:UIControlStateNormal];
                else if (row==3 && col==3) [button setTitle:@"1.0" forState:UIControlStateNormal];
                else [button setTitle:@"0.0" forState:UIControlStateNormal];
            }
        }
        
        [self.sliderView setValue:0.0];
        [self.xRotationSliderView setValue:0];
        [self.yRotationSliderView setValue:0];
        [self.zRotationSliderView setValue:0];
        
        [self.xRotationLabel setText:@"x: 0.0˚"];
        [self.yRotationLabel setText:@"y: 0.0˚"];
        [self.zRotationLabel setText:@"z: 0.0˚"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
