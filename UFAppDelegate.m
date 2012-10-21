//
//  iDecideAppDelegate.m
//  iDecide
//
//  Created by Moshe Berman on 3/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "UFAppDelegate.h"
#import "iDecideViewController.h"
#import "Phrases.h"
#import "phraseDetail.h"
#import "NavController.h"

@implementation UFAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"previouslyrun"] != YES){
		
		/* set the custom phrases */

		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound_preference"];
		
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"eyebrows_preference"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"custom_preference"];
		
		NSArray *tempreplies = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ShakenList" ofType:@"plist"]];
		[[NSUserDefaults standardUserDefaults] setObject:tempreplies forKey:@"customphrases"];
		
		// Remember that we have gone through first run before //
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"previouslyrun"];
	}
	
    // Override point for customization after app launch    
    [[self window] setRootViewController:[self viewController]];
    [[self window] makeKeyAndVisible];
}




@end