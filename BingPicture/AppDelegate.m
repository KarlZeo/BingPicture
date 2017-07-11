//
//  AppDelegate.m
//  BingPicture
//
//  Created by Zeo on 11/07/2017.
//  Copyright © 2017 Zeo. All rights reserved.
//

#import "AppDelegate.h"
#import "KZImageViewController.h"
#import <YTKNetwork.h>
#import "KZBingImageApiRequest.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong,nonatomic) NSStatusItem *item;
@property (strong) NSPopover *popover;
@property(nonatomic)BOOL  isShow;
@property (nonatomic,copy) NSString *url;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = @"https://www.bing.com";
    config.cdnUrl = config.baseUrl;
    
    KZBingImageApiRequest *api = [[KZBingImageApiRequest alloc]initWithIDX:@"0" n:@"1"];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dict = request.responseJSONObject;
        NSArray *imageArray = dict[@"images"];
        NSDictionary *imageDict = imageArray.firstObject;
        NSString *url = [NSString stringWithFormat:@"%@%@",config.baseUrl,imageDict[@"url"]];
        self.url = url;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
    
    //获取系统单例NSStatusBar对象
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    
    //创建固定宽度的NSStatusItem
    NSStatusItem *item = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    
    [item.button setTarget:self];
    
    [item.button setAction:@selector(itemAction:)];
    
    item.title = @"B";
    
//    item.button.image = [NSImage imageNamed:@"blue@2x.png"];
    
    //设置下拉菜单
    // item.menu = self.shareMenu;
    
    //保存到属性变量
    self.item = item;
    
    [self setUpPopover];
}

- (void) setUpPopover {
    self.popover = [[NSPopover alloc] init];
    self.popover.contentViewController = [[KZImageViewController alloc] init];
    self.popover.behavior = NSPopoverBehaviorApplicationDefined;
}

-(IBAction)itemAction:(id)sender {
    if (!self.isShow) {
        [self.popover showRelativeToRect:NSZeroRect ofView:[self item].button preferredEdge:NSRectEdgeMinY];
    } else {
        [self.popover close];
    }
    
    self.isShow = ~self.isShow;
    
    //    [[NSRunningApplication currentApplication] activateWithOptions:(NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps)];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    [statusBar removeStatusItem:self.item];
}


@end
