//
//  TISpringLoadedView.m
//  TISpringLoadedViews
//
//  Created by Tom Irving on 18/09/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "TISpringLoadedView.h"
#import <QuartzCore/QuartzCore.h>

TISpringLoadedViewDistanceLimits TISpringLoadedViewDistanceLimitsMake(CGFloat nX, CGFloat pX, CGFloat nY, CGFloat pY){
	TISpringLoadedViewDistanceLimits limits;
	limits.negativeX = nX;
	limits.positiveX = pX;
	limits.negativeY = nY;
	limits.positiveY = pY;
	return limits;
}

@interface TISpringLoadedView (Private)
- (void)positionLeftAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)positionRightAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer;
@end

@implementation TISpringLoadedView
@synthesize mass;
@synthesize springConstant;
@synthesize dampingCoefficient;
@synthesize panDragCoefficient;
@synthesize panDistanceLimits;
@synthesize restCenter;
@synthesize pannedBlock;
@synthesize inheritsPanVelocity;
@synthesize springEnabled;
@synthesize leftAnchoredView;
@synthesize rightAnchoredView;

- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])) {
		
		springEnabled = YES;
		
		restCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
		springConstant = 250;
		dampingCoefficient = 20;
		mass = 1;
		velocity = CGPointZero;
		
		panDistanceLimits = TISpringLoadedViewDistanceLimitsMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX);
		pannedBlock = nil;
		panDragCoefficient = 1.0;
		inheritsPanVelocity = NO;
		
		panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasPanned:)];
		[self addGestureRecognizer:panGestureRecognizer];
		[panGestureRecognizer release];
    }
	
    return self;
}

#pragma mark - Property Overrides
- (BOOL)panning {
	return (panGestureRecognizer.state == UIGestureRecognizerStateChanged);
}

#pragma mark - Physics
- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink {
	
	if (springEnabled && !self.panning){
		for (int i = 0; i < displayLink.frameInterval; i++){
			
			CGPoint displacement = CGPointMake(self.center.x - restCenter.x,
											   self.center.y - restCenter.y);
			
			CGPoint kx = CGPointMake(springConstant * displacement.x, springConstant * displacement.y);
			CGPoint bv = CGPointMake(dampingCoefficient	* velocity.x, dampingCoefficient * velocity.y);
			CGPoint acceleration = CGPointMake((kx.x + bv.x) / mass, (kx.y + bv.y) / mass);
			
			velocity.x -= (acceleration.x * displayLink.duration);
			velocity.y -= (acceleration.y * displayLink.duration);
			
			CGPoint newCenter = self.center;
			newCenter.x += (velocity.x * displayLink.duration);
			newCenter.y += (velocity.y * displayLink.duration);
			[self setCenter:newCenter];
		}
	}
}

#pragma mark - Panning
- (void)viewWasPanned:(UIPanGestureRecognizer *)sender {
	
	CGPoint translation = CGPointApplyAffineTransform([sender translationInView:self.superview], CGAffineTransformMakeScale(panDragCoefficient, panDragCoefficient));
	CGPoint translatedCenter = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
	
	if (translation.x > 0 && (translatedCenter.x - restCenter.x) > panDistanceLimits.positiveX){
		translation.x -= (translatedCenter.x - restCenter.x) - panDistanceLimits.positiveX;
	}
	else if (translation.x < 0 && (restCenter.x - translatedCenter.x) > panDistanceLimits.negativeX){
		translation.x += (restCenter.x - translatedCenter.x) - panDistanceLimits.negativeX;
	}
	
	if (translation.y > 0 && (translatedCenter.y - restCenter.y) > panDistanceLimits.positiveY){
		translation.y -= (translatedCenter.y - restCenter.y) - panDistanceLimits.positiveY;
	}
	else if (translation.y < 0 && (restCenter.y - translatedCenter.y) > panDistanceLimits.negativeY){
		translation.y += (restCenter.y - translatedCenter.y) - panDistanceLimits.negativeY;
	}
	
	[self setCenter:CGPointMake(self.center.x + translation.x, self.center.y + translation.y)];
	[sender setTranslation:CGPointZero inView:self.superview];
	
	BOOL finished = (sender.state == UIGestureRecognizerStateEnded);
	if (finished && inheritsPanVelocity) velocity = [sender velocityInView:self.superview];
	
	if (pannedBlock) pannedBlock(self.center, restCenter, translation, [sender velocityInView:self.superview], finished);
	
	[self positionLeftAnchoredViewsWithRecognizer:sender];
	[self positionRightAnchoredViewsWithRecognizer:sender];
}

- (void)positionLeftAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer {
	
	if (leftAnchoredView){
		BOOL stopSpringing = NO;
		if ((stopSpringing = (CGRectGetMinX(self.frame) > (leftAnchoredView.restCenter.x + leftAnchoredView.bounds.size.width / 2)))){
			CGRect newFrame = leftAnchoredView.frame;
			newFrame.origin.x = CGRectGetMinX(self.frame) - leftAnchoredView.frame.size.width;
			[leftAnchoredView setFrame:newFrame];
		}
		
		[leftAnchoredView setSpringEnabled:(!stopSpringing || recognizer.state == UIGestureRecognizerStateEnded)];
		[leftAnchoredView positionLeftAnchoredViewsWithRecognizer:recognizer];
	}
}

- (void)positionRightAnchoredViewsWithRecognizer:(UIPanGestureRecognizer *)recognizer {
	
	if (rightAnchoredView){
		BOOL stopSpringing = NO;
		if ((stopSpringing = (CGRectGetMaxX(self.frame) < (rightAnchoredView.restCenter.x - rightAnchoredView.bounds.size.width / 2)))){
			CGRect newFrame = rightAnchoredView.frame;
			newFrame.origin.x = CGRectGetMaxX(self.frame);
			[rightAnchoredView setFrame:newFrame];
		}
		
		[rightAnchoredView setSpringEnabled:(!stopSpringing || recognizer.state == UIGestureRecognizerStateEnded)];
		[rightAnchoredView positionRightAnchoredViewsWithRecognizer:recognizer];
	}
}

#pragma mark - Memory Management
- (void)dealloc {
	[pannedBlock release];
	[super dealloc];
}

@end