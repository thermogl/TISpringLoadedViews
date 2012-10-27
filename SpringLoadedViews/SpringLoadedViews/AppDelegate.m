//
//  AppDelegate.m
//  SpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window makeKeyAndVisible];
	
    return YES;
}

- (void)dealloc {
	[window release];
    [super dealloc];
}

@end
