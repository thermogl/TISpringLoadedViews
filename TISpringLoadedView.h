//
//  TISpringLoadedView.h
//  SpringLoadedViews
//
//  Created by Tom Irving on 18/09/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SpringLoadedViewPannedBlock)(CGPoint center, CGPoint restCenter, CGPoint translation, CGPoint velocity, BOOL finished);

typedef struct {
	CGFloat negativeX;
	CGFloat positiveX;
	CGFloat negativeY;
	CGFloat positiveY;
} SpringLoadedViewDistanceLimits;

SpringLoadedViewDistanceLimits SpringLoadedViewDistanceLimitsMake(CGFloat nX, CGFloat pX, CGFloat nY, CGFloat pY);

@interface SpringLoadedView : UIView {
	
	BOOL springEnabled;
	
	CGPoint restCenter;
	CGFloat springConstant;
	CGFloat dampingCoefficient;
	CGFloat mass;
	CGPoint velocity;
	
	SpringLoadedViewDistanceLimits panDistanceLimits;
	SpringLoadedViewPannedBlock pannedBlock;
	CGFloat panDragCoefficient;
	
	UIPanGestureRecognizer * panGestureRecognizer;
	
	SpringLoadedView * leftAnchoredView;
	SpringLoadedView * rightAnchoredView;
}

@property (nonatomic, assign) BOOL springEnabled;
@property (nonatomic, assign) CGFloat springConstant;
@property (nonatomic, assign) CGFloat dampingCoefficient;
@property (nonatomic, assign) CGPoint restCenter;
@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) SpringLoadedViewDistanceLimits panDistanceLimits;
@property (nonatomic, copy) SpringLoadedViewPannedBlock pannedBlock;
@property (nonatomic, assign) CGFloat panDragCoefficient;
@property (nonatomic, readonly) BOOL panning;
@property (nonatomic, assign) SpringLoadedView * leftAnchoredView;
@property (nonatomic, assign) SpringLoadedView * rightAnchoredView;

- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink;

@end