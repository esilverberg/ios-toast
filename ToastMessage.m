//
//  ToastMessage.m
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

#import "ToastMessage.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

static CGFloat kMargin          = 10;
static CGFloat kPadding         = 15;
static CGFloat kMaxMessageHeight = 300;
static CGFloat kMaxWidth         = 320;

@implementation ToastMessage

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		self.autoresizesSubviews = YES;
		_bezelView = [[TTView alloc] init];
		_bezelView.backgroundColor = [UIColor clearColor];
		_bezelView.style = TTSTYLE(blackBezel);
		_bezelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
		
		_label = [[UILabel alloc] init];
		_label.backgroundColor = [UIColor clearColor];
		_label.lineBreakMode = UILineBreakModeTailTruncation;
		
		_label.font = [UIFont systemFontOfSize:14];
		_label.textColor = [UIColor whiteColor];
		_label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
		_label.shadowOffset = CGSizeMake(1, 1);
		
		_closeButton = [[TTButton buttonWithStyle:@"closeButton:" title:@"x"] retain];		
		_closeButton.font = [UIFont boldSystemFontOfSize:14];
		[_closeButton sizeToFit];
		[_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:_bezelView];
		[_bezelView addSubview:_label];
		[self addSubview:_closeButton];
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
	
	_closeButton.frame = CGRectMake(bezelWidth - _closeButton.width - margin, (bezelHeight - _closeButton.height)/2.0, _closeButton.width, _closeButton.height);
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

@end
