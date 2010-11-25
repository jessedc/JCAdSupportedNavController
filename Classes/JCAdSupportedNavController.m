//
//  JCAdSupportedNavigationController.m
//  
//
//  Created by Jesse Collis <jesse@jcmultimedia.com.au> on 09/11/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import "JCAdSupportedNavController.h"

@implementation JCAdSupportedNavController
@synthesize adView, adBannerIsVisible;


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	if (NSClassFromString(@"ADBannerView")) {
		// Setup AdView
		adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 0, 0)]; //put off the end of the view's bounds.
		
		// ADBannerContentSizeIdentifier320x50 and ADBannerContentSizeIdentifier480x32 are deprecated in iOS 4.2
		// To make things work into the future, we will use them if we notice they're available.
		// This also prevents ugly deprecated messages too.
		
		if (&ADBannerContentSizeIdentifierPortrait != nil && &ADBannerContentSizeIdentifierLandscape != nil) {
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
			adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
		}else{
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
			adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32, nil];			
		}
		
		adView.delegate = self;
		adView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		
		// Add the navigation controller's view to the window and display.
		[self.view addSubview:adView];
	}
	self.adBannerIsVisible = NO;
}

#define iAdDelegate Callbacks
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	NSLog(@"Banner Did Load");
	[self showAdBanner];
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    BOOL shouldExecuteAction = YES; //[self allowActionToRun]; // your application implements this method
    if (!willLeave && shouldExecuteAction)
    {
        // insert code here to suspend any services that might conflict with the advertisement
    }
    return shouldExecuteAction;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
	NSLog(@"Banner Did Finish Load");
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
	NSLog(@"bannerView did fail %@",[error userInfo]);
	//Because demo isn't really working;
	[self hideAdBanner];	
}

-(void)showAdBanner{
    if (!self.adBannerIsVisible)
    {
		UIView *contentView = [self.view.subviews objectAtIndex:0];
        CGRect originalViewFrame = contentView.frame;
		CGRect adFrame = self.adView.frame;
		
		adFrame.origin.y = self.view.frame.size.height - adFrame.size.height;
		originalViewFrame.size.height = self.view.frame.size.height - adFrame.size.height;
		
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        adView.frame = adFrame;
		contentView.frame = originalViewFrame;
		[UIView commitAnimations];
        self.adBannerIsVisible = YES;
    }	
}
-(void)hideAdBanner{
	if (self.adBannerIsVisible) {
		UIView *contentView = [self.view.subviews objectAtIndex:0];
        CGRect originalViewFrame = contentView.frame;
		CGRect adFrame = adView.frame;
		
		originalViewFrame.size.height = self.view.frame.size.height; 
		adFrame.origin.y = self.view.frame.size.height;
		
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        adView.frame = adFrame;
		contentView.frame = originalViewFrame;
		
		[UIView commitAnimations];
        self.adBannerIsVisible = NO;
	}
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
		if (&ADBannerContentSizeIdentifierLandscape != nil) {
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
		}else {
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
		}
	}else{
		if (&ADBannerContentSizeIdentifierPortrait != nil) {
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
		}else{
			adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;	
		}
		
	}
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{	
	// This code will alter the content view 
	if(self.adBannerIsVisible ) {
		int delta = 18;
		if (&ADBannerContentSizeIdentifierPortrait != nil && &ADBannerContentSizeIdentifierLandscape != nil) {
			if (adView.currentContentSizeIdentifier == ADBannerContentSizeIdentifierPortrait) {
				delta *= -1;
			}
		}else {
			if (adView.currentContentSizeIdentifier == ADBannerContentSizeIdentifier320x50) {
				delta *= -1;
			}
		}		
		// Not 100% sure if this is a documented way to get the container view for the navigationController, but it works in limited tests.
		UIView *contentView = [self.view.subviews objectAtIndex:0];
		CGRect originalViewFrame = contentView.frame;
		originalViewFrame.size.height = originalViewFrame.size.height + delta;
		contentView.frame = originalViewFrame;
	}
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[adView release];
    [super viewDidUnload];
}


- (void)dealloc {
	[adView release];
    [super dealloc];
}


@end
