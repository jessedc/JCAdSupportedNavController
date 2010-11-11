//
//  JCAdSupportedNavigationController.h
//  
//
//  Created by Jesse Collis <jesse@jcmultimedia.com.au> on 09/11/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface JCAdSupportedNavController : UINavigationController <ADBannerViewDelegate>{
	ADBannerView *adView;
	BOOL adBannerIsVisible;
}

@property (nonatomic, retain) IBOutlet ADBannerView *adView;
@property (nonatomic, assign) BOOL adBannerIsVisible;

-(void)showAdBanner;
-(void)hideAdBanner;

@end
