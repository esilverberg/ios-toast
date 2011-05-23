//
//  ToastStyle.m
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
