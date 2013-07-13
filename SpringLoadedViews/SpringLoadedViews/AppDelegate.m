//
//  AppDelegate.m
//  SpringLoadedViews
//
//  Created by Tom Irving on 27/10/2012.
//  Copyright (c) 2012 Tom Irving. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	RootViewController * rootViewController = [[RootViewController alloc] init];
	[window setRootViewController:rootViewController];
	
	[window makeKeyAndVisible];
	
    return YES;
}


@end
