//
//  TISpringLoadedView.m
//  TISpringLoadedViews
//
//  Created by Tom Irving on 18/09/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "TISpringLoadedView.h"
#import <QuartzCore/QuartzCore.h>

@interface TISpringLoadedView (Private)
- (void)positionLeftAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)positionRightAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer;
@end

@implementation TISpringLoadedView {
	CGPoint _velocity;
	UIPanGestureRecognizer * _panGestureRecognizer;
}
@synthesize mass = _mass;
@synthesize springConstant = _springConstant;
@synthesize dampingCoefficient = _dampingCoefficient;
@synthesize panDragCoefficient = _panDragCoefficient;
@synthesize panDistanceLimits = _panDistanceLimits;
@synthesize restCenter = _restCenter;
@synthesize pannedBlock = _pannedBlock;
@synthesize inheritsPanVelocity = _inheritsPanVelocity;
@synthesize springEnabled = _springEnabled;
@synthesize leftAnchoredView = _leftAnchoredView;
@synthesize rightAnchoredView = _rightAnchoredView;

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		
		_springEnabled = YES;
		
		_restCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
		_springConstant = 250;
		_dampingCoefficient = 20;
		_mass = 1;
		_velocity = CGPointZero;
		
		_panDistanceLimits = UIEdgeInsetsMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX);
		_pannedBlock = nil;
		_panDragCoefficient = 1.0;
		_inheritsPanVelocity = NO;
		
		_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasPanned:)];
		[self addGestureRecognizer:_panGestureRecognizer];
    }
	
    return self;
}

#pragma mark - Property Overrides
- (BOOL)panning {
	return (_panGestureRecognizer.state == UIGestureRecognizerStateChanged);
}

#pragma mark - Physics
- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink {
	
	if (_springEnabled && !self.panning){
		for (int i = 0; i < displayLink.frameInterval; i++){
			
			CGPoint displacement = CGPointMake(self.center.x - _restCenter.x,
											   self.center.y - _restCenter.y);
			
			CGPoint kx = CGPointMake(_springConstant * displacement.x, _springConstant * displacement.y);
			CGPoint bv = CGPointMake(_dampingCoefficient	* _velocity.x, _dampingCoefficient * _velocity.y);
			CGPoint acceleration = CGPointMake((kx.x + bv.x) / _mass, (kx.y + bv.y) / _mass);
			
			_velocity.x -= (acceleration.x * displayLink.duration);
			_velocity.y -= (acceleration.y * displayLink.duration);
			
			CGPoint newCenter = self.center;
			newCenter.x += (_velocity.x * displayLink.duration);
			newCenter.y += (_velocity.y * displayLink.duration);
			[self setCenter:newCenter];
		}
	}
}

#pragma mark - Panning
- (void)viewWasPanned:(UIPanGestureRecognizer *)sender {
	
	CGPoint translation = CGPointApplyAffineTransform([sender translationInView:self.superview], CGAffineTransformMakeScale(_panDragCoefficient, _panDragCoefficient));
	CGPoint translatedCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
	
	if (translation.x > 0 && (translatedCenter.x - _restCenter.x) > _panDistanceLimits.right){
		translation.x -= (translatedCenter.x - _restCenter.x) - _panDistanceLimits.right;
	}
	else if (translation.x < 0 && (_restCenter.x - translatedCenter.x) > _panDistanceLimits.left){
		translation.x += (_restCenter.x - translatedCenter.x) - _panDistanceLimits.left;
	}
	
	if (translation.y > 0 && (translatedCenter.y - _restCenter.y) > _panDistanceLimits.bottom){
		translation.y -= (translatedCenter.y - _restCenter.y) - _panDistanceLimits.bottom;
	}
	else if (translation.y < 0 && (_restCenter.y - translatedCenter.y) > _panDistanceLimits.top){
		translation.y += (_restCenter.y - translatedCenter.y) - _panDistanceLimits.top;
	}
	
	[self setCenter:CGPointMake(self.center.x + translation.x, self.center.y + translation.y)];
	[sender setTranslation:CGPointZero inView:self.superview];
	
	BOOL finished = (sender.state == UIGestureRecognizerStateEnded);
	if (finished && _inheritsPanVelocity) _velocity = [sender velocityInView:self.superview];
	
	if (_pannedBlock) _pannedBlock(self.center, _restCenter, translation, [sender velocityInView:self.superview], finished);
	
	[self positionLeftAnchoredViewsWithRecognizer:sender];
	[self positionRightAnchoredViewsWithRecognizer:sender];
}

- (void)positionLeftAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer {
	
	if (_leftAnchoredView){
		BOOL stopSpringing = NO;
		if ((stopSpringing = (CGRectGetMinX(self.frame) > (_leftAnchoredView.restCenter.x + _leftAnchoredView.bounds.size.width / 2)))){
			CGRect newFrame = _leftAnchoredView.frame;
			newFrame.origin.x = CGRectGetMinX(self.frame) - _leftAnchoredView.frame.size.width;
			[_leftAnchoredView setFrame:newFrame];
		}
		
		[_leftAnchoredView setSpringEnabled:(!stopSpringing || recognizer.state == UIGestureRecognizerStateEnded)];
		[_leftAnchoredView positionLeftAnchoredViewsWithRecognizer:recognizer];
	}
}

- (void)positionRightAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer {
	
	if (_rightAnchoredView){
		BOOL stopSpringing = NO;
		if ((stopSpringing = (CGRectGetMaxX(self.frame) < (_rightAnchoredView.restCenter.x - _rightAnchoredView.bounds.size.width / 2)))){
			CGRect newFrame = _rightAnchoredView.frame;
			newFrame.origin.x = CGRectGetMaxX(self.frame);
			[_rightAnchoredView setFrame:newFrame];
		}
		
		[_rightAnchoredView setSpringEnabled:(!stopSpringing || recognizer.state == UIGestureRecognizerStateEnded)];
		[_rightAnchoredView positionRightAnchoredViewsWithRecognizer:recognizer];
	}
}

#pragma mark - Memory Management

@end