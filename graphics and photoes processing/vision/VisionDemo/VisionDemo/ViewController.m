//
//  ViewController.m
//  VisionDemo
//
//  Created by Gguomingyue on 2018/3/20.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"
#import <Vision/Vision.h>
#import <objc/runtime.h>
#import "DSDetectData.h"
#import "UIImage+DrawLandmark.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *image = [UIImage imageNamed:@"ice1.jpeg"];
    self.imageView.image = image;
    [self.view addSubview:self.imageView];
    
    //
    [self detectLandmark:image];
}

-(void)detectLandmark:(UIImage *)image
{
    CIImage *converImage = [[CIImage alloc] initWithImage:image];
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:converImage options:@{}];
    __weak typeof(self) weakSelf = self;
    VNImageBasedRequest *request = [[VNDetectFaceLandmarksRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        NSArray *observations = request.results;
        DSDetectData *detectData = [[DSDetectData alloc] init];
        for (VNFaceObservation *observation in observations) {
            // 创建特征存储对象
            DSDetectFaceData *detectFaceData = [[DSDetectFaceData alloc]init];
            // 获取细节特征
            VNFaceLandmarks2D *landmarks = observation.landmarks;
            [weakSelf getAllkeyWithClass:[VNFaceLandmarks2D class] isProperty:YES block:^(NSString *key) {
                // 过滤属性
                if ([key isEqualToString:@"allPoints"]) {
                    return;
                }
                
                // 得到对应细节具体特征（鼻子，眼睛。。。）
                VNFaceLandmarkRegion2D *region2D = [landmarks valueForKey:key];
                
                // 特征存储对象进行存储
                [detectFaceData setValue:region2D forKey:key];
                [detectFaceData.allPoints addObject:region2D];
            }];
            
            detectFaceData.observation = observation;
            [detectData.facePoints addObject:detectFaceData];
            
            UIImage *landmarkImage = nil;
            for (DSDetectFaceData *faceData in detectData.facePoints) {
                landmarkImage = [image drawWithObservation:faceData.observation pointArray:faceData.allPoints];
            }
            self.imageView.image = landmarkImage;
        }
    }];
    [detectRequestHandler performRequests:@[request] error:nil];
}

// 获取对象属性keys
- (NSArray *)getAllkeyWithClass:(Class)class isProperty:(BOOL)property block:(void(^)(NSString *key))block{
    
    NSMutableArray *keys = @[].mutableCopy;
    unsigned int outCount = 0;
    
    Ivar *vars = NULL;
    objc_property_t *propertys = NULL;
    const char *name;
    
    if (property) {
        propertys = class_copyPropertyList(class, &outCount);
    }else{
        vars = class_copyIvarList(class, &outCount);
    }
    
    for (int i = 0; i < outCount; i ++) {
        
        if (property) {
            objc_property_t property = propertys[i];
            name = property_getName(property);
        }else{
            Ivar var = vars[i];
            name = ivar_getName(var);
        }
        
        NSString *key = [NSString stringWithUTF8String:name];
        block(key);
    }
    free(vars);
    return keys.copy;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
