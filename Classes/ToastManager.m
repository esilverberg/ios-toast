//
//  ToastManager.m
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

#import "ToastManager.h"
#import <Three20/Three20.h>
#import "Three20UI/UIViewAdditions.h"

static const double kDisplayTime = 4.0;
static const double kFadeTime = 0.5;

@implementation ToastMessageData

@synthesize toastId;
@synthesize message;
@synthesize code;
@synthesize sticky;

- (void) dealloc
{
	TT_RELEASE_SAFELY(message);
	[super dealloc];
}
@end

@implementation ToastManager

@synthesize activeLabel = _activeLabel;
@synthesize currentToast = _currentToast;

- (id) init
{
	if (self = [super init])
	{
		_messages = [[NSMutableArray alloc] initWithCapacity:10];
	}
	
	return self;
}

- (void) dealloc
{
	TT_RELEASE_SAFELY(_activeLabel);
	TT_RELEASE_SAFELY(_messages);
	TT_RELEASE_SAFELY(_currentToast);
	[super dealloc];
}

- (void) displayNextMessage
{
	if ([_messages count] > 0 && !self.currentToast)
	{
		UIView *parentView = nil;		
		self.currentToast = [_messages objectAtIndex:0];		
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];			
		}		
		UIView *firstSubview = [[window subviews] objectAtIndex:0];
		parentView = [[firstSubview subviews] objectAtIndex:0];
		
		ToastMessage* label = [[[ToastMessage alloc] initWithFrame:CGRectZero] autorelease];
		label.delegate = self;
		label.text = self.currentToast.message;
		label.alpha = 0.0;
		label.hidesCloseButton = self.currentToast.sticky;
		
		CGSize preferredSize = [label preferredSize];
		label.frame = CGRectMake((parentView.width - preferredSize.width)/2.0, 
								 (parentView.height - preferredSize.height)/2.0,
								 preferredSize.width,
								 preferredSize.height);
		label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
		[parentView addSubview:label];
		
		self.activeLabel = label;
		
		// removeMessage or finishedFadingOut will do the release on this alloc
		[UIView beginAnimations:nil context:self.currentToast];
		[UIView setAnimationDuration:kFadeTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishedFadingIn:finished:context:)];
		self.activeLabel.alpha = 1.0;
		[UIView commitAnimations];
		
		[_messages removeObjectAtIndex:0]; // remove from stack		
	}
}

- (void) finishedFadingIn:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	ToastMessageData *message = (ToastMessageData*)context;
	if (!message.sticky)
		[self performSelector:@selector(removeMessage:) withObject:context afterDelay:kDisplayTime];
}

- (void) finishedFadingOut:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{	
	[self.activeLabel removeFromSuperview];
	self.activeLabel = nil;
	self.currentToast = nil;
	[self displayNextMessage];
}

- (void) removeMessage:(void*)ctxTargetToast
{
	ToastMessageData *message = (ToastMessageData*)ctxTargetToast;
	
	if (self.currentToast.toastId == message.toastId)
	{
		[UIView beginAnimations:nil context:message];
		[UIView setAnimationDuration:kFadeTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishedFadingOut:finished:context:)];
		self.activeLabel.alpha = 0.0;
		[UIView commitAnimations];
	}
}

- (void)alert:(NSString*)message sticky:(BOOL)isSticky code:(NSInteger)alertCode
{
	// Ignore repeat sticky toasts
	if (isSticky)
	{
		if (self.currentToast && self.currentToast.code == alertCode)
			return;
		
		for (ToastMessageData *message in _messages)
		{
			if (message.code == alertCode)
				return;
		}
	}
	
	ToastMessageData *data = [[[ToastMessageData alloc] init] autorelease];
	data.message = message;
	data.sticky = isSticky;
	data.code = alertCode;
	data.toastId = _lastToastId++;
	
	[_messages addObject:data];
	[self displayNextMessage];
}

- (void) toastClose:(NSInteger)alertCode
{
	if (self.currentToast && self.currentToast.code == alertCode)
	{
		// removeMessage or finishedFadingOut does the release on this alloc
		[self performSelector:@selector(removeMessage:) withObject:self.currentToast afterDelay:0];
	}
}

- (void) toastClose
{
	if (self.currentToast)
	{
		// removeMessage or finishedFadingOut does the release on this alloc
		[self performSelector:@selector(removeMessage:) withObject:self.currentToast afterDelay:0];
	}
}

@end
