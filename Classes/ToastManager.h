//
//  ToastManager.h
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

#import <Three20/Three20.h>
#import "ToastMessage.h"

@class ToastMessageData;
@interface ToastManager : NSObject <ToastCloseDelegate> {
	NSMutableArray *_messages;
	ToastMessage *_activeLabel;
	ToastMessageData *_currentToast;
	NSInteger _lastToastId;
}

@property (nonatomic, retain) ToastMessage *activeLabel;
@property (nonatomic, retain) ToastMessageData *currentToast;

- (void) alert:(NSString*)message sticky:(BOOL)isSticky code:(NSInteger)alertCode;
- (void) toastClose:(NSInteger)alertCode;
- (void) toastClose;
@end

@interface ToastMessageData : NSObject {
	NSInteger toastId;
	NSString *message;
	NSInteger code;
	BOOL sticky;
}

@property (nonatomic) NSInteger toastId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic) NSInteger code;
@property (nonatomic) BOOL sticky;

@end