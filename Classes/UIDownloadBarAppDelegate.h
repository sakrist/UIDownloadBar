//
//  UIDownloadBarAppDelegate.h
//  UIDownloadBar
//
//  Created by SAKrisT on 4/28/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDownloadBar.h"



@interface UIDownloadBarAppDelegate : NSObject <UIApplicationDelegate, UIDownloadBarDelegate> {
    UIWindow *window;
	
	UIDownloadBar *bar;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
