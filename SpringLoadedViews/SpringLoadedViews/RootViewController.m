//
//  RootViewController.m
//  SpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "RootViewController.h"
#import "TISpringLoadedSpinnerView.h"
#import "TISpringLoadedView.h"

@implementation RootViewController {
	TISpringLoadedSpinnerView * _spinnerView;
	TISpringLoadedView * _springLoadedView;
	CADisplayLink * _displayLink;
}

- (void)viewDidLoad {
	
	_springLoadedView = [[TISpringLoadedView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[_springLoadedView setRestCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))]; // Set where the view should spring back to.
	[_springLoadedView setSpringConstant:500]; // Set a spring constant. Effectively, as you increase this, the speed at which the spring returns to rest increases
	[_springLoadedView setDampingCoefficient:15]; // A damping coefficient. Shouldn't be negative or you'll bounce off screen.
	[_springLoadedView setInheritsPanVelocity:YES]; // Setting to YES allows you to throw the view. Doesn't play nice with panDistanceLimits.
	[_springLoadedView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:_springLoadedView];
	
	// Like the one in the Letterpress app by Loren Brichter (atebits.com)
	_spinnerView = [[TISpringLoadedSpinnerView alloc] initWithFrame:CGRectInset(_springLoadedView.bounds, 15, 15)];
	[_springLoadedView addSubview:_spinnerView];
	
	// Create the display link. I use one to handle all the views.
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
	[_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[_springLoadedView setRestCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
}

- (void)displayLinkTick:(CADisplayLink *)link {
	[_spinnerView simulateSpringWithDisplayLink:link];
	[_springLoadedView simulateSpringWithDisplayLink:link];
}

- (void)dealloc {
	[_displayLink invalidate];
}

@end