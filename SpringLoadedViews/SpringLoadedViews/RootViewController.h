//
//  RootViewController.h
//  SpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TISpringLoadedSpinnerView, TISpringLoadedView;
@interface RootViewController : UIViewController {
	
	TISpringLoadedSpinnerView * spinnerView;
	TISpringLoadedView * springLoadedView;
	CADisplayLink * displayLink;
}

@end
