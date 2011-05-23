//
//  RootViewController.h
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

#import <Three20/Three20.h>
#import "ToastManager.h"

@interface RootViewController : TTViewController <TTTextEditorDelegate> {
	TTTextEditor *_editor;
	TTButton *_postButton;
	ToastManager *_toastManager;
}

@end
