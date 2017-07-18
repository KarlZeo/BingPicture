//
//  KZImageViewController.m
//  BingPicture
//
//  Created by Zeo on 11/07/2017.
//  Copyright © 2017 Zeo. All rights reserved.
//

#import "KZImageViewController.h"

@interface KZImageViewController ()

@end

@implementation KZImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.imageView = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, self.view.bounds.size.width - 20, self.view.bounds.size.height - 20)];
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = [NSColor redColor].CGColor;
    self.imageView.title = @"";
//    self.imageView.image
    [self.view addSubview:self.imageView];
}

-(void)hahaha{
    NSLog(@"123");
}

@end
