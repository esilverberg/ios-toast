//
//  ToastMessage.h
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

#import <Three20/Three20.h>

@protocol ToastCloseDelegate;
@interface ToastMessage : UIView {
	TTView*                   _bezelView;
	UILabel*                  _label;
	TTButton *				  _closeButton;
	id _delegate;
}

@property (nonatomic, assign)   NSString* text;
@property (nonatomic, assign) id<ToastCloseDelegate> delegate;

- (CGSize) preferredSize;
@end


@protocol ToastCloseDelegate
- (void)toastClose;
@end
