//
//  ToastMessage.m
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


#import "ToastMessage.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

static CGFloat kMargin          = 10;
static CGFloat kPadding         = 15;
static CGFloat kMaxMessageHeight = 300;
static CGFloat kMaxWidth         = 320;

@implementation ToastMessage

@synthesize toastId = _toastId;
@synthesize code = _code;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.autoresizesSubviews = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
		_bezelView = [[TTView alloc] init];
		_bezelView.backgroundColor = [UIColor clearColor];
		_bezelView.style = TTSTYLE(blackBezel);
		_bezelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		
		_label = [[UILabel alloc] init];
		_label.backgroundColor = [UIColor clearColor];
		_label.lineBreakMode = UILineBreakModeTailTruncation;
		
		_label.font = [UIFont systemFontOfSize:13];
		_label.textColor = [UIColor whiteColor];
		_label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
		_label.shadowOffset = CGSizeMake(1, 1);
		
		_closeButton = [[TTButton buttonWithStyle:@"closeButton:" title:nil] retain];		
		_closeButton.frame = CGRectMake(0, 0, 30, 30);
		[_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		_closeButton.hidden = YES;
		
		[self addSubview:_bezelView];
		[_bezelView addSubview:_label];
		[self addSubview:_closeButton];
		
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		_activityIndicator.hidden = YES;
		[self addSubview:_activityIndicator];
	}
	return self;
}

- (void)dealloc {
	_delegate = nil;
	TT_RELEASE_SAFELY(_bezelView);
	TT_RELEASE_SAFELY(_label);
	TT_RELEASE_SAFELY(_closeButton);
	[super dealloc];
}

- (void) closeButtonClicked:(id)sender
{
	if ([_delegate respondsToSelector:@selector(toastClose)])
	{
		[_delegate toastClose];
	}
}

- (CGSize) preferredSize
{
	CGFloat buttonWidth = _closeButton.width;
	CGFloat textMaxWidth = kMaxWidth - kMargin*2 - kPadding*2 - buttonWidth - kMargin;
	CGSize textSize = [_label.text sizeWithFont:_label.font 
							  constrainedToSize:CGSizeMake(textMaxWidth, kMaxMessageHeight) lineBreakMode:UILineBreakModeWordWrap]; 
	CGSize preferredSize = CGSizeMake(kMaxWidth - kMargin*2, textSize.height + kPadding*2);
	return preferredSize;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat buttonWidth = _closeButton.width;
	CGFloat textMaxWidth = kMaxWidth - kMargin*2 - kPadding*2 - buttonWidth - kMargin;
	CGSize textSize = [_label.text sizeWithFont:_label.font 
							  constrainedToSize:CGSizeMake(textMaxWidth, kMaxMessageHeight) lineBreakMode:UILineBreakModeWordWrap]; 
	
	_label.numberOfLines = floor(textSize.height / _label.font.ttLineHeight);
	
	CGFloat contentHeight = textSize.height;
	
	CGFloat margin, padding, bezelWidth, bezelHeight;
	margin = kMargin;
	padding = kPadding;
	bezelWidth = kMaxWidth - kMargin*2;
	bezelHeight = contentHeight + padding*2;
	
	CGFloat maxBevelWidth = kMaxWidth - margin*2;
	if (bezelWidth > maxBevelWidth) {
		bezelWidth = maxBevelWidth;
	}
	
	CGFloat textWidth = textSize.width;	
	_bezelView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
	NSLog(@"Bezel frame is %@",NSStringFromCGRect(_bezelView.frame));
	
	CGFloat y = padding + floor((bezelHeight - padding*2)/2 - contentHeight/2);		
	_label.frame = CGRectMake(padding, y,
							  textWidth, textSize.height);	
	
	NSLog(@"Label frame is %@",NSStringFromCGRect(_label.frame));

	if (_sticky)
	{
		_activityIndicator.hidden = NO;
		[_activityIndicator sizeToFit];
		_activityIndicator.frame = CGRectMake(bezelWidth - _activityIndicator.width - margin, 
											  (bezelHeight - _activityIndicator.height)/2.0, 
											  _activityIndicator.width, _activityIndicator.height);;
		[_activityIndicator startAnimating];
	}
	else
	{
		_closeButton.hidden = NO;
		_closeButton.frame = CGRectMake(bezelWidth - _closeButton.width - margin, (bezelHeight - _closeButton.height)/2.0, _closeButton.width, _closeButton.height);;
	}
	NSLog(@"Close frame is %@",NSStringFromCGRect(_closeButton.frame));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)sizeThatFits:(CGSize)size {
	CGFloat padding;
	padding = kPadding;
	
	CGFloat height = _label.font.ttLineHeight + padding*2;
	return CGSizeMake(size.width, height);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)text {
	return _label.text;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(NSString*)text {
	_label.text = text;
	[self setNeedsLayout];
}

- (void) setSticky:(BOOL)b
{
	_sticky = b;
}
- (BOOL) isSticky
{
	return _sticky;
}

- (void) setClosing:(BOOL)b
{
	_closing = b;
}
- (BOOL) isClosing
{
	return _closing;
}

@end
