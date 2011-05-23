//
//  AppDelegate.m
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "ToastStyle.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication*)application {
    
    // Override point for customization after application launch.
    
    // Add the navigation controller's view to the window and display.
	TTStyleSheet *toastStyle = [[[ToastStyle alloc] init] autorelease];
	[TTStyleSheet setGlobalStyleSheet:toastStyle];
	
	TTNavigator* navigator = [TTNavigator navigator];
	TTURLMap* map = navigator.URLMap;
	[map from:@"tt://root" toViewController:[RootViewController class]];

	[navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://root"]];	

}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	return YES;
}

@end

