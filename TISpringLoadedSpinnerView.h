//
//  TISpringLoadedSpinnerView.h
//  TISpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TISpringLoadedSpinnerView : UIView {
	
	CGFloat rotation;
	CGFloat restRotation;
	CGFloat springConstant;
	CGFloat dampingCoefficient;
	CGFloat mass;
	CGFloat velocity;
}

@property (nonatomic, assign) CGFloat springConstant;
@property (nonatomic, assign) CGFloat dampingCoefficient;
@property (nonatomic, assign) CGFloat mass;

- (void)simulateSpringWithDisplayLink:(CADisplayLink *)displayLink;

@end
