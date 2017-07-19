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
@property (nonatomic,strong) NSURL *fileURL;

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
    [self setUpStatusBar];
    KZBingImageApiRequest *api = [[KZBingImageApiRequest alloc]initWithIDX:@"0" n:@"1"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dict = request.responseJSONObject;
        NSArray *imageArray = dict[@"images"];
        NSDictionary *imageDict = imageArray.firstObject;
        NSString *url = [NSString stringWithFormat:@"%@%@",config.baseUrl,imageDict[@"url"]];
        NSString *filename = [NSString stringWithFormat:@"%@.jpg",imageDict[@"startdate"]];
        [self downloadWithUrl:url FileName:filename];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

-(NSURL *)downloadWithUrl:(NSString *)urlString FileName :(NSString *)fileName{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        NSNotification *notify = [NSNotification notificationWithName:@"fileurl" object:filePath];
//        [center postNotification:notify];
        self.fileURL = filePath;
        [self setUpPopover];
    }];
    [downloadTask resume];
    return  self.fileURL;
}

//-(NSString *)getDocumentsPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    NSLog(@"path:%@", path);
//    return path;
//}

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
    
}

- (void) setUpPopover {
    self.popover = [[NSPopover alloc] init];
    [self.popover setContentSize:NSMakeSize(660, 380)];
    KZImageViewController *vc = [[KZImageViewController alloc] init];
    self.popover.contentViewController = vc;
    vc.fileUrl = self.fileURL;
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
