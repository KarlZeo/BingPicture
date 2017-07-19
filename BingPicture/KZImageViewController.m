//
//  KZImageViewController.m
//  BingPicture
//
//  Created by Zeo on 11/07/2017.
//  Copyright © 2017 Zeo. All rights reserved.
//

#import "KZImageViewController.h"

@interface KZImageViewController ()

@property (nonatomic,strong) NSScreen *curScreen;

@end

@implementation KZImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
//    self.imageView = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, self.view.bounds.size.width - 20, self.view.bounds.size.height - 20)];
    self.imageView = [[NSButton alloc] initWithFrame:NSMakeRect(10, 10, 640, 360)];
    self.imageView.wantsLayer = YES;
    self.imageView.layer.backgroundColor = [NSColor redColor].CGColor;
    self.imageView.title = @"";
    [self.imageView setTarget:self];
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:self.fileUrl];
    [self.imageView setImage:image];
    [self.imageView setAction:@selector(imageViewClick)];
    [self.view addSubview:self.imageView];
}

-(void)imageViewClick{
    NSDictionary *screenOptions = [[NSWorkspace sharedWorkspace] desktopImageOptionsForScreen:[NSScreen mainScreen]];
    NSError *error = nil;
    [[NSWorkspace sharedWorkspace] setDesktopImageURL:self.fileUrl forScreen:[NSScreen mainScreen] options:screenOptions error:&error];

}

@end
