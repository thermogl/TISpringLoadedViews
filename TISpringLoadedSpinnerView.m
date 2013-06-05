//
//  TISpringLoadedSpinnerView.m
//  TISpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "TISpringLoadedSpinnerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TISpringLoadedSpinnerView {
	CGFloat _rotation;
	CGFloat _restRotation;
	CGFloat _velocity;
}
@synthesize springConstant = _springConstant;
@synthesize dampingCoefficient = _dampingCoefficient;
@synthesize mass = _mass;

- (id)initWithFrame:(CGRect)frame {
	
	if ((self = [super initWithFrame:frame])){
		
		[self setBackgroundColor:[UIColor clearColor]];
		[self setOpaque:NO];
		
		_rotation = 0;
		_restRotation = 0;
		_springConstant = 200;
		_dampingCoefficient = 15;
		_mass = 1;
		_velocity = 0;
	}
	
	return self;
}

- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink {
	
	for (int i = 0; i < displayLink.frameInterval; i++){
		
		CGFloat displacement = _rotation - _restRotation;
		CGFloat kx = _springConstant * displacement;
		CGFloat bv = _dampingCoefficient * _velocity;
		CGFloat acceleration = (kx + bv) / _mass;
		
		_velocity -= (acceleration * displayLink.duration);
		_rotation += (_velocity * displayLink.duration);
		
		[self setTransform:CGAffineTransformMakeRotation(_rotation * M_PI / 180)];
		
		if (fabsf(_velocity) < 1) _restRotation += (arc4random() & 2 ? 90 : -90);
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
