//
//  RootViewController.m
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

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
