//
//  AccSimAppDelegate.m
//  AccSim
//
//  Created by Otto Chrons on 9/24/08.
//  Copyright Enzymia Ltd. 2008. All rights reserved.
//

#import "AccSimAppDelegate.h"
#import "AccelerometerViewController.h"
#import "NetworkView.h"

@implementation AccSimAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize accelerometerViewController;
@synthesize networkView;

// 50Hz is quite good for simulation performance
#define kAccelerometerFrequency     50

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	accelerometerViewController = [[AccelerometerViewController alloc] initWithNibName:@"AccelerometerView" bundle:nil];
	[[[[tabBarController viewControllers] objectAtIndex:0] view] addSubview:[accelerometerViewController view]];

	networkView = [[NetworkView alloc] initWithNibName:@"NetworkView" bundle:nil];
	[[[[tabBarController viewControllers] objectAtIndex:1] view] addSubview:[networkView view]];

	[window addSubview:[tabBarController view]];
	
	// Override point for customization after app launch	
	[window makeKeyAndVisible];

    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
    [[UIAccelerometer sharedAccelerometer] setDelegate:accelerometerViewController];
}



/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
	[networkView release];
	[accelerometerViewController release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

