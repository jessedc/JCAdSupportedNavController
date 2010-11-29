//
//  JCAdSupportedNavigationController.h
//  
//
//  Created by Jesse Collis <jesse@jcmultimedia.com.au> on 09/11/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AdMobDelegateProtocol.h"

@class AdMobView;
@interface JCAdSupportedNavController : UINavigationController <ADBannerViewDelegate, AdMobDelegate>{
	ADBannerView *adView;
	AdMobView *adMobView;
	
	BOOL adBannerIsVisible;
	BOOL adMobBannerIsVisible;
}

@property (nonatomic, retain) ADBannerView *adView;
@property (nonatomic, assign) BOOL adBannerIsVisible;

@property (nonatomic, retain) AdMobView *adMobView;
@property (nonatomic, assign) BOOL adMobBannerIsVisible;

-(void)initAdBannerView;
-(void)showAdBanner;
-(void)hideAdBanner;

-(void)initAdMobView;
-(void)refreshAdMobBanner:(NSTimer *)timer;
-(void)showAdMobBanner;
-(void)hideAdMobBanner;

@end
