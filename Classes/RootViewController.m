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

	_stickyPostButton = [[TTButton buttonWithStyle:@"textBarPostButton:"
									   title:NSLocalizedString(@"Sticky", @"")] retain];
	[_stickyPostButton addTarget:self action:@selector(stickyPostButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_stickyPostButton setEnabled:YES];
	_stickyPostButton.frame = CGRectMake(2*10 + _postButton.frame.size.width, 
										 _editor.frame.origin.y + _editor.frame.size.height + 10, 100, 40);
	[self.view addSubview:_stickyPostButton];

	_stickyClearButton = [[TTButton buttonWithStyle:@"textBarPostButton:"
											 title:NSLocalizedString(@"Clear", @"")] retain];
	[_stickyClearButton addTarget:self action:@selector(stickyClearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_stickyClearButton setEnabled:YES];
	_stickyClearButton.frame = CGRectMake(3*10 + _postButton.frame.size.width + _stickyPostButton.frame.size.width, 
										 _editor.frame.origin.y + _editor.frame.size.height + 10, 100, 40);
	[self.view addSubview:_stickyClearButton];

	self.view.autoresizesSubviews = YES;
	
}	
- (void) viewDidUnload
{
	TT_RELEASE_SAFELY(_editor);
	TT_RELEASE_SAFELY(_postButton);
	TT_RELEASE_SAFELY(_stickyPostButton);
	TT_RELEASE_SAFELY(_stickyClearButton);
	TT_RELEASE_SAFELY(_toastManager);
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)alertButtonClicked:(id)sender
{
	NSString *text = [_editor text];
	[_toastManager alert:text sticky:NO code:0];
	[_editor resignFirstResponder];
}

- (void) stickyPostButtonClicked:(id)sender
{
	NSString *text = [_editor text];
	[_toastManager alert:text sticky:YES code:1];
	[_editor resignFirstResponder];
	
}
- (void) stickyClearButtonClicked:(id)sender
{
	[_toastManager toastClose:1];
}
@end
