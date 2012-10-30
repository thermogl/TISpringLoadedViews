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

@implementation RootViewController

- (void)viewDidLoad {
	
	springLoadedView = [[TISpringLoadedView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[springLoadedView setRestCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))]; // Set where the view should spring back to.
	[springLoadedView setSpringConstant:500]; // Set a spring constant. Effectively, as you increase this, the speed at which the spring returns to rest increases
	[springLoadedView setDampingCoefficient:15]; // A damping coefficient. Shouldn't be negative or you'll bounce off screen.
	[springLoadedView setInheritsPanVelocity:YES]; // Setting to YES allows you to throw the view. Doesn't play nice with panDistanceLimits.
	[springLoadedView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:springLoadedView];
	[springLoadedView release];
	
	// Like the one in the Letterpress app by Loren Brichter (atebits.com)
	spinnerView = [[TISpringLoadedSpinnerView alloc] initWithFrame:CGRectInset(springLoadedView.bounds, 15, 15)];
	[springLoadedView addSubview:spinnerView];
	[spinnerView release];
	
	// Create the display link. I use one to handle all the views.
	displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)] retain];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[springLoadedView setRestCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
}

- (void)displayLinkTick:(CADisplayLink *)link {
	[spinnerView simulateSpringWithDisplayLink:link];
	[springLoadedView simulateSpringWithDisplayLink:link];
}

- (void)dealloc {
	[displayLink invalidate];
	[displayLink release];
	[super dealloc];
}

@end