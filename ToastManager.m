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

@implementation ToastManager

@synthesize activeLabel = _activeLabel;

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
	[super dealloc];
}

- (void) displayNextMessage
{
	if ([_messages count] > 0 && !_currentToast)
	{
		UIView *parentView = nil;		
		NSString *message = [_messages objectAtIndex:0];		
		UIWindow* window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];			
		}		
		UIView *firstSubview = [[window subviews] objectAtIndex:0];
		parentView = [[firstSubview subviews] objectAtIndex:0];
		
		_currentToast = ++_lastToastId;
		
		ToastMessage* label = [[[ToastMessage alloc] initWithFrame:CGRectZero] autorelease];
		label.delegate = self;
		label.text = message;
		label.alpha = 0.0;
		
		CGSize preferredSize = [label preferredSize];
		label.frame = CGRectMake((parentView.width - preferredSize.width)/2.0, 
								 (parentView.height - preferredSize.height)/2.0,
								 preferredSize.width,
								 preferredSize.height);
		label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
		[parentView addSubview:label];
		
		self.activeLabel = label;
		
		// removeMessage or finishedFadingOut will do the release on this alloc
		NSNumber *ctxToastId = [[NSNumber alloc] initWithInt:_currentToast];
		[UIView beginAnimations:nil context:ctxToastId];
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
	[self performSelector:@selector(removeMessage:) withObject:context afterDelay:kDisplayTime];
}

- (void) finishedFadingOut:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{	
	NSNumber *targetToast = (NSNumber*)context;
	[targetToast release];
	
	[self.activeLabel removeFromSuperview];
	self.activeLabel = nil;
	_currentToast = 0;
	[self displayNextMessage];
}

- (void) removeMessage:(void*)ctxTargetToast
{
	NSNumber *targetToast = (NSNumber*)ctxTargetToast;
	
	if (_currentToast == [targetToast intValue])
	{
		[UIView beginAnimations:nil context:targetToast];
		[UIView setAnimationDuration:kFadeTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishedFadingOut:finished:context:)];
		self.activeLabel.alpha = 0.0;
		[UIView commitAnimations];
	}
	else
	{
		[targetToast release];
	}
}

- (void)alert:(NSString*)message
{
	[_messages addObject:message];
	[self displayNextMessage];
}

- (void) toastClose
{
	if (_currentToast)
	{
		// removeMessage or finishedFadingOut does the release on this alloc
		NSNumber *ctxToastId = [[NSNumber alloc] initWithInt:_currentToast];
		[self performSelector:@selector(removeMessage:) withObject:ctxToastId afterDelay:0];
	}
}
@end
