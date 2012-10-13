//
//  UIDownloadBarAppDelegate.m
//  UIDownloadBar
//
//  Created by SAKrisT on 4/28/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UIDownloadBarAppDelegate.h"
#import "UIDownloadBar.h"

@implementation UIDownloadBarAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
	
	
	bar = [[UIDownloadBar alloc] initWithURL:[NSURL URLWithString:@"https://dl-ssl.google.com/chrome/mac/stable/GGRM/googlechrome.dmg"]
							progressBarFrame:CGRectMake(30, 100, 200, 20)
									 timeout:15 
									delegate:self];
	
	[window addSubview:bar];
	[bar release];
	
}

- (void)applicationWillTerminate:(UIApplication *)application{
}



- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename {
	NSLog(@"%@", filename);
}

- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error {
	NSLog(@"%@", error);
}

- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar {}



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
    [window release];
    [super dealloc];
}

@end

