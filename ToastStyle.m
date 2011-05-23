//
//  ToastStyle.m
//  ios-toast
//
//  Created by Eric Silverberg on 5/23/11.
//  Copyright 2011 Perry Street Software, Inc. All rights reserved.
//

#import "ToastStyle.h"


@implementation ToastStyle

- (TTStyle*)closeButton:(UIControlState)state {
	
	UIColor* fillColor = state == UIControlStateHighlighted
	? RGBCOLOR(153, 153, 153)
	: RGBCOLOR(20, 20, 20);
	UIColor* textColor = state == UIControlStateDisabled
	? RGBACOLOR(255, 255, 255, 0.5)
	: RGBCOLOR(255, 255, 255);
	
	return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
	 [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
	   [TTSolidFillStyle styleWithColor:fillColor next:
		[TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
		  [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
		   [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:18]
								color:textColor next:nil]]]]]];
	
}

@end
