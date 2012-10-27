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
	
	displayLink = [[CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)] retain];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(id)kCFRunLoopCommonModes];
	
	springLoadedView = [[TISpringLoadedView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	[springLoadedView setRestCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];
	[springLoadedView setSpringConstant:500];
	[springLoadedView setDampingCoefficient:10];
	[springLoadedView setInheritsPanVelocity:YES];
	[springLoadedView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:springLoadedView];
	[springLoadedView release];
	
	spinnerView = [[TISpringLoadedSpinnerView alloc] initWithFrame:CGRectInset(springLoadedView.bounds, 10, 10)];
	[springLoadedView addSubview:spinnerView];
	[spinnerView release];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[springLoadedView setRestCenter:CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))];}];
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