//
//  AppDelegate.m
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. 
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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

