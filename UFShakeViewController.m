//
//  iDecideViewController.m
//  iDecide
//
//  Created by Moshe Berman on 3/8/10.
//  Copyright Moshe Berman 2010. All rights reserved.
//

#import "UFShakeViewController.h"
#import "UFPhrasesListViewController.h"
#import "UFPhraseDetailEditorViewController.h"
#import <Twitter/Twitter.h>


@implementation UFShakeViewController

#pragma mark - Custom Methods
/* Generate random label and apply it */

-(void)genRandom:(BOOL)deviceWasShaken{
	[self toggleEyebrows:nil];
	if(deviceWasShaken == TRUE){
		
		NSString *str = [NSString stringWithFormat: @"%@", [[self shakeReplies] objectAtIndex:(arc4random() % [[self shakeReplies] count])]];
		[self decisionText].text = str;
	}else{
		if([[NSUserDefaults standardUserDefaults] boolForKey:@"sound_preference"] == YES){
		
			NSURL *url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"poke" ofType:@"aif"]];
			
			NSError *error = NULL;
			AVAudioPlayer *myplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
			if(!error) { 
                [myplayer play];
            }
		}
		NSString *str = [NSString stringWithFormat: @"%@", [[self pokeReplies] objectAtIndex:(arc4random() % [[self pokeReplies] count])]];
		[self decisionText].text = str;
	}
	
}

-(IBAction)buttonPressed:(id)sender{
	[self genRandom:FALSE];
}

/* Show Credits */

-(IBAction)showCredits:(id)sender{

	UFCreditsViewController *cr = [[UFCreditsViewController alloc] initWithNibName:@"Credits" bundle:nil];
	
	[cr.view setFrame:CGRectMake(0, 0, (self.view.frame.size.width), (self.view.frame.size.height))];
	
	self.creditsView = cr;
	
	[self.view addSubview:[self creditsView].view];
	[self attachPopUpAnimation];
	
}

- (CAKeyframeAnimation *) attachPopUpAnimation{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	
	CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
	CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
	CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
	CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
	
	NSArray *frameValues = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale3],
							[NSValue valueWithCATransform3D:scale4],
							nil];
	[animation setValues:frameValues];
	
	NSArray *frameTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.0],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:0.9],
						   [NSNumber numberWithFloat:1.0],
						   nil];    
	[animation setKeyTimes:frameTimes];
	
	animation.fillMode = kCAFillModeForwards;
	animation.removedOnCompletion = NO;
	animation.duration = 0.255;
	
	[self.creditsView.view.layer addAnimation:animation forKey:@"popup"];
	
	return animation;
}

#pragma mark -  Edit Phrases

-(IBAction)showEditPhrases:(id)sender{

	UFPhrasesListViewController *phrasesTable = [[UFPhrasesListViewController alloc] initWithStyle:UITableViewStyleGrouped];
	UINavigationController *phrasesNavigationController = [[UINavigationController alloc] initWithRootViewController:phrasesTable];

    [self presentViewController:phrasesNavigationController animated:YES completion:nil];
}

/* Change eyebrows */
-(IBAction)toggleEyebrows:(id)sender{
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"eyebrows_preference"] == YES){
		NSArray *hairstyles = @[@"complete_shadow", @"black_hair", @"leaf_hair", @"purple_hair", @"purple_shiny", @"yellow_shiny", @"yellow_flower", @"pastel_hair", @"pastel_brown", @"polka", @"shiny_black", @"orange", @"orange_peel", @"giraffe"];
        
		NSString *hairTitle = [NSString stringWithFormat: @"%@", [hairstyles objectAtIndex:(arc4random() % [hairstyles count])]];
		UIImage * hairStyle = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:hairTitle ofType:@"png"]];
		[[self eyebrows] setImage:hairStyle];
	}
}

#pragma mark  "Shaking began" method 
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"sound_preference"] == YES){
		NSError *error;
		NSURL *url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shake_short" ofType:@"mp3"]];
		AVAudioPlayer *myplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
		if(!error) { [myplayer play]; }
	}
	[self genRandom:TRUE];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}


- (void) viewWillAppear:(BOOL)animated{
		//ensure that custom phrases are effective immediately, without restarting the app.
		[[self shakeReplies] removeAllObjects];
		[[self shakeReplies] addObjectsFromArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"customphrases"]];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"custom_preference"] == NO){
		[self editorButton].hidden = YES;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self decisionText].text = @"Hi, I'm Uncle Fred. \n Shake me.";
    
    self.pokeReplies = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"PokedList" ofType:@"plist"]];
    self.shakeReplies = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"customphrases"] ];
    
    if (![TWTweetComposeViewController canSendTweet]) {
        self.tweetButton.hidden = YES;
    }
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

#pragma mark -

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return interfaceOrientation == UIDeviceOrientationPortrait;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.

    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

-(void) viewWillUnload{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    [self setTweetButton:nil];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)sendTweet{
    TWTweetComposeViewController *composer = [[TWTweetComposeViewController alloc] init];
    
    [composer setInitialText:[self decisionText].text];
    
    [self presentViewController:composer animated:YES completion:^{
        
    }];

}


@end
