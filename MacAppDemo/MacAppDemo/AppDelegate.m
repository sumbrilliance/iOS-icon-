//
//  AppDelegate.m
//  MacAppDemo
//
//  Created by sumbrilliance on 16/2/15.
//  Copyright © 2016年 sumbrilliance. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"

@interface AppDelegate ()<NSWindowDelegate>

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    MainVC *vc = [[MainVC alloc] init];

    

    self.window.contentViewController = vc;
    self.window.delegate = self;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp terminate:self];
}
@end
