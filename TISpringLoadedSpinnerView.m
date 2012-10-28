//
//  TISpringLoadedSpinnerView.m
//  TISpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "TISpringLoadedSpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TISpringLoadedSpinnerView
@synthesize springConstant;
@synthesize dampingCoefficient;
@synthesize mass;

- (id)initWithFrame:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])){
		
		[self setBackgroundColor:[UIColor clearColor]];
		[self setOpaque:NO];
		
		rotation = 0;
		restRotation = 0;
		springConstant = 200;
		dampingCoefficient = 15;
		mass = 1;
		velocity = 0;
	}
	
	return self;
}

- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink {
	
	for (int i = 0; i < displayLink.frameInterval; i++){
		
		CGFloat displacement = rotation - restRotation;
		CGFloat kx = springConstant * displacement;
		CGFloat bv = dampingCoefficient * velocity;
		CGFloat acceleration = (kx + bv) / mass;
		
		velocity -= (acceleration * displayLink.duration);
		rotation += (velocity * displayLink.duration);
		
		[self setTransform:CGAffineTransformMakeRotation(rotation * M_PI / 180)];
		
		if (fabsf(velocity) < 1) restRotation += 90 * (arc4random() % 2 ? 1 : -1);
	}
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, (CGFloat[4]){0.4, 0.4, 0.4, 1});
	
	CGFloat divisionX = self.bounds.size.width / 3;
	CGFloat divisionY = self.bounds.size.height / 3;
	
	for (int x = 0; x < 3; x++){
		for (int y = 0; y < 3; y++){
			if (x != 1 || y != 2) CGContextFillEllipseInRect(context, CGRectMake(x * divisionX, y * divisionY, divisionX, divisionY));
		}
	}
}

@end
