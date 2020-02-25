//
//  ViewController.m
//  CGBasicGraph
//
//  Created by Gguomingyue on 2017/11/17.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import "ViewController.h"
#import "KCView.h"
#import <WebKit/WebKit.h>

@interface ViewController ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KCView *view=[[KCView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    
    /*
    UIImage *image=[self drawImageAtImageContext];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
    imageView.center=CGPointMake(160, 284);
    
    [self.view addSubview:imageView];
     */
    
    //[self drawContentToPdfContext];
    //[self loadPDF];
}

-(UIImage *)drawImageAtImageContext
{
    CGSize size = CGSizeMake(180, 300);
    UIGraphicsBeginImageContext(size);
    
    UIImage *image = [UIImage imageNamed:@"ice1.jpeg"];
    [image drawInRect:CGRectMake(0, 0, 180, 300)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 120, 200);
    CGContextAddLineToPoint(context, 178, 200);
    
    [[UIColor redColor] setStroke];
    CGContextSetLineWidth(context, 2);
    CGContextDrawPath(context, kCGPathStroke);
    
    NSString *str = @"Kenshin Cui";
    [str drawInRect:CGRectMake(120, 180, 100, 30) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Marker Felt" size:15],NSForegroundColorAttributeName:[UIColor redColor]}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    return newImage;
}

-(void)drawContentToPdfContext
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths firstObject] stringByAppendingString:@"myPDF.pdf"];
    NSLog(@"path = %@",path);
    
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, [NSDictionary dictionaryWithObjectsAndKeys:@"Kenshin Cui",kCGPDFContextAuthor, nil]);
    
    // 由于pdf分页，所以首先要创建一页画布供我们绘制
    UIGraphicsBeginPDFPage();
    
    NSString *title = @"Welcome to Apple Support";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSTextAlignment align = NSTextAlignmentCenter;
    style.alignment = align;
    [title drawInRect:CGRectMake(26, 20, 300, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSParagraphStyleAttributeName:style}];
    NSString *content = @"Learn about Apple products, view online manuals, get the latest downloads, and more. Connect with other Apple users, or get service, support, and professional advice from Apple.";
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc]init];
    style2.alignment = NSTextAlignmentLeft;
    [content drawInRect:CGRectMake(26, 56, 300, 255) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor grayColor],NSParagraphStyleAttributeName:style2}];
    
    UIImage *image = [UIImage imageNamed:@"ice.jpg"];
    [image drawInRect:CGRectMake(316, 20, 290, 305)];
    
    UIImage *image2 = [UIImage imageNamed:@"ice1.jpeg"];
    [image2 drawInRect:CGRectMake(6, 320, 600, 281)];
    
    // 创建新的一页继续绘制其他内容
    UIGraphicsBeginPDFPage();
    UIImage *image3 = [UIImage imageNamed:@"ice2.jpg"];
    [image3 drawInRect:CGRectMake(6, 20, 600, 629)];
    
    //结束上下文
    UIGraphicsEndPDFContext();
}

-(void)loadPDF
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths firstObject] stringByAppendingString:@"myPDF.pdf"];
    NSLog(@"path = %@",path);
    if (path) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = [UIScreen mainScreen].bounds;
        webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:webView];
        NSURL *url = [NSURL URLWithString:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //[webView loadFileURL:[NSURL URLWithString:@"myPDF.pdf"] allowingReadAccessToURL:[NSURL URLWithString:[paths firstObject]]];
        [webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
