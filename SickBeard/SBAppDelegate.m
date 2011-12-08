//
//  SBAppDelegate.m
//  SickBeard
//
//  Created by Colin Humber on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SBAppDelegate.h"
#import "SBServer.h"
#import "SBServerDetailsViewController.h"
#import "SickbeardAPIClient.h"
#import "SDURLCache.h"
#import "SBITunesUrlCache.h"

@implementation SBAppDelegate

@synthesize window = _window;

+ (void)initialize {
	NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[TestFlight takeOff:@"9677d08cdc79deabbe7610f9edb5b4f9_MzY5MTgyMDExLTEwLTI1IDIyOjUwOjMxLjg0Mjg3OA"];

	SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
														 diskCapacity:1024*1024*5 // 5MB disk cache
															 diskPath:[SDURLCache defaultCachePath]];
	[NSURLCache setSharedURLCache:urlCache];
	
	SBServer *server = [NSUserDefaults standardUserDefaults].server;
	
	if (!server) {
		[self.window makeKeyAndVisible];

		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
		SBServerDetailsViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SBServerDetailsViewController"];
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
		
		[self.window.rootViewController presentViewController:nav animated:NO completion:nil];
	}
	else {
		[[SickbeardAPIClient sharedClient] loadDefaults:server];
		[SickbeardAPIClient sharedClient].currentServer = server;
		[self.window makeKeyAndVisible];
	}
	
	[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] 
									   forBarMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:RGBCOLOR(33, 95, 47)];
	[[UISegmentedControl appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:RGBCOLOR(122, 134, 0)];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[SBITunesUrlCache sharedCache] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
