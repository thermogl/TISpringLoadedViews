//
//  TISpringLoadedView.h
//  TISpringLoadedViews
//
//  Created by Tom Irving on 18/09/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TISpringLoadedViewPannedBlock)(CGPoint center, CGPoint restCenter, CGPoint translation, CGPoint velocity, BOOL finished);

typedef struct {
	CGFloat negativeX;
	CGFloat positiveX;
	CGFloat negativeY;
	CGFloat positiveY;
} TISpringLoadedViewDistanceLimits;

TISpringLoadedViewDistanceLimits TISpringLoadedViewDistanceLimitsMake(CGFloat nX, CGFloat pX, CGFloat nY, CGFloat pY);

@interface TISpringLoadedView : UIView {
	
	BOOL springEnabled;
	
	CGPoint restCenter;
	CGFloat springConstant;
	CGFloat dampingCoefficient;
	CGFloat mass;
	CGPoint velocity;
	
	TISpringLoadedViewDistanceLimits panDistanceLimits;
	TISpringLoadedViewPannedBlock pannedBlock;
	CGFloat panDragCoefficient;
	
	UIPanGestureRecognizer * panGestureRecognizer;
	
	TISpringLoadedView * leftAnchoredView;
	TISpringLoadedView * rightAnchoredView;
}

@property (nonatomic, assign) BOOL springEnabled;
@property (nonatomic, assign) CGFloat springConstant;
@property (nonatomic, assign) CGFloat dampingCoefficient;
@property (nonatomic, assign) CGPoint restCenter;
@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) TISpringLoadedViewDistanceLimits panDistanceLimits;
@property (nonatomic, copy) TISpringLoadedViewPannedBlock pannedBlock;
@property (nonatomic, assign) CGFloat panDragCoefficient;
@property (nonatomic, readonly) BOOL panning;
@property (nonatomic, assign) TISpringLoadedView * leftAnchoredView;
@property (nonatomic, assign) TISpringLoadedView * rightAnchoredView;

- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink;

@end