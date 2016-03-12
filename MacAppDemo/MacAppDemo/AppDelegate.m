//
//  AppDelegate.m
//  MacAppDemo
//
//  Created by sumbrilliance on 16/2/15.
//  Copyright © 2016年 sumbrilliance. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    MainVC *vc = [[MainVC alloc] init];

    

    self.window.contentViewController = vc;
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
