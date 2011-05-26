//
//  ToastMessage.h
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

@protocol ToastCloseDelegate;
@interface ToastMessage : UIView {
	TTView*                   _bezelView;
	UILabel*                  _label;
	TTButton *				  _closeButton;
	UIActivityIndicatorView * _activityIndicator;
	id _delegate;
}

@property (nonatomic, assign)   NSString* text;
@property (nonatomic, assign) id<ToastCloseDelegate> delegate;
@property (nonatomic) BOOL hidesCloseButton;

- (CGSize) preferredSize;
@end


@protocol ToastCloseDelegate
- (void)toastClose;
@end
