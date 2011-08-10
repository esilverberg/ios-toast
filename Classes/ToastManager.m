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

static const double kDisplayTime = 4.5;
static const double kFadeTime = 0.25;
static const double kHeightOffset = 68;

@implementation ToastManager

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
		if (firstSubview && [[firstSubview subviews] count] > 0)
		{
			parentView = [[firstSubview subviews] objectAtIndex:0];
			
			CGSize preferredSize = [self.currentToast preferredSize];
			
			self.currentToast.frame = CGRectMake((parentView.width - preferredSize.width)/2.0, 
												 kHeightOffset,
												 preferredSize.width,
												 preferredSize.height);
			
			[parentView addSubview:self.currentToast];
			
			// removeMessage or finishedFadingOut will do the release on this alloc
			[UIView beginAnimations:nil context:self.currentToast];
			[UIView setAnimationDuration:kFadeTime];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(finishedFadingIn:finished:context:)];
			self.currentToast.alpha = 1.0;
			[UIView commitAnimations];
		}
		[_messages removeObjectAtIndex:0]; // remove from stack		
	}
}

- (void) finishedFadingIn:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
	ToastMessage *message = (ToastMessage*)context;
	message.visible = YES;
	if (!message.isSticky || message.isShouldClose)
	{
		[self performSelector:@selector(removeMessage:) withObject:context afterDelay:kDisplayTime];
	}
}

- (void) finishedFadingOut:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{	
	ToastMessage *message = (ToastMessage*)context;
	if (message == self.currentToast) // we want to do the pointer check
	{
		[message removeFromSuperview];
		self.currentToast = nil;
		[self displayNextMessage];
	}
}

- (void) removeMessage:(void*)ctxTargetToast
{
	ToastMessage *message = (ToastMessage*)ctxTargetToast;
	if (message.isVisible && !message.isClosing)
	{
		message.closing = YES;
		[UIView beginAnimations:nil context:message];
		[UIView setAnimationDuration:kFadeTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishedFadingOut:finished:context:)];
		message.alpha = 0.0;
		[UIView commitAnimations];
	} else {
		message.shouldClose = YES;
	}
}

- (void)alert:(NSString*)text sticky:(BOOL)isSticky code:(NSInteger)alertCode
{	
	if (alertCode > 0 && self.currentToast && self.currentToast.code == alertCode)
		return;
	
	if (isSticky)
	{
		for (ToastMessage *m in _messages)
			if (m.code == alertCode) return;
	}
	
	ToastMessage* message = [[[ToastMessage alloc] initWithFrame:CGRectZero] autorelease];
	message.delegate = self;
	message.text = text;
	message.alpha = 0.0;
	message.sticky = isSticky;
	message.code = alertCode;
	message.toastId = _lastToastId++;
	
	[_messages addObject:message];
	[self displayNextMessage];
}

- (void) toastClose:(NSInteger)alertCode
{
	if (self.currentToast && self.currentToast.code == alertCode)
	{
		// removeMessage or finishedFadingOut does the release on this alloc
		[self performSelector:@selector(removeMessage:) withObject:self.currentToast afterDelay:0];
	}
	
	// Also remove any that are pending
	for (NSInteger i = [_messages count] - 1; i >= 0; i--)
	{
		ToastMessage *message = [_messages objectAtIndex:i];
		if (message.code == alertCode)
		{
			[_messages removeObjectAtIndex:i];
		}
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
