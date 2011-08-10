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

- (TTStyle*)toastBezel {
	return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
	 [TTSolidBorderStyle styleWithColor:RGBACOLOR(255,255,255,0.6) width:4 next:
	  [TTLinearGradientFillStyle 
	   styleWithColor1:RGBACOLOR(51, 51, 51, 0.95)
	   color2:RGBACOLOR(0, 0, 0, 0.95)
	   next:nil]]];
}

- (TTStyle*)closeButton:(UIControlState)state {	
	NSString *imageUrl = (state == UIControlStateHighlighted) ? @"bundle://close_selected.png" : @"bundle://close.png";	
	UIImage* image = TTIMAGE(imageUrl);
	TTImageStyle *style = [TTImageStyle styleWithImage:image next:nil];
	style.contentMode = UIViewContentModeCenter;
	return style;
}

@end
