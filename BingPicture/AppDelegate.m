//
//  AppDelegate.m
//  BingPicture
//
//  Created by Zeo on 11/07/2017.
//  Copyright © 2017 Zeo. All rights reserved.
//

#import "AppDelegate.h"
#import "KZImageViewController.h"
#import "YTKNetwork.h"
#import "KZBingImageApiRequest.h"
#import "AFURLSessionManager.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong,nonatomic) NSStatusItem *item;
@property (strong) NSPopover *popover;
@property(nonatomic)BOOL  isShow;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self setupNetwork];
    
}

-(void) setupNetwork {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"https://www.bing.com";
    config.cdnUrl = config.baseUrl;
    
    KZBingImageApiRequest *api = [[KZBingImageApiRequest alloc]initWithIDX:@"0" n:@"1"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dict = request.responseJSONObject;
        NSArray *imageArray = dict[@"images"];
        NSDictionary *imageDict = imageArray.firstObject;
        NSString *url = [NSString stringWithFormat:@"%@%@",config.baseUrl,imageDict[@"url"]];
        NSString *filename = [NSString stringWithFormat:@"%@.jpg",imageDict[@"startdate"]];
        
        [self setUpStatusBar];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(void)downloadWithUrl:(NSString *)urlString{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSPicturesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}

-(void) setUpStatusBar {
    //获取系统单例NSStatusBar对象
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    
    //创建固定宽度的NSStatusItem
    NSStatusItem *item = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    
    [item.button setTarget:self];
    
    [item.button setAction:@selector(itemAction:)];
    
    item.title = @"B";
    
    //保存到属性变量
    self.item = item;
    
    [self setUpPopover];
}

- (void) setUpPopover {
    self.popover = [[NSPopover alloc] init];
    KZImageViewController *vc = [[KZImageViewController alloc] init];
    self.popover.contentViewController = vc;
    self.popover.behavior = NSPopoverBehaviorApplicationDefined;
}

-(IBAction)itemAction:(id)sender {
    if (!self.isShow) {
        [self.popover showRelativeToRect:NSZeroRect ofView:[self item].button preferredEdge:NSRectEdgeMinY];
    } else {
        [self.popover close];
    }
    
    self.isShow = ~self.isShow;
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    [statusBar removeStatusItem:self.item];
}


@end
