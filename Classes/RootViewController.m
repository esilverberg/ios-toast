//
//  RootViewController.m
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

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
		
	self.title = @"Toast Test";
	
	_toastManager = [[ToastManager alloc] init];
	
	CGRect editorFrame = CGRectMake(10, 10, self.view.frame.size.width - 20, 44);
	_editor = [[TTTextEditor alloc] init];
	_editor.style = TTSTYLE(textBarTextField);
	_editor.backgroundColor = [UIColor clearColor];
	_editor.autoresizesToText = YES;
	_editor.maxNumberOfLines = 3;
	_editor.font = [UIFont fontWithName:@"Helvetica" size:15];
	_editor.frame = editorFrame;
	_editor.delegate = self;
	_editor.text = @"Now is the time for all good\nmen to come to the aid of their country. ";
	[_editor sizeToFit];
	[self.view addSubview:_editor];
	
	_postButton = [[TTButton buttonWithStyle:@"textBarPostButton:"
									   title:NSLocalizedString(@"Toast", @"")] retain];
	[_postButton addTarget:self action:@selector(alertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_postButton setEnabled:YES];
	_postButton.frame = CGRectMake(10, _editor.frame.origin.y + _editor.frame.size.height + 10, 100, 40);
	[self.view addSubview:_postButton];
	
	self.view.autoresizesSubviews = YES;
	
}	
- (void) viewDidUnload
{
	TT_RELEASE_SAFELY(_editor);
	TT_RELEASE_SAFELY(_postButton);
	TT_RELEASE_SAFELY(_toastManager);
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)alertButtonClicked:(id)sender
{
	NSString *text = [_editor text];
	[_toastManager alert:text];
	[_editor resignFirstResponder];
}

@end
