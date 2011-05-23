//
//  ToastManager.h
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

#import <Three20/Three20.h>
#import "ToastMessage.h"

@interface ToastManager : NSObject <ToastCloseDelegate> {
	NSMutableArray *_messages;
	ToastMessage *_activeLabel;
	NSInteger _currentToast;
	NSInteger _lastToastId;
}

@property (nonatomic, retain) ToastMessage *activeLabel;
- (void) alert:(NSString*)message;
@end
